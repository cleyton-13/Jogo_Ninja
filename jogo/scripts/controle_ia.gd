class_name ControleIA
extends Node
## Controla um lutador sozinho (o oponente).
## Usa as MESMAS ações do jogador (golpe_leve, defender, esquivar...): a IA não
## tem golpes secretos nem lê o futuro — só vê o que o jogador está fazendo agora.
##
## A cada `intervalo_decisao` segundos ela olha a distância e escolhe um plano:
##   longe → aproximar (andando, ou com um golpe médio que avança)
##   perto → atacar (combo), quebrar a defesa com o pesado, defender ou recuar
## E, a qualquer momento, se perceber o jogador atacando, pode reagir
## (defender ou esquivar) depois do seu "tempo de reação".
## A dificuldade vem do PerfilIA (recursos/ia/*.tres).

const ALCANCE_CORPO_A_CORPO := 1.3 ## distância em que os golpes leves alcançam
const ALCANCE_INVESTIDA := 2.4 ## distância em que o golpe médio (que avança) alcança
const DISTANCIA_PERCEBER_ATAQUE := 2.6 ## ataques mais longe que isso são ignorados

@export var lutador: Lutador
@export var perfil: PerfilIA
@export var ativo := true

var _tempo_ate_decidir := 0.0
var _tempo_vendo_ataque := 0.0
var _ja_reagiu_a_este_ataque := false
var _tempo_defendendo := 0.0 ## quanto tempo ainda vai segurar a defesa
var _tempo_recuando := 0.0 ## quanto tempo ainda vai andar para trás
var _tempo_carregando := 0.0 ## quanto tempo ainda vai carregar o pesado
var _tamanho_combo := 0
var _medio_no_fim_do_combo := false


func _physics_process(delta: float) -> void:
	if not ativo or lutador == null or lutador.oponente == null:
		return
	var alvo := lutador.oponente
	_reagir_a_ataques(alvo, delta)
	_continuar_plano(delta)

	_tempo_ate_decidir -= delta
	var ocupada := _tempo_defendendo > 0.0 or _tempo_recuando > 0.0 or _tempo_carregando > 0.0
	if _tempo_ate_decidir <= 0.0 and lutador.estado == Lutador.Estado.LIVRE and not ocupada:
		_tempo_ate_decidir = perfil.intervalo_decisao * randf_range(0.7, 1.3)
		_decidir(alvo)


# --- Reação: o jogador está atacando? ---------------------------------------


func _reagir_a_ataques(alvo: Lutador, delta: float) -> void:
	var atacando := (
		alvo.estado in Lutador.ESTADOS_DE_GOLPE
		or alvo.estado == Lutador.Estado.CARREGANDO_PESADO
	)
	if not atacando:
		_tempo_vendo_ataque = 0.0
		_ja_reagiu_a_este_ataque = false
		return
	if _ja_reagiu_a_este_ataque or _distancia() > DISTANCIA_PERCEBER_ATAQUE:
		return

	# Ninguém reage na hora: espera o tempo de reação do perfil.
	_tempo_vendo_ataque += delta
	if _tempo_vendo_ataque < perfil.tempo_reacao:
		return
	_ja_reagiu_a_este_ataque = true
	if randf() >= perfil.chance_reagir:
		return

	_cancelar_plano()
	# O pesado quebra a defesa: contra ele, a resposta certa é esquivar.
	var vem_pesado := alvo.estado in [Lutador.Estado.CARREGANDO_PESADO, Lutador.Estado.GOLPE_PESADO]
	if vem_pesado or randf() < perfil.preferencia_esquiva:
		lutador.esquivar()
	else:
		lutador.defender(true)
		_tempo_defendendo = randf_range(0.5, 0.9)


# --- Plano em andamento -------------------------------------------------------


func _continuar_plano(delta: float) -> void:
	if _tempo_defendendo > 0.0:
		_tempo_defendendo -= delta
		if _tempo_defendendo <= 0.0:
			lutador.defender(false)

	if _tempo_recuando > 0.0:
		_tempo_recuando -= delta
		lutador.direcao_andar = 0.0 if _tempo_recuando <= 0.0 else -_direcao_ao_alvo()

	if _tempo_carregando > 0.0:
		_tempo_carregando -= delta
		if _tempo_carregando <= 0.0:
			lutador.soltar_pesado()

	# Fecha o combo com um médio, mas só depois que o último leve já acertou.
	var ultimo_leve_ja_bateu := (
		lutador.estado == Lutador.Estado.GOLPE_LEVE
		and lutador.golpe_no_combo >= _tamanho_combo
		and lutador.tempo_no_estado > lutador.golpe_leve_dados.fim_ativo
	)
	if _medio_no_fim_do_combo and ultimo_leve_ja_bateu:
		_medio_no_fim_do_combo = false
		lutador.golpe_medio()


# --- Decisão: o que fazer agora? ----------------------------------------------


func _decidir(alvo: Lutador) -> void:
	var distancia := _distancia()
	lutador.direcao_andar = 0.0

	# Jogador carregando o pesado: ele está parado e vulnerável, mas o golpe vem forte.
	# Ou interrompe a carga com uma investida, ou fica fora do alcance (nunca chega perto).
	if alvo.estado == Lutador.Estado.CARREGANDO_PESADO:
		if distancia <= ALCANCE_INVESTIDA and randf() < perfil.agressividade:
			lutador.golpe_medio()
		elif distancia < ALCANCE_INVESTIDA + 0.5 and randf() < perfil.chance_reagir:
			_tempo_recuando = 0.3 # só percebe o perigo quem é atento (perfil)
		return

	if distancia > ALCANCE_CORPO_A_CORPO:
		if distancia <= ALCANCE_INVESTIDA and randf() < perfil.agressividade * 0.5:
			lutador.golpe_medio() # investida: o médio avança
		else:
			lutador.direcao_andar = _direcao_ao_alvo()
		return

	# No alcance.
	if alvo.estado == Lutador.Estado.DEFENDENDO and randf() < 0.5:
		lutador.iniciar_pesado() # jogador defendendo? quebra a defesa
		_tempo_carregando = randf_range(0.25, 0.6)
	elif randf() < perfil.agressividade:
		_iniciar_combo()
	elif randf() < perfil.chance_guarda:
		lutador.defender(true)
		_tempo_defendendo = randf_range(0.4, 0.8)
	else:
		_tempo_recuando = randf_range(0.2, 0.4) # dá um passo para trás


func _iniciar_combo() -> void:
	_tamanho_combo = randi_range(1, perfil.combo_maximo)
	# O primeiro toque começa o combo; os outros entram na fila do lutador.
	for i in _tamanho_combo:
		lutador.golpe_leve()
	_medio_no_fim_do_combo = randf() < perfil.chance_finalizar_com_medio


func _cancelar_plano() -> void:
	_tempo_recuando = 0.0
	_medio_no_fim_do_combo = false
	lutador.direcao_andar = 0.0


func _distancia() -> float:
	return absf(lutador.oponente.global_position.x - lutador.global_position.x)


func _direcao_ao_alvo() -> float:
	return signf(lutador.oponente.global_position.x - lutador.global_position.x)
