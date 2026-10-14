class_name DadosGolpe
extends Resource
## Os números de um golpe. Ficam em arquivos .tres (pasta recursos/golpes)
## para balancear sem mexer no código: abra o .tres no editor e mude os valores.
##
## Linha do tempo de um golpe:
##   0 ──── inicio_ativo ════ fim_ativo ──── duracao
##          (só acerta dentro da parte ════, a "janela ativa")

@export var nome := "Golpe"
@export var dano := 50.0
@export var duracao := 0.3 ## tempo total do golpe, em segundos
@export var inicio_ativo := 0.08 ## quando o golpe começa a poder acertar
@export var fim_ativo := 0.16 ## quando para de poder acertar
@export var alcance := 0.7 ## quanto a hitbox se estende à frente do corpo (metros)
@export var atordoamento := 0.3 ## quanto tempo o alvo fica sem agir depois de ser atingido
@export var empurrao := 1.5 ## velocidade inicial do recuo do alvo (m/s)
@export var quebra_defesa := false ## atravessa a defesa e deixa o alvo atordoado
@export var avanco := 0.0 ## velocidade para frente no começo do golpe (m/s)
@export var tempo_avanco := 0.0 ## por quanto tempo o golpe avança
