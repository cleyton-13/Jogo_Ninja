class_name Lutador
extends CharacterBody3D
## Um lutador da arena.
## Etapa 1: anda só no eixo X (estilo 2.5D) e sempre encara o oponente.
## Etapa 2: máquina de estados com golpe leve (combo), médio, pesado, defesa e esquiva.
## Etapa 3: vida, hitbox/hurtbox, dano, defesa reduz dano, pesado quebra defesa, K.O.
##
## O lutador não lê teclado nem toque. Quem manda nele é um "controlador"
## (ControleJogador agora, a IA na Etapa 4), chamando os métodos de ação abaixo.

signal acao_iniciada(nome: String)
signal vida_mudou(vida: float, vida_maxima: float)
signal acertou(alvo: Lutador, resultado: Resultado)
signal derrotado

enum Estado {
	LIVRE,
	GOLPE_LEVE,
	GOLPE_MEDIO,
	CARREGANDO_PESADO,
	GOLPE_PESADO,
	DEFENDENDO,
	ESQUIVANDO,
	ATINGIDO, ## tomou um golpe: fica sem agir por um instante (hitstun)
	ATORDOADO, ## teve a defesa quebrada
	DERROTADO,
}

## O que aconteceu quando um golpe encostou no alvo.
enum Resultado { ACERTOU, BLOQUEOU, QUEBROU_DEFESA, ESQUIVOU, IGNORADO }

const COMBO_MAXIMO := 5
const TEMPO_CARGA_TOTAL := 1.0 ## segurar por 1 s = pesado 100% carregado (dano x2)
const DURACAO_ESQUIVA := 0.3
const TEMPO_IMPULSO_ESQUIVA := 0.15
const INVULNERAVEL_NA_ESQUIVA := 0.2 ## no começo da esquiva nenhum golpe acerta
const DURACAO_QUEBRA_DEFESA := 0.7
const DANO_NA_DEFESA := 0.1 ## defendendo, só 10% do dano passa
const ATRITO_RECUO := 12.0 ## quão rápido o recuo de um golpe perde força (m/s²)

const ESTADOS_DE_GOLPE := [Estado.GOLPE_LEVE, Estado.GOLPE_MEDIO, Estado.GOLPE_PESADO]

@export var nome_exibicao := "Ninja"
@export var cor := Color("e0482f")
@export var vida_maxima := 1000.0
@export var velocidade_andar := 3.5 ## metros por segundo
@export var velocidade_esquiva := 9.0 ## impulso para trás da esquiva
@export var limite_arena := 7.0 ## até onde pode andar em X, para cada lado
@export var distancia_minima := 0.9 ## não deixa um lutador atravessar o outro

@export_group("Golpes")
@export var golpe_leve_dados: DadosGolpe
@export var golpe_medio_dados: DadosGolpe
@export var golpe_pesado_dados: DadosGolpe

var oponente: Lutador
var direcao_andar := 0.0 ## de -1 a 1, definido pelo controlador
var estado := Estado.LIVRE
var vida := 0.0
var golpe_no_combo := 0 ## 1 a 5 durante o combo leve
var carga_pesado := 0.0 ## de 0 a 1
var acoes_bloqueadas := false ## a arena trava as ações fora da luta (K.O., reinício)

## Há quanto tempo está no estado atual (só leitura; a IA usa para cronometrar).
var tempo_no_estado: float:
	get:
		return _tempo_no_estado

## +1 quando olha para a direita, -1 quando olha para a esquerda.
var frente: float:
	get:
		return 1.0 if is_zero_approx(_visual.rotation.y) else -1.0

var _tempo_no_estado := 0.0
var _leves_na_fila := 0 ## toques feitos durante um golpe leve, esperando para sair
var _golpe_atual: DadosGolpe
var _multiplicador_dano := 1.0
var _ja_acertou := false ## cada golpe acerta no máximo uma vez
var _duracao_atordoamento := 0.0
var _velocidade_recuo := 0.0
var _forma_hitbox := BoxShape3D.new()
var _material: StandardMaterial3D
var _tween_texto: Tween
var _tween_piscar: Tween
var _gravidade: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var _visual: Node3D = $Visual
@onready var _corpo: MeshInstance3D = $Visual/Corpo
@onready var _golpe_visual: MeshInstance3D = $Visual/Golpe
@onready var _escudo: MeshInstance3D = $Visual/Escudo
@onready var _hitbox: Area3D = $Visual/Hitbox
@onready var _texto: Label3D = $TextoAcao


func _ready() -> void:
	_material = StandardMaterial3D.new()
	_material.albedo_color = cor
	_corpo.material_override = _material
	# Cada lutador tem sua própria forma de hitbox (o tamanho muda a cada golpe).
	$Visual/Hitbox/Forma.shape = _forma_hitbox
	_texto.modulate.a = 0.0
	vida = vida_maxima
	_atualizar_visual()


# --- Ações (chamadas pelo controlador) -------------------------------------


func golpe_leve() -> void:
	if estado == Estado.GOLPE_LEVE:
		# Tocou de novo durante o golpe: entra na fila para encadear o combo.
		_leves_na_fila = mini(_leves_na_fila + 1, COMBO_MAXIMO - golpe_no_combo)
		return
	if not _pode_iniciar():
		return
	golpe_no_combo = 1
	_iniciar_golpe(Estado.GOLPE_LEVE, golpe_leve_dados, "Leve 1")


func golpe_medio() -> void:
	# O médio pode sair do nada ou fechar um combo de leves.
	if not acoes_bloqueadas and estado in [Estado.LIVRE, Estado.GOLPE_LEVE]:
		_iniciar_golpe(Estado.GOLPE_MEDIO, golpe_medio_dados, "Médio")


func iniciar_pesado() -> void:
	if _pode_iniciar():
		carga_pesado = 0.0
		_entrar(Estado.CARREGANDO_PESADO, "Carregando...")


func soltar_pesado() -> void:
	if estado == Estado.CARREGANDO_PESADO:
		var nome := "Pesado! %d%%" % roundi(carga_pesado * 100.0)
		_iniciar_golpe(Estado.GOLPE_PESADO, golpe_pesado_dados, nome, 1.0 + carga_pesado)


func defender(ativo: bool) -> void:
	if ativo and _pode_iniciar():
		_entrar(Estado.DEFENDENDO, "Defesa")
	elif not ativo and estado == Estado.DEFENDENDO:
		_entrar(Estado.LIVRE)


func esquivar() -> void:
	if not acoes_bloqueadas and estado in [Estado.LIVRE, Estado.DEFENDENDO]:
		_entrar(Estado.ESQUIVANDO, "Esquiva")


# --- Receber golpes ----------------------------------------------------------


## Chamado pelo atacante quando a hitbox dele encosta na nossa hurtbox.
## direcao_empurrao: +1 empurra para a direita, -1 para a esquerda.
func receber_golpe(golpe: DadosGolpe, multiplicador: float, direcao_empurrao: float) -> Resultado:
	if estado == Estado.DERROTADO:
		return Resultado.IGNORADO

	if estado == Estado.ESQUIVANDO and _tempo_no_estado < INVULNERAVEL_NA_ESQUIVA:
		_mostrar_texto("Esquivou!")
		return Resultado.ESQUIVOU

	if estado == Estado.DEFENDENDO:
		_velocidade_recuo = direcao_empurrao * golpe.empurrao * 0.5
		if golpe.quebra_defesa:
			_duracao_atordoamento = DURACAO_QUEBRA_DEFESA
			_entrar(Estado.ATORDOADO, "Defesa quebrada!")
			return Resultado.QUEBROU_DEFESA
		_aplicar_dano(golpe.dano * multiplicador * DANO_NA_DEFESA)
		_mostrar_texto("Bloqueou")
		return Resultado.BLOQUEOU

	_aplicar_dano(golpe.dano * multiplicador)
	_velocidade_recuo = direcao_empurrao * golpe.empurrao
	golpe_no_combo = 0
	carga_pesado = 0.0
	_piscar()
	if vida <= 0.0:
		_entrar(Estado.DERROTADO, "K.O.")
		derrotado.emit()
	else:
		_duracao_atordoamento = golpe.atordoamento
		_entrar(Estado.ATINGIDO)
	return Resultado.ACERTOU


## Volta ao começo da rodada.
func reiniciar(posicao_x: float) -> void:
	vida = vida_maxima
	vida_mudou.emit(vida, vida_maxima)
	position = Vector3(posicao_x, 0.0, 0.0)
	velocity = Vector3.ZERO
	_velocidade_recuo = 0.0
	golpe_no_combo = 0
	carga_pesado = 0.0
	_golpe_atual = null
	_visual.rotation.z = 0.0
	_entrar(Estado.LIVRE)


# --- Loop de física ----------------------------------------------------------


func _physics_process(delta: float) -> void:
	_tempo_no_estado += delta
	_atualizar_estado()
	_verificar_acerto()

	if not is_on_floor():
		velocity.y -= _gravidade * delta
	_velocidade_recuo = move_toward(_velocidade_recuo, 0.0, ATRITO_RECUO * delta)
	velocity.x = _velocidade_horizontal()
	velocity.z = 0.0
	move_and_slide()

	# Mantém o lutador no "trilho" 2.5D e dentro da arena.
	position.z = 0.0
	position.x = clampf(position.x, -limite_arena, limite_arena)

	if estado != Estado.DERROTADO:
		_encarar_oponente()
	_golpe_visual.visible = _na_janela_ativa()


func _atualizar_estado() -> void:
	match estado:
		Estado.CARREGANDO_PESADO:
			carga_pesado = minf(_tempo_no_estado / TEMPO_CARGA_TOTAL, 1.0)
		Estado.GOLPE_LEVE, Estado.GOLPE_MEDIO, Estado.GOLPE_PESADO:
			if _tempo_no_estado >= _golpe_atual.duracao:
				_terminar_golpe()
		Estado.ESQUIVANDO:
			if _tempo_no_estado >= DURACAO_ESQUIVA:
				_entrar(Estado.LIVRE)
		Estado.ATINGIDO, Estado.ATORDOADO:
			if _tempo_no_estado >= _duracao_atordoamento:
				_entrar(Estado.LIVRE)


func _terminar_golpe() -> void:
	var continuar_combo := (
		estado == Estado.GOLPE_LEVE
		and _leves_na_fila > 0
		and golpe_no_combo < COMBO_MAXIMO
	)
	if continuar_combo:
		_leves_na_fila -= 1
		golpe_no_combo += 1
		_iniciar_golpe(Estado.GOLPE_LEVE, golpe_leve_dados, "Leve %d" % golpe_no_combo, 1.0, true)
	else:
		golpe_no_combo = 0
		_entrar(Estado.LIVRE)


## Durante a janela ativa, se a hitbox encostar na hurtbox do oponente, acerta.
func _verificar_acerto() -> void:
	if _ja_acertou or not _na_janela_ativa():
		return
	for area: Area3D in _hitbox.get_overlapping_areas():
		var alvo := area.get_parent() as Lutador
		if alvo == null or alvo == self:
			continue
		_ja_acertou = true
		var resultado := alvo.receber_golpe(_golpe_atual, _multiplicador_dano, frente)
		if resultado != Resultado.IGNORADO:
			acertou.emit(alvo, resultado)
		return


func _na_janela_ativa() -> bool:
	return (
		estado in ESTADOS_DE_GOLPE
		and _tempo_no_estado >= _golpe_atual.inicio_ativo
		and _tempo_no_estado <= _golpe_atual.fim_ativo
	)


func _velocidade_horizontal() -> float:
	var base := 0.0
	match estado:
		Estado.LIVRE:
			if not acoes_bloqueadas:
				base = _bloquear_avanco_no_oponente(direcao_andar) * velocidade_andar
		Estado.GOLPE_LEVE, Estado.GOLPE_MEDIO, Estado.GOLPE_PESADO:
			if _tempo_no_estado < _golpe_atual.tempo_avanco:
				base = _bloquear_avanco_no_oponente(frente) * _golpe_atual.avanco
		Estado.ESQUIVANDO:
			if _tempo_no_estado < TEMPO_IMPULSO_ESQUIVA:
				base = -frente * velocidade_esquiva
	return base + _velocidade_recuo


func _pode_iniciar() -> bool:
	return estado == Estado.LIVRE and not acoes_bloqueadas


func _iniciar_golpe(
	novo_estado: Estado, dados: DadosGolpe, nome: String,
	multiplicador := 1.0, manter_fila := false
) -> void:
	_golpe_atual = dados
	_multiplicador_dano = multiplicador
	_ja_acertou = false
	# A hitbox fica à frente do corpo e cresce conforme o alcance do golpe.
	_forma_hitbox.size = Vector3(dados.alcance, 0.6, 0.6)
	_hitbox.position = Vector3(0.3 + dados.alcance / 2.0, 1.15, 0.0)
	_entrar(novo_estado, nome, manter_fila)


func _entrar(novo_estado: Estado, nome_acao := "", manter_fila := false) -> void:
	estado = novo_estado
	_tempo_no_estado = 0.0
	if not manter_fila:
		_leves_na_fila = 0
	_atualizar_visual()
	if nome_acao != "":
		_mostrar_texto(nome_acao)
		acao_iniciada.emit(nome_acao)


func _aplicar_dano(valor: float) -> void:
	vida = maxf(vida - valor, 0.0)
	vida_mudou.emit(vida, vida_maxima)
	_mostrar_dano(valor)


## Os lutadores não colidem fisicamente entre si (camadas diferentes),
## então quem impede um de atravessar o outro é esta função.
func _bloquear_avanco_no_oponente(direcao: float) -> float:
	if oponente == null or direcao == 0.0:
		return direcao
	var para_oponente := oponente.global_position.x - global_position.x
	var indo_na_direcao_dele := signf(direcao) == signf(para_oponente)
	if indo_na_direcao_dele and absf(para_oponente) <= distancia_minima:
		return 0.0
	return direcao


func _encarar_oponente() -> void:
	if oponente == null:
		return
	var lado := signf(oponente.global_position.x - global_position.x)
	if lado != 0.0:
		# O modelo olha para +X por padrão; girar 180° faz olhar para -X.
		_visual.rotation.y = 0.0 if lado > 0.0 else PI


# --- Visual provisório (cápsulas) -------------------------------------------


func _atualizar_visual() -> void:
	_golpe_visual.scale = Vector3.ONE * (1.7 if estado == Estado.GOLPE_PESADO else 1.0)
	_escudo.visible = estado == Estado.DEFENDENDO
	# Agachadinha enquanto carrega o pesado; tombado quando derrotado.
	_corpo.scale = Vector3(1.1, 0.92, 1.1) if estado == Estado.CARREGANDO_PESADO else Vector3.ONE
	if estado == Estado.DERROTADO:
		create_tween().tween_property(_visual, "rotation:z", PI / 2.0, 0.35)


func _mostrar_texto(texto: String) -> void:
	_texto.text = texto
	_texto.modulate.a = 1.0
	if _tween_texto:
		_tween_texto.kill()
	_tween_texto = create_tween()
	_tween_texto.tween_interval(0.4)
	_tween_texto.tween_property(_texto, "modulate:a", 0.0, 0.3)


## Número de dano que sobe e some.
func _mostrar_dano(valor: float) -> void:
	var numero := Label3D.new()
	numero.text = str(roundi(valor))
	numero.font_size = 72
	numero.outline_size = 16
	numero.modulate = Color("f6b04a")
	numero.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	numero.no_depth_test = true
	get_parent().add_child(numero)
	numero.global_position = global_position + Vector3(randf_range(-0.2, 0.2), 2.0, 0.3)
	var tween := numero.create_tween().set_parallel()
	tween.tween_property(numero, "position:y", numero.position.y + 0.7, 0.6)
	tween.tween_property(numero, "modulate:a", 0.0, 0.6).set_delay(0.2)
	tween.chain().tween_callback(numero.queue_free)


## Pisca em branco ao ser atingido.
func _piscar() -> void:
	if _tween_piscar:
		_tween_piscar.kill()
	_material.albedo_color = Color.WHITE
	_tween_piscar = create_tween()
	_tween_piscar.tween_property(_material, "albedo_color", cor, 0.15)
