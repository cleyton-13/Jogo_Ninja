extends Camera3D
## Câmera lateral que sempre enquadra os dois lutadores.
## Fica no meio deles e se afasta quando eles se separam.

@export var lutador_a: Node3D
@export var lutador_b: Node3D
@export var altura := 1.1
@export var distancia_min := 3.2
@export var distancia_max := 6.5
@export var afastamento_por_metro := 0.5 ## quanto a câmera recua por metro de separação
@export var suavidade := 6.0 ## maior = segue mais rápido


func _process(delta: float) -> void:
	if lutador_a == null or lutador_b == null:
		return
	var meio := (lutador_a.global_position.x + lutador_b.global_position.x) / 2.0
	var separacao := absf(lutador_a.global_position.x - lutador_b.global_position.x)
	var distancia := clampf(
		distancia_min + separacao * afastamento_por_metro, distancia_min, distancia_max
	)
	var alvo := Vector3(meio, altura, distancia)
	# Interpolação exponencial: suave e independente do FPS.
	global_position = global_position.lerp(alvo, 1.0 - exp(-suavidade * delta))
