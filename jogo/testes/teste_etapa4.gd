extends SceneTree
## Teste automático da Etapa 4: IA do oponente.
##   godot --headless --path jogo --fixed-fps 60 --script res://testes/teste_etapa4.gd

var _falhas := 0
var _arena: Node3D
var _jogador: Lutador
var _oponente: Lutador
var _ia: ControleIA


func _initialize() -> void:
	_rodar.call_deferred()


func _rodar() -> void:
	seed(20261012) # sorteios repetíveis: o teste dá sempre o mesmo resultado
	if not InputMap.has_action("golpe_leve"):
		root.add_child(load("res://scripts/controles.gd").new())
	_arena = load("res://cenas/luta/arena.tscn").instantiate()
	root.add_child(_arena)
	await physics_frame
	_jogador = _arena.get_node("Jogador")
	_oponente = _arena.get_node("Oponente")
	_ia = _arena.get_node("ControleIA")
	_checar(_ia.ativo and _ia.lutador == _oponente, "IA ligada e controlando o Ryū")

	# 1) De longe, a IA se aproxima do jogador parado.
	var distancia_inicial := _distancia()
	await _esperar(120)
	_checar(_distancia() < distancia_inicial - 1.5, "IA se aproximou (%.1f m → %.1f m)" % [distancia_inicial, _distancia()])

	# 2) A IA ataca: o jogador parado perde vida (para no primeiro dano, antes de um K.O.).
	var frames_ate_dano := 0
	while _jogador.vida >= _jogador.vida_maxima and frames_ate_dano < 600:
		await _esperar(1)
		frames_ate_dano += 1
	_checar(_jogador.vida < _jogador.vida_maxima, "IA atacou e causou dano em %.1f s" % (frames_ate_dano / 60.0))

	# 3) Defesa por precaução: com chance_guarda 100%, o golpe do jogador é bloqueado.
	var so_defende := _perfil_de_teste(0.0, 1.0, 0.0)
	_ia.perfil = so_defende
	await _resetar_perto()
	await _esperar(40)
	_checar(_oponente.estado == Lutador.Estado.DEFENDENDO, "IA levanta a defesa quando o jogador está perto")
	var bloqueou := await _golpear_e_ver(_jogador.golpe_leve)
	_checar(bloqueou == Lutador.Resultado.BLOQUEOU, "golpe do jogador foi bloqueado")

	# 4) Reação ao pesado: o difícil esquiva muito mais que o fácil.
	var evitou_dificil := await _testar_reacao_ao_pesado(load("res://recursos/ia/dificil.tres"))
	var evitou_facil := await _testar_reacao_ao_pesado(load("res://recursos/ia/facil.tres"))
	_checar(evitou_dificil >= 6, "IA difícil evitou %d de 10 pesados" % evitou_dificil)
	_checar(evitou_dificil > evitou_facil, "difícil (%d) evita mais que fácil (%d)" % [evitou_dificil, evitou_facil])

	# 5) Depois do K.O. a IA para de agir.
	_ia.perfil = load("res://recursos/ia/dificil.tres")
	_ia.ativo = false
	await _resetar_perto()
	_oponente.vida = 1.0
	_oponente.receber_golpe(_jogador.golpe_leve_dados, 1.0, 1.0)
	_ia.ativo = true
	await _esperar(2)
	_checar(_oponente.estado == Lutador.Estado.DERROTADO, "Ryū derrotado")
	var vida_jogador := _jogador.vida
	await _esperar(90)
	_checar(_jogador.vida == vida_jogador, "IA derrotada não ataca mais")

	Engine.time_scale = 1.0
	print("\n%s" % ("TUDO OK" if _falhas == 0 else "%d FALHA(S)" % _falhas))
	quit(0 if _falhas == 0 else 1)


## 10 vezes: o jogador carrega um pesado perto da IA e solta. Conta quantas a IA evitou.
## O perfil é copiado com agressividade e guarda zeradas para testar só a reação.
func _testar_reacao_ao_pesado(base: PerfilIA) -> int:
	var perfil := _perfil_de_teste(0.0, 0.0, base.chance_reagir, base.tempo_reacao)
	_ia.perfil = perfil
	var evitou := 0
	for tentativa in 10:
		await _resetar_perto()
		_jogador.iniciar_pesado()
		await _esperar(36) # 0,6 s carregando
		var resultado := await _golpear_e_ver(_jogador.soltar_pesado)
		if resultado != Lutador.Resultado.ACERTOU:
			evitou += 1
	return evitou


func _perfil_de_teste(agressividade: float, guarda: float, reagir: float, reacao := 0.2) -> PerfilIA:
	var perfil := PerfilIA.new()
	perfil.agressividade = agressividade
	perfil.chance_guarda = guarda
	perfil.chance_reagir = reagir
	perfil.tempo_reacao = reacao
	perfil.preferencia_esquiva = 0.5
	perfil.intervalo_decisao = 0.2
	return perfil


## Executa a ação de golpe do jogador e devolve o que aconteceu
## (IGNORADO quando o golpe não encostou em nada, ex.: a IA esquivou para longe).
func _golpear_e_ver(acao: Callable) -> Lutador.Resultado:
	var resultado := [Lutador.Resultado.IGNORADO]
	var anotar := func(_alvo, r): resultado[0] = r
	_jogador.acertou.connect(anotar)
	acao.call()
	for i in 60:
		await physics_frame
		if _jogador.estado == Lutador.Estado.LIVRE:
			break
	_jogador.acertou.disconnect(anotar)
	return resultado[0]


func _resetar_perto() -> void:
	_arena._iniciar_rodada()
	_jogador.position.x = -0.5
	_oponente.position.x = 0.5
	await _esperar(2)


func _distancia() -> float:
	return absf(_oponente.global_position.x - _jogador.global_position.x)


func _esperar(frames: int) -> void:
	for i in frames:
		await physics_frame


func _checar(condicao: bool, descricao: String) -> void:
	print(("  [OK]    " if condicao else "  [FALHA] ") + descricao)
	if not condicao:
		_falhas += 1
