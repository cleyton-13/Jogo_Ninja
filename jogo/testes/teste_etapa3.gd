extends SceneTree
## Teste automático da Etapa 3: dano, defesa, esquiva, K.O. e reinício.
##   godot --headless --path jogo --fixed-fps 60 --script res://testes/teste_etapa3.gd

var _falhas := 0
var _arena: Node3D
var _jogador: Lutador
var _oponente: Lutador


func _initialize() -> void:
	_rodar.call_deferred()


func _rodar() -> void:
	if not InputMap.has_action("golpe_leve"):
		root.add_child(load("res://scripts/controles.gd").new())
	_arena = load("res://cenas/luta/arena.tscn").instantiate()
	_arena.get_node("ControleIA").ativo = false # oponente controlado pelo teste
	root.add_child(_arena)
	await physics_frame
	_jogador = _arena.get_node("Jogador")
	_oponente = _arena.get_node("Oponente")
	var hud: HUD = _arena.get_node("HUD")
	var E := Lutador.Estado

	# 1) De longe (4 m) o golpe leve não alcança.
	_jogador.golpe_leve()
	await _esperar_livre(_jogador)
	_checar(is_equal_approx(_oponente.vida, _oponente.vida_maxima), "de longe o golpe não acerta")

	# 2) De perto, o leve acerta: tira vida e deixa o alvo ATINGIDO.
	await _aproximar()
	_jogador.golpe_leve()
	var atingido := await _esperar_estado(_oponente, E.ATINGIDO, 30)
	_checar(atingido, "golpe leve de perto deixa o oponente ATINGIDO")
	var dano_leve := _oponente.vida_maxima - _oponente.vida
	_checar(is_equal_approx(dano_leve, _jogador.golpe_leve_dados.dano), "leve tirou %.0f de vida" % dano_leve)
	var barra: ProgressBar = hud.get_node("Oponente/Vida")
	_checar(barra.value < 100.0, "barra de vida do oponente diminuiu (%.1f%%)" % barra.value)
	await _esperar_livre(_oponente)

	# 3) Combo de 5 leves acerta 5 vezes.
	await _resetar_luta()
	await _aproximar()
	var acertos := [0]
	var contar := func(_alvo, resultado): if resultado == Lutador.Resultado.ACERTOU: acertos[0] += 1
	_jogador.acertou.connect(contar)
	for i in 5:
		_jogador.golpe_leve()
		await _esperar(4)
	await _esperar_livre(_jogador)
	_jogador.acertou.disconnect(contar)
	_checar(acertos[0] == 5, "combo de 5 leves acertou %d vezes" % acertos[0])
	var combo_arena: int = _arena.combo_jogador
	_checar(combo_arena >= 5, "contador de combo da arena chegou a %d" % combo_arena)
	await _esperar_livre(_oponente)

	# 4) Defesa: o leve passa só 10% do dano.
	await _resetar_luta()
	await _aproximar()
	_oponente.defender(true)
	_jogador.golpe_leve()
	await _esperar_livre(_jogador)
	var dano_bloqueado := _oponente.vida_maxima - _oponente.vida
	_checar(
		is_equal_approx(dano_bloqueado, _jogador.golpe_leve_dados.dano * Lutador.DANO_NA_DEFESA),
		"defesa reduziu o dano para %.0f" % dano_bloqueado
	)
	_checar(_oponente.estado == E.DEFENDENDO, "oponente continua defendendo depois do bloqueio")

	# 5) O pesado quebra a defesa.
	await _aproximar()
	_jogador.iniciar_pesado()
	await _esperar(10)
	_jogador.soltar_pesado()
	var quebrou := await _esperar_estado(_oponente, E.ATORDOADO, 40)
	_checar(quebrou, "golpe pesado quebra a defesa (oponente ATORDOADO)")
	_oponente.defender(false)
	await _esperar_livre(_oponente)

	# 6) Esquiva: no começo dela, nenhum golpe acerta.
	await _resetar_luta()
	_oponente.esquivar()
	var resultado := _oponente.receber_golpe(_jogador.golpe_medio_dados, 1.0, 1.0)
	_checar(resultado == Lutador.Resultado.ESQUIVOU, "golpe no começo da esquiva é evitado")
	_checar(is_equal_approx(_oponente.vida, _oponente.vida_maxima), "esquiva não perdeu vida")
	await _esperar_livre(_oponente)

	# 7) K.O. e reinício da rodada.
	await _resetar_luta()
	await _aproximar()
	_oponente.vida = 10.0
	_jogador.golpe_medio()
	var caiu := await _esperar_estado(_oponente, E.DERROTADO, 60)
	_checar(caiu, "vida zerada → oponente DERROTADO")
	var mensagem: Label = hud.get_node("Mensagem")
	_checar(mensagem.visible and mensagem.text == "K.O.!", "HUD mostra K.O.!")
	_checar(not _arena.luta_ativa, "luta pausa depois do K.O.")
	await _esperar(int((_arena.ESPERA_APOS_FIM + 0.5) * 60))
	_checar(_arena.luta_ativa, "rodada reiniciou sozinha")
	_checar(is_equal_approx(_oponente.vida, _oponente.vida_maxima), "vida voltou ao máximo")

	# 8) O cronômetro anda.
	var antes: float = _arena.tempo_restante
	await _esperar(60)
	_checar(_arena.tempo_restante < antes - 0.5, "cronômetro diminuiu")

	Engine.time_scale = 1.0
	print("\n%s" % ("TUDO OK" if _falhas == 0 else "%d FALHA(S)" % _falhas))
	quit(0 if _falhas == 0 else 1)


# --- Utilidades --------------------------------------------------------------


## Coloca os dois lutadores lado a lado, na distância de luta.
func _aproximar() -> void:
	_jogador.position.x = -0.5
	_oponente.position.x = 0.5
	await _esperar(2)


func _resetar_luta() -> void:
	_arena._iniciar_rodada()
	await _esperar(2)


func _esperar(frames: int) -> void:
	for i in frames:
		await physics_frame


func _esperar_livre(lutador: Lutador) -> void:
	for i in 240:
		if lutador.estado == Lutador.Estado.LIVRE or lutador.estado == Lutador.Estado.DEFENDENDO:
			return
		await physics_frame


func _esperar_estado(lutador: Lutador, estado: Lutador.Estado, limite_frames: int) -> bool:
	for i in limite_frames:
		if lutador.estado == estado:
			return true
		await physics_frame
	return lutador.estado == estado


func _checar(condicao: bool, descricao: String) -> void:
	print(("  [OK]    " if condicao else "  [FALHA] ") + descricao)
	if not condicao:
		_falhas += 1
