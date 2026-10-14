class_name PerfilIA
extends Resource
## A "personalidade" e a dificuldade de um oponente controlado pela IA.
## Ficam em recursos/ia/*.tres (fácil, médio, difícil) para ajustar sem mexer no código.

@export var nome := "Médio"
@export var tempo_reacao := 0.3 ## segundos até perceber que o jogador atacou
@export_range(0.0, 1.0) var chance_reagir := 0.55 ## chance de defender/esquivar um ataque percebido
@export_range(0.0, 1.0) var preferencia_esquiva := 0.4 ## ao reagir: esquivar (vs. defender)
@export_range(0.0, 1.0) var agressividade := 0.55 ## chance de atacar quando está no alcance
@export_range(0.0, 1.0) var chance_guarda := 0.3 ## chance de levantar a defesa "por precaução"
@export_range(1, 5) var combo_maximo := 4 ## quantos golpes leves encadeia no máximo
@export_range(0.0, 1.0) var chance_finalizar_com_medio := 0.4 ## termina o combo com um médio
@export var intervalo_decisao := 0.35 ## de quanto em quanto tempo decide o próximo passo
