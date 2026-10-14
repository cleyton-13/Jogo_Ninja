class_name LeitorGestos
extends Node
## Lê os toques na tela e transforma em gestos (estilo Torneio de Campeões).
##
##   Toque rápido no lado direito ...... toque
##   Deslizar para um lado ............. deslize(direcao_x)  (+1 = direita da tela)
##   Segurar parado .................... segurar_iniciado(lado_direito) / segurar_terminado(...)
##
## Ele não sabe nada de lutadores: só avisa o gesto. Quem decide o que o gesto
## significa (médio ou esquiva, pesado ou defesa) é o ControleJogador.
## Com "emular toque pelo mouse" ligado no projeto, o mouse também funciona.

signal toque
signal deslize(direcao_x: int)
signal segurar_iniciado(lado_direito: bool)
signal segurar_terminado(lado_direito: bool)

@export var tempo_para_segurar := 0.3 ## segundos parado até virar "segurar"
@export var distancia_deslize := 0.05 ## fração da largura da tela para contar como deslize
@export var tolerancia_movimento := 0.02 ## tremidinha permitida ao tocar/segurar

## Um dedo na tela (multitoque: cada dedo é independente).
class Dedo:
	var inicio: Vector2 ## onde o dedo encostou (base para medir o deslize)
	var ancora: Vector2 ## base para medir se o dedo está parado (para "segurar")
	var tempo := 0.0
	var lado_direito := false
	var segurando := false
	var resolvido := false ## já virou deslize; ignora o resto deste dedo

var _dedos: Dictionary[int, Dedo] = {}


func _unhandled_input(evento: InputEvent) -> void:
	if evento is InputEventScreenTouch:
		if evento.pressed:
			_ao_tocar(evento.index, evento.position)
		else:
			_ao_soltar(evento.index)
	elif evento is InputEventScreenDrag:
		_ao_arrastar(evento.index, evento.position)


func _process(delta: float) -> void:
	for dedo: Dedo in _dedos.values():
		if dedo.resolvido or dedo.segurando:
			continue
		dedo.tempo += delta
		if dedo.tempo >= tempo_para_segurar:
			dedo.segurando = true
			segurar_iniciado.emit(dedo.lado_direito)


func _ao_tocar(indice: int, posicao: Vector2) -> void:
	var dedo := Dedo.new()
	dedo.inicio = posicao
	dedo.ancora = posicao
	dedo.lado_direito = posicao.x >= _largura_tela() / 2.0
	_dedos[indice] = dedo


func _ao_arrastar(indice: int, posicao: Vector2) -> void:
	var dedo: Dedo = _dedos.get(indice)
	if dedo == null or dedo.resolvido:
		return
	var deslocamento := posicao - dedo.inicio
	var largura := _largura_tela()
	var horizontal := absf(deslocamento.x) > absf(deslocamento.y)
	if horizontal and absf(deslocamento.x) >= largura * distancia_deslize:
		if dedo.segurando:
			segurar_terminado.emit(dedo.lado_direito)
		dedo.resolvido = true
		deslize.emit(int(signf(deslocamento.x)))
	elif not dedo.segurando and posicao.distance_to(dedo.ancora) > largura * tolerancia_movimento:
		# O dedo está se mexendo: ainda não é "segurar", reinicia essa contagem.
		# (O "inicio" não muda, para o deslize continuar sendo medido desde o toque.)
		dedo.tempo = 0.0
		dedo.ancora = posicao


func _ao_soltar(indice: int) -> void:
	var dedo: Dedo = _dedos.get(indice)
	_dedos.erase(indice)
	if dedo == null or dedo.resolvido:
		return
	if dedo.segurando:
		segurar_terminado.emit(dedo.lado_direito)
	elif dedo.lado_direito:
		toque.emit()


func _largura_tela() -> float:
	return get_viewport().get_visible_rect().size.x
