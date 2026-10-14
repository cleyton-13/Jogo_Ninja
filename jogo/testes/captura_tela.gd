extends SceneTree
## Abre a arena, espera a câmera assentar e salva um print em PNG.
##   godot --path jogo --script res://testes/captura_tela.gd -- <saida.png> [acao_jogador] [acao_oponente]
## Ações opcionais: golpe_leve, golpe_medio, iniciar_pesado, defender, esquivar


func _initialize() -> void:
	_rodar.call_deferred()


func _rodar() -> void:
	var argumentos := OS.get_cmdline_user_args()
	var saida := argumentos[0] if argumentos.size() > 0 else "user://captura.png"
	if not InputMap.has_action("mover_direita"):
		root.add_child(load("res://scripts/controles.gd").new())
	var arena: Node3D = load("res://cenas/luta/arena.tscn").instantiate()
	arena.get_node("ControleIA").ativo = false # testes de etapas antigas: oponente parado
	root.add_child(arena)
	for i in 50:
		await process_frame
	var lutadores := [arena.get_node("Jogador"), arena.get_node("Oponente")]
	if "perto" in argumentos:
		# Coloca os dois na distância de luta e simula uma luta já em andamento.
		argumentos.erase("perto")
		lutadores[0].position.x = -0.5
		lutadores[1].position.x = 0.5
		lutadores[0].receber_golpe(lutadores[0].golpe_medio_dados, 2.0, -1.0)
		lutadores[1].receber_golpe(lutadores[1].golpe_pesado_dados, 3.5, 1.0)
		for i in 50:
			await process_frame
	for i in range(1, mini(argumentos.size(), 3)):
		var acao := argumentos[i]
		if acao == "defender":
			lutadores[i - 1].defender(true)
		else:
			lutadores[i - 1].call(acao)
	for i in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_viewport().get_texture().get_image().save_png(saida)
	print("Print salvo em: ", saida)
	quit()
