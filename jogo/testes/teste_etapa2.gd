extends SceneTree
## Teste automático da Etapa 2: simula toques de dedo e confere as ações.
##   godot --headless --path jogo --fixed-fps 60 --script res://testes/teste_etapa2.gd

var _falhas := 0
var _jogador: Lutador
var _gestos: LeitorGestos
var _tela: Vector2


func _initialize() -> void:
	_rodar.call_deferred()


func _rodar() -> void:
	if not InputMap.has_action("golpe_leve"):
		root.add_child(load("res://scripts/controles.gd").new())
	var arena: Node3D = load("res://cenas/luta/arena.tscn").instantiate()
	arena.get_node("ControleIA").ativo = false # testes de etapas antigas: oponente parado
	root.add_child(arena)
	await physics_frame
	_jogador = arena.get_node("Jogador")
	_gestos = arena.get_node("Gestos")
	_tela = root.get_visible_rect().size
	var direita := Vector2(_tela.x * 0.75, _tela.y * 0.5)
	var esquerda := Vector2(_tela.x * 0.25, _tela.y * 0.5)

	# 1) Toque rápido no lado direito = golpe leve.
	_tocar(direita)
	await _esperar(2)
	_soltar(direita)
	await _esperar(1)
	_checar(_jogador.estado == Lutador.Estado.GOLPE_LEVE, "toque à direita → golpe leve")
	await _esperar_livre()

	# 2) Vários toques seguidos = combo.
	var maior_combo := 0
	for i in 4:
		_tocar(direita)
		await _esperar(1)
		_soltar(direita)
		for f in 8:
			await _esperar(1)
			maior_combo = maxi(maior_combo, _jogador.golpe_no_combo)
	# Os golpes guardados ainda saem depois do último toque: continua contando.
	while _jogador.estado != Lutador.Estado.LIVRE:
		maior_combo = maxi(maior_combo, _jogador.golpe_no_combo)
		await _esperar(1)
	_checar(maior_combo >= 4, "toques seguidos encadeiam combo (chegou a %d)" % maior_combo)

	# 3) Deslizar para frente (direita, pois Kaito olha para a direita) = médio e avança.
	var x_antes := _jogador.global_position.x
	await _deslizar(direita, direita + Vector2(_tela.x * 0.12, 0))
	_checar(_jogador.estado == Lutador.Estado.GOLPE_MEDIO, "deslize para frente → golpe médio")
	await _esperar_livre()
	_checar(_jogador.global_position.x > x_antes + 0.3, "golpe médio avançou o lutador")

	# 4) Deslizar para trás = esquiva e recua.
	x_antes = _jogador.global_position.x
	await _deslizar(direita, direita - Vector2(_tela.x * 0.12, 0))
	_checar(_jogador.estado == Lutador.Estado.ESQUIVANDO, "deslize para trás → esquiva")
	await _esperar_livre()
	_checar(_jogador.global_position.x < x_antes - 0.3, "esquiva recuou o lutador")

	# 5) Segurar o lado esquerdo = defesa enquanto segura.
	_tocar(esquerda)
	await _esperar(30)
	_checar(_jogador.estado == Lutador.Estado.DEFENDENDO, "segurar à esquerda → defesa")
	_soltar(esquerda)
	await _esperar(1)
	_checar(_jogador.estado == Lutador.Estado.LIVRE, "soltar → sai da defesa")

	# 6) Segurar o lado direito = carrega o pesado; soltar = golpe pesado.
	_tocar(direita)
	await _esperar(45)
	_checar(_jogador.estado == Lutador.Estado.CARREGANDO_PESADO, "segurar à direita → carregando pesado")
	_checar(_jogador.carga_pesado > 0.1, "carga do pesado subiu (%.2f)" % _jogador.carga_pesado)
	_soltar(direita)
	await _esperar(1)
	_checar(_jogador.estado == Lutador.Estado.GOLPE_PESADO, "soltar → golpe pesado")
	await _esperar_livre()

	# 7) Toque rápido no lado esquerdo não faz nada.
	_tocar(esquerda)
	await _esperar(2)
	_soltar(esquerda)
	await _esperar(1)
	_checar(_jogador.estado == Lutador.Estado.LIVRE, "toque rápido à esquerda → nada")

	# 8) Teclado também funciona (para testar no PC).
	var tecla := InputEventKey.new()
	tecla.physical_keycode = KEY_J
	tecla.pressed = true
	Input.parse_input_event(tecla)
	var golpeou := false
	for i in 3:
		await _esperar(1)
		golpeou = golpeou or _jogador.estado == Lutador.Estado.GOLPE_LEVE
	tecla = tecla.duplicate()
	tecla.pressed = false
	Input.parse_input_event(tecla)
	_checar(golpeou, "tecla J → golpe leve")

	print("\n%s" % ("TUDO OK" if _falhas == 0 else "%d FALHA(S)" % _falhas))
	quit(0 if _falhas == 0 else 1)


# --- Simulação de dedo -------------------------------------------------------
# Os eventos são entregues direto ao LeitorGestos, em coordenadas do jogo.
# (Sem janela, a Godot usa uma tela de 64x64 e descarta os arrastos;
# entregando direto testamos exatamente a lógica dos gestos.)


func _enviar(evento: InputEvent) -> void:
	_gestos._unhandled_input(evento)


func _tocar(posicao: Vector2) -> void:
	var evento := InputEventScreenTouch.new()
	evento.index = 0
	evento.position = posicao
	evento.pressed = true
	_enviar(evento)


func _soltar(posicao: Vector2) -> void:
	var evento := InputEventScreenTouch.new()
	evento.index = 0
	evento.position = posicao
	evento.pressed = false
	_enviar(evento)


func _deslizar(de: Vector2, ate: Vector2) -> void:
	_tocar(de)
	for i in range(1, 5):
		var evento := InputEventScreenDrag.new()
		evento.index = 0
		evento.position = de.lerp(ate, i / 4.0)
		_enviar(evento)
		await _esperar(1)
	_soltar(ate)
	await _esperar(1)


# --- Utilidades --------------------------------------------------------------


func _esperar(frames: int) -> void:
	for i in frames:
		await physics_frame


func _esperar_livre() -> void:
	for i in 180:
		if _jogador.estado == Lutador.Estado.LIVRE:
			return
		await physics_frame


func _checar(condicao: bool, descricao: String) -> void:
	print(("  [OK]    " if condicao else "  [FALHA] ") + descricao)
	if not condicao:
		_falhas += 1
