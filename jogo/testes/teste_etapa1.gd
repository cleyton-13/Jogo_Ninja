extends SceneTree
## Teste automático da Etapa 1. Rode na pasta do projeto com:
##   godot --headless --path jogo --script res://testes/teste_etapa1.gd

var _falhas := 0


func _initialize() -> void:
	_rodar.call_deferred()


func _rodar() -> void:
	if not InputMap.has_action("mover_direita"):
		root.add_child(load("res://scripts/controles.gd").new())
	var arena: Node3D = load("res://cenas/luta/arena.tscn").instantiate()
	arena.get_node("ControleIA").ativo = false # testes de etapas antigas: oponente parado
	root.add_child(arena)
	await physics_frame

	var jogador: Lutador = arena.get_node("Jogador")
	var oponente: Lutador = arena.get_node("Oponente")
	var camera: Camera3D = arena.get_node("Camera")

	_checar(jogador.oponente == oponente, "arena apresentou os lutadores")

	# 1) Andar para a direita até encostar no oponente.
	Input.action_press("mover_direita")
	await _esperar_frames(240)
	Input.action_release("mover_direita")
	var distancia := oponente.global_position.x - jogador.global_position.x
	_checar(distancia > 0.0, "jogador não atravessou o oponente (distância %.2f)" % distancia)
	_checar(distancia <= jogador.distancia_minima + 0.15, "jogador chegou perto do oponente")
	_checar(is_zero_approx(jogador.global_position.z), "jogador ficou no trilho 2.5D (z = 0)")

	# 2) Os dois se encaram.
	var visual_j: Node3D = jogador.get_node("Visual")
	var visual_o: Node3D = oponente.get_node("Visual")
	_checar(is_zero_approx(visual_j.rotation.y), "jogador olha para a direita")
	_checar(is_equal_approx(visual_o.rotation.y, PI), "oponente olha para a esquerda")

	# 3) A câmera ficou no meio dos dois.
	await _esperar_frames(120)
	var meio := (jogador.global_position.x + oponente.global_position.x) / 2.0
	_checar(absf(camera.global_position.x - meio) < 0.1, "câmera centralizada entre os lutadores")

	# 4) Limite da arena.
	Input.action_press("mover_esquerda")
	await _esperar_frames(600)
	Input.action_release("mover_esquerda")
	_checar(
		jogador.global_position.x >= -jogador.limite_arena - 0.01,
		"jogador respeitou o limite da arena (x = %.2f)" % jogador.global_position.x
	)

	print("\n%s" % ("TUDO OK" if _falhas == 0 else "%d FALHA(S)" % _falhas))
	quit(0 if _falhas == 0 else 1)


func _esperar_frames(quantidade: int) -> void:
	for i in quantidade:
		await physics_frame


func _checar(condicao: bool, descricao: String) -> void:
	print(("  [OK]    " if condicao else "  [FALHA] ") + descricao)
	if not condicao:
		_falhas += 1
