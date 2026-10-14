# Jogo Ninja (título provisório: *Shinobi no Michi*)

Jogo de luta ninja 1 contra 1 para celular, estilo anime shōnen, feito em **Godot 4 + GDScript**.

## Começando

1. Instale as ferramentas: clique duas vezes em `ferramentas/instalar.bat`.
   (Para exportar para Android depois: rode `ferramentas\instalar.bat -ComAndroid`.)
2. Abra a Godot pelo atalho na área de trabalho → **Importar** → escolha `jogo/project.godot`.
3. Aperte **F5** para jogar. O mouse imita o dedo (clique = toque, arrastar = deslizar, segurar = segurar):

| Gesto (celular / mouse) | Teclado | Ação |
|---|---|---|
| Toque no lado direito | J | Golpe leve (toque várias vezes = combo de até 5) |
| Deslizar para frente | K | Golpe médio (avança) |
| Segurar no lado direito | segurar L | Carrega e solta o golpe pesado |
| Segurar no lado esquerdo | segurar S | Defesa |
| Deslizar para trás | Espaço | Esquiva |
| — | A/D ou ←/→ | Andar (só para testes) |

## Estrutura

```
docs/GDD.md        documento de design (visão, sistemas, roadmap)
ferramentas/       scripts de instalação
jogo/              projeto Godot
  cenas/           cenas (.tscn): luta/arena, lutador
  scripts/         código GDScript
  testes/          testes automáticos e captura de tela
```

## Licença

MIT — veja [LICENSE](LICENSE).

## Progresso

- [x] Etapa 1 — arena 2.5D, dois lutadores, câmera que enquadra a luta
- [x] Etapa 2 — gestos de toque (leve, médio, pesado, defesa, esquiva)
- [x] Etapa 3 — dano, hitbox/hurtbox, vida, defesa, K.O. e HUD
- [x] Etapa 4 — IA do oponente (aproxima, ataca em combo, defende, esquiva, quebra defesa)
- [ ] Etapa 5 — barra de chakra, Especial 1 e 2, aparar (parry)

Para balancear sem mexer no código, abra no editor da Godot:
- `jogo/recursos/golpes/*.tres` — dano, alcance e tempos de cada golpe
- `jogo/recursos/ia/*.tres` — dificuldade da IA (fácil, médio, difícil). Para trocar a dificuldade, selecione o nó **ControleIA** na cena `arena.tscn` e escolha outro **Perfil**.
