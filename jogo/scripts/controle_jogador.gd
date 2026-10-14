class_name ControleJogador
extends Node
## Liga o jogador ao seu lutador: traduz gestos de toque e teclas em ações.
##
##   Gesto                         Teclado          Ação
##   toque (lado direito)          J                golpe leve (combo)
##   deslizar para frente          K                golpe médio
##   segurar lado direito          segurar L        golpe pesado (carrega)
##   segurar lado esquerdo         segurar S        defesa
##   deslizar para trás            Espaço           esquiva
##   —                             A/D  ←/→         andar (só para testar no PC)

@export var lutador: Lutador
@export var gestos: LeitorGestos


func _ready() -> void:
	gestos.toque.connect(lutador.golpe_leve)
	gestos.deslize.connect(_ao_deslizar)
	gestos.segurar_iniciado.connect(_ao_segurar.bind(true))
	gestos.segurar_terminado.connect(_ao_segurar.bind(false))


func _physics_process(_delta: float) -> void:
	lutador.direcao_andar = Input.get_axis("mover_esquerda", "mover_direita")

	if Input.is_action_just_pressed("golpe_leve"):
		lutador.golpe_leve()
	if Input.is_action_just_pressed("golpe_medio"):
		lutador.golpe_medio()
	if Input.is_action_just_pressed("golpe_pesado"):
		lutador.iniciar_pesado()
	if Input.is_action_just_released("golpe_pesado"):
		lutador.soltar_pesado()
	if Input.is_action_just_pressed("defender"):
		lutador.defender(true)
	if Input.is_action_just_released("defender"):
		lutador.defender(false)
	if Input.is_action_just_pressed("esquivar"):
		lutador.esquivar()


## "Frente" depende de para onde o lutador olha, não do lado da tela.
func _ao_deslizar(direcao_x: int) -> void:
	if float(direcao_x) == lutador.frente:
		lutador.golpe_medio()
	else:
		lutador.esquivar()


func _ao_segurar(lado_direito: bool, comecou: bool) -> void:
	if lado_direito:
		if comecou:
			lutador.iniciar_pesado()
		else:
			lutador.soltar_pesado()
	else:
		lutador.defender(comecou)
