class_name HUD
extends CanvasLayer
## Interface da luta: barras de vida, cronômetro, combo e mensagens (K.O., LUTEM!).
## Índice dos lados: 0 = jogador (esquerda), 1 = oponente (direita).

@onready var _nomes: Array[Label] = [$Jogador/Nome, $Oponente/Nome]
@onready var _vida: Array[ProgressBar] = [$Jogador/Vida, $Oponente/Vida]
@onready var _rastro: Array[ProgressBar] = [$Jogador/Rastro, $Oponente/Rastro]
@onready var _tempo: Label = $Tempo
@onready var _combo: Label = $Combo
@onready var _mensagem: Label = $Mensagem
@onready var _submensagem: Label = $Submensagem

var _tweens_rastro: Array[Tween] = [null, null]


func configurar(nome_jogador: String, nome_oponente: String) -> void:
	_nomes[0].text = nome_jogador
	_nomes[1].text = nome_oponente


## O "rastro" é a barra clara atrás da vida: ela desce devagar depois do golpe,
## para o jogador enxergar quanto dano acabou de causar.
func atualizar_vida(vida: float, vida_maxima: float, lado: int) -> void:
	var porcentagem := vida / vida_maxima * 100.0
	_vida[lado].value = porcentagem
	if _tweens_rastro[lado]:
		_tweens_rastro[lado].kill()
	if porcentagem >= _rastro[lado].value:
		_rastro[lado].value = porcentagem
		return
	_tweens_rastro[lado] = create_tween()
	_tweens_rastro[lado].tween_interval(0.4)
	_tweens_rastro[lado].tween_property(_rastro[lado], "value", porcentagem, 0.4)


func atualizar_tempo(segundos: int) -> void:
	_tempo.text = str(segundos)


func mostrar_combo(acertos: int) -> void:
	_combo.text = "%d HITS" % acertos if acertos >= 2 else ""


func mostrar_mensagem(titulo: String, subtitulo := "") -> void:
	_mensagem.text = titulo
	_submensagem.text = subtitulo
	_mensagem.visible = true
	_submensagem.visible = subtitulo != ""


func esconder_mensagem() -> void:
	_mensagem.visible = false
	_submensagem.visible = false
