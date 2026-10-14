extends Node3D
## Cena principal da luta: apresenta um lutador ao outro e controla a rodada
## (cronômetro, combo, K.O., reinício).

const DURACAO_RODADA := 99.0 ## segundos
const ESPERA_APOS_FIM := 3.0 ## segundos mostrando "K.O." antes de reiniciar
const TEMPO_PARA_ZERAR_COMBO := 1.0 ## sem acertar por esse tempo, o combo zera
const PARADA_DE_IMPACTO := 0.05 ## "congelada" curta a cada acerto (dá peso ao golpe)

var tempo_restante := DURACAO_RODADA
var luta_ativa := false
var combo_jogador := 0

var _tempo_desde_ultimo_acerto := 0.0
var _numero_da_rodada := 0
var _posicao_inicial: Dictionary[Lutador, float] = {}

@onready var _jogador: Lutador = $Jogador
@onready var _oponente: Lutador = $Oponente
@onready var _hud: HUD = $HUD


func _ready() -> void:
	_jogador.oponente = _oponente
	_oponente.oponente = _jogador
	_hud.configurar(_jogador.nome_exibicao, _oponente.nome_exibicao)

	for lado in 2:
		var lutador: Lutador = [_jogador, _oponente][lado]
		_posicao_inicial[lutador] = lutador.position.x
		lutador.vida_mudou.connect(_hud.atualizar_vida.bind(lado))
		lutador.acertou.connect(_ao_acertar.bind(lutador))
		lutador.derrotado.connect(_ao_ser_derrotado.bind(lutador))

	_iniciar_rodada()


func _process(delta: float) -> void:
	if luta_ativa:
		tempo_restante = maxf(tempo_restante - delta, 0.0)
		_hud.atualizar_tempo(ceili(tempo_restante))
		if tempo_restante <= 0.0:
			_terminar_por_tempo()

	_tempo_desde_ultimo_acerto += delta
	if combo_jogador > 0 and _tempo_desde_ultimo_acerto > TEMPO_PARA_ZERAR_COMBO:
		combo_jogador = 0
		_hud.mostrar_combo(0)


func _iniciar_rodada() -> void:
	_numero_da_rodada += 1
	for lutador: Lutador in _posicao_inicial:
		lutador.reiniciar(_posicao_inicial[lutador])
		lutador.acoes_bloqueadas = false
	tempo_restante = DURACAO_RODADA
	combo_jogador = 0
	_hud.mostrar_combo(0)
	_hud.esconder_mensagem()
	luta_ativa = true


func _ao_acertar(_alvo: Lutador, resultado: Lutador.Resultado, atacante: Lutador) -> void:
	if atacante == _jogador and resultado == Lutador.Resultado.ACERTOU:
		combo_jogador += 1
		_tempo_desde_ultimo_acerto = 0.0
		_hud.mostrar_combo(combo_jogador)
	_parada_de_impacto()


func _ao_ser_derrotado(perdedor: Lutador) -> void:
	_fim_da_rodada("K.O.!", "%s venceu" % perdedor.oponente.nome_exibicao)


func _terminar_por_tempo() -> void:
	var subtitulo := "Empate"
	if _jogador.vida != _oponente.vida:
		var vencedor := _jogador if _jogador.vida > _oponente.vida else _oponente
		subtitulo = "%s venceu" % vencedor.nome_exibicao
	_fim_da_rodada("TEMPO!", subtitulo)


func _fim_da_rodada(titulo: String, subtitulo: String) -> void:
	if not luta_ativa:
		return
	luta_ativa = false
	for lutador: Lutador in _posicao_inicial:
		lutador.acoes_bloqueadas = true
	_hud.mostrar_mensagem(titulo, subtitulo)
	var rodada_que_terminou := _numero_da_rodada
	await get_tree().create_timer(ESPERA_APOS_FIM).timeout
	# Só reinicia se ninguém começou outra rodada durante a espera.
	if _numero_da_rodada == rodada_que_terminou:
		_iniciar_rodada()


## Congela o jogo por um instante a cada acerto: truque clássico de jogo de luta
## para o golpe "pesar". O timer ignora a câmera lenta (último argumento = true).
func _parada_de_impacto() -> void:
	Engine.time_scale = 0.05
	await get_tree().create_timer(PARADA_DE_IMPACTO, true, false, true).timeout
	Engine.time_scale = 1.0
