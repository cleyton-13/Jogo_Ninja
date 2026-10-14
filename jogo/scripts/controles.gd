extends Node
## Autoload que registra as ações de teclado do jogo.
## Ficam aqui (em código) em vez do project.godot para ser fácil de ler e mudar.
## No celular quem manda são os gestos (gestos.gd); o teclado serve para testar no PC.

const TECLAS := {
	"mover_esquerda": [KEY_A, KEY_LEFT],
	"mover_direita": [KEY_D, KEY_RIGHT],
	"golpe_leve": [KEY_J],
	"golpe_medio": [KEY_K],
	"golpe_pesado": [KEY_L],
	"defender": [KEY_S, KEY_DOWN],
	"esquivar": [KEY_SPACE],
}


func _ready() -> void:
	for acao: String in TECLAS:
		if not InputMap.has_action(acao):
			InputMap.add_action(acao)
		for tecla: Key in TECLAS[acao]:
			var evento := InputEventKey.new()
			evento.physical_keycode = tecla
			InputMap.action_add_event(acao, evento)
