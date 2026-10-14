# Jogo Ninja — guia para o Claude

Jogo de luta ninja 1 contra 1 para celular (estilo Marvel Torneio de Campeões), Godot 4.7 + GDScript.
Projeto de aprendizado do Cleyton: explique o que o código faz ao implementar e mantenha o escopo pequeno.

- Design completo e decisões: `docs/GDD.md` (seção 15 = pendências, seção 13 = roadmap por etapas). Atualize o GDD quando uma decisão mudar.
- Projeto Godot fica em `jogo/`. Cena principal: `res://cenas/luta/arena.tscn`.
- Nomes de arquivos, nós, variáveis e comentários em **português**; GDScript com tipagem estática.
- Ações de entrada são registradas em código no autoload `scripts/controles.gd`.
- **Regra de arte:** nenhum personagem usa bandana/faixa/placa na testa; brasão do clã vai em ombreira, braçadeira, cinto ou cachecol (leal = inteiro, nukenin = rachado). Todo prompt de personagem deve incluir `bare forehead, no headband, no forehead protector`. Detalhes: GDD seção 12 "Regras de direção de arte".
- Camadas de física: 1 = cenário, 2 = lutadores (não colidem entre si; `lutador.gd` impede atravessar), 3 = hitbox (golpe), 4 = hurtbox (corpo).
- Números dos golpes ficam em `recursos/golpes/*.tres` (classe `DadosGolpe`); não fixe dano/tempos no código.
- `arena.gd` controla a rodada (cronômetro, K.O., reinício) e usa `Engine.time_scale` na parada de impacto.

## Comandos (Godot via `%LOCALAPPDATA%\Programs\Godot\godot.cmd`)
- Validar/importar: `godot --headless --path jogo --import`
- Testes de uma etapa: `godot --headless --path jogo --fixed-fps 60 --script res://testes/teste_etapaN.gd` (sai com código 1 se falhar). Rode todos os `teste_etapa*.gd` após mudanças.
- Print da arena: `godot --path jogo --script res://testes/captura_tela.gd -- <saida.png> [acao_jogador] [acao_oponente]`
- Sem janela (headless) a tela vira 64x64 e arrastos via `Input.parse_input_event` se perdem: nos testes, entregue toques direto a `LeitorGestos._unhandled_input`.

## Arquitetura do combate
- `Lutador` (máquina de estados) não lê entrada; recebe ações (`golpe_leve()`, `defender(bool)`...) de um controlador.
- `ControleIA` controla o oponente usando as mesmas ações públicas do `Lutador` (nunca acesse privados); dificuldade em `recursos/ia/*.tres` (`PerfilIA`). Testes de etapas antigas desligam a IA (`ControleIA.ativo = false`); testes de IA usam `seed()` fixo.
- `LeitorGestos` só detecta gestos (toque/deslize/segurar); `ControleJogador` traduz gesto → ação conforme o lado para onde o lutador olha.
