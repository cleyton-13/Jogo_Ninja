# GDD — Jogo Ninja (título provisório: *Shinobi no Michi*)

> Documento de Design do Jogo. Documento vivo: atualize sempre que uma decisão mudar.
> Última atualização: 2026-10-11 · Versão 0.1

**Legenda:** ✅ decidido · 🟡 recomendado (aguardando confirmação) · ❓ em aberto

---

## 1. Visão geral

| Item | Definição | Status |
|---|---|---|
| Gênero | **Luta 1 contra 1** com coleção de personagens e progressão RPG (inspiração: *Marvel Torneio de Campeões*) | ✅ (mudou de plataforma em 2026-10-11) |
| Visual | 3D com câmera lateral (2.5D), personagens grandes na tela, estilo anime shōnen | ✅ |
| Controles | Gestos na tela (toque, deslizar, segurar), sem joystick | ✅ |
| Plataforma | Mobile (Android primeiro, iOS depois), celular na horizontal | ✅ |
| Personagens | Protagonista criado pelo jogador + heróis lendários colecionáveis | ✅ |
| Modo de jogo | Single-player (história) na v1 | 🟡 |
| Monetização | Nenhuma na v1; depois cosméticos + anúncios opcionais | 🟡 |
| Engine | Godot 4 + GDScript | ✅ |
| Equipe | Cleyton + Claude Code | ✅ |
| Objetivo | Projeto de aprendizado → fatia vertical jogável | ✅ |

**Frase de venda:** *duelos ninja 1 contra 1 em que você faz os selos de mão, invoca criaturas lendárias e evolui armas comuns até lâminas milenares com alma própria.*

### Pilares de design
1. **Duelo de leitura e reflexo:** atacar, defender, esquivar e punir, tudo com gestos simples.
2. **Selos de mão são o espetáculo:** os especiais exigem que o jogador faça os selos, e a precisão aumenta o poder.
3. **Sua arma tem história:** a arma evolui com você e pode ganhar alma (tsukumogami).
4. **Coleção com identidade:** cada ninja tem elemento, armas, especiais e invocação únicos.
5. **Cultura ninja autêntica com exagero shōnen:** a base é real (Godai, Kuji-in, kami, yokai) e a execução é anime.

---

## 2. Mundo e história

O mundo é um Japão feudal mítico, onde os **kami** (deuses) e os **yokai** (demônios e espíritos) caminham entre os humanos. **Seis clãs** guardam **seis selos** (Fogo, Raio, Vento, Água, Terra, Luz) que mantêm fechado o portão de **Yomi**, o mundo dos mortos.

- **Protagonista:** Kaito, Genin do Clã Homura (no jogo, customizável).
- **Vilão oculto:** **Jōen**, mestre Yamabushi caído no Kinjutsu, que manipula os nukenin para reunir os seis selos, abrir Yomi e fazer um pacto pela imortalidade.
- **Ameaça final:** o **Rei Oni**, libertado de Yomi — e que trai Jōen.
- **Arco central:** em cada capítulo, Kaito enfrenta o renegado de um clã e escolhe entre trazê-lo de volta (Luz) ou não (Sombra).
- **Capítulos (T1 do anime = campanha do jogo):** ver `docs/roteiro-anime.md` — 1 Templo Homura (Ryū) · 2 Monte Kurama (Tsubasa) · 3 Castelo do Daimyō (Tamamo) · 4 Vulcão de Aso (Akane) · 5 Ryūgū-jō (Minato) · 6 Aokigahara (Kanae) · 7 Yomi/Takamagahara (Jōen + Rei Oni).

❓ Nome do mundo/continente

---

## 3. Personagens e clãs

### 3.1 Protagonista (criado pelo jogador)
- Customização: rosto, cabelo, cor do cachecol, roupa e elemento inicial.
- É o personagem principal da história e o único que usa **qualquer** arma (ver 6.1).

### 3.2 Elenco de lançamento ✅ — 2 ninjas por clã (12) — quem é leal ou renegado: 3.3
Os próximos ninjas serão **derivados** destes (mesmo estilo de arma, outro elemento/visual/especiais).

| Clã | Elemento | Ninja 1 | Ninja 2 |
|---|---|---|---|
| **Homura** (Chama) | 🔥 Fogo | **Kaito** (17, M) · katana · equilibrado | **Akane** (19, F) · punhos/tekko · brigona, combos curtos e explosivos |
| **Kage** (Sombra) | ⚡ Raio | **Ryū** (18, M) · kunai duplas · crítico, assassino | **Kagerō** (24, F) · kusarigama · alcance médio, puxa o inimigo |
| **Tengu** (Vento) | 🌪️ Vento | **Hayate** (19, M) · leques de guerra · aéreo, rápido | **Tsubasa** (16, F) · kunai duplas · a mais rápida do jogo, ataques no ar |
| **Mizuchi** (Dragão d'água) | 💧 Água | **Shizuka** (20, F) · naginata · controle, cura | **Minato** (35, M) · katana · iaijutsu (saque rápido), contra-ataques |
| **Iwa** (Rocha) | 🪨 Terra | **Gonta** (25, M) · kanabō · tanque, quebra defesa | **Kanae** (22, F) · punhos/tekko de pedra · defesa + contra-ataque |
| **Yamabushi** (monges da montanha) | ✨ Luz | **Jōen** (60, M) · cajado shakujō · suporte, talismãs | **Sayo** (18, F, miko) · leques de dança kagura · cura e purificação |

**Especial (atualização):** **Tamamo**, kitsune (fogo de raposa), tantō duplo — primeira ninja nova, ligada ao caminho da Sombra.

### 3.3 Shinobi e Nukenin ✅ (o lado leal e o renegado de cada clã)
**Nukenin** (抜け忍) = ninja que abandonou o clã. Cada clã tem um leal e um renegado.

| Clã | ☀️ Shinobi (leal) | 🌑 Nukenin (renegado) | Por que saiu |
|---|---|---|---|
| Homura | Kaito | Akane | Usou o fogo proibido do clã para se vingar |
| Kage | Kagerō | **Ryū** | Rival do Kaito; deixou o clã atrás de poder; primeiro a se redimir |
| Tengu | Hayate | Tsubasa | Jovem rebelde contra as regras do clã |
| Mizuchi | Shizuka | Minato | Virou ronin depois que o clã traiu seu mestre |
| Iwa | Gonta | Kanae | Protegeu uma vila que o clã abandonou (renegada, não má) |
| Yamabushi | Sayo | **Jōen** | Monge caído no Kinjutsu em busca da imortalidade |

| | ☀️ Shinobi | 🌑 Nukenin |
|---|---|---|
| Elemento especial | Luz 光 | Sombra 闇 |
| Técnicas | Hiden | Kinjutsu (mais dano, custam vida) |
| Estilo | Consistente, defesa/suporte | Arriscado, dano alto, roubo de vida |
| Armas que combinam | Divinas | Amaldiçoadas |
| Visual | Símbolo do clã inteiro, cores do clã | Símbolo rachado/invertido, roupa rasgada, cores escuras |

**Afinidade "Irmãos de Clã":** shinobi + nukenin do mesmo clã na equipe → bônus e técnica combinada Luz + Sombra.
**História:** o selo de Yomi foi quebrado por um nukenin; em cada capítulo o jogador enfrenta o renegado de um clã.

### 3.4 Estilos de arma (animações reaproveitadas)
Cada **estilo de arma** tem um conjunto de animações de golpes; vários ninjas compartilham o mesmo estilo e mudam visual, elemento, especiais e talentos.

| Estilo | Ninjas no lançamento |
|---|---|
| Katana | Kaito, Minato |
| Kunai/tantō duplas | Ryū, Tsubasa (+ Tamamo) |
| Leques (tessen) | Hayate, Sayo |
| Punhos/tekko | Akane, Kanae |
| Kusarigama | Kagerō |
| Naginata | Shizuka |
| Kanabō | Gonta |
| Cajado (shakujō) | Jōen |

**Meta de elenco:** 2 na v0.1 (Kaito × Ryū) → 12 no lançamento → +1–2 por atualização → 50+ no longo prazo.

---

## 4. Elementos ✅ *(B + C: elementos da B, com os dois ciclos do Wu Xing da C)*

### Opções avaliadas
- **A. Godai puro:** Terra, Água, Fogo, Vento, Vazio. Autêntico e simples, mas pouco "anime".
- **B. Shōnen (5 base + fusões + 2 especiais):** a mais flexível e a que mais recompensa a evolução. **Recomendada.**
- **C. Wu Xing chinês:** Madeira, Fogo, Terra, Metal, Água. Filosófico, menos japonês.

### 4.1 Elementos base
| Kanji | Elemento | Estilo de luta | Efeito típico |
|---|---|---|---|
| 火 | Fogo | Agressivo, dano contínuo | Queimadura (dano por segundo) |
| 水 | Água | Controle, sustentação | Lentidão, cura leve |
| 風 | Vento | Velocidade, combos longos | Fúria (+ataque acumulado), esquiva melhor |
| 土 | Terra | Defesa, quebra de guarda | Armadura, atordoamento |
| 雷 | Raio | Crítico, punição | Choque (interrompe), +crítico |

### 4.1b Os dois ciclos (ideia do Wu Xing aplicada aos elementos da B) ✅

**Ciclo de CONTROLE — vantagem na luta** (+30% dano causado / -30% recebido):
Fogo › Vento › Terra › Raio › Água › Fogo
*(o fogo devora o vento, o vento desgasta a terra, a terra aterra o raio, o raio eletrifica a água, a água apaga o fogo)*

**Ciclo de GERAÇÃO — sinergia de equipe** (um elemento fortalece o outro):
Fogo → Terra → Água → Vento → Raio → Fogo
*(cinzas viram solo, nascentes brotam da terra, a água evapora em vento, o vento forma a tempestade, o raio incendeia)*

- É a "estrela" do pentágono de controle, como no Wu Xing: os dois ciclos nunca se contradizem (quem te fortalece nunca é quem te vence).
- **Regra de equipe:** se um aliado da equipe tem o elemento que **gera** o seu, você ganha **+10% de dano elemental e +10% de chakra**.
  Ex.: Ryū/Kagerō (Raio) fortalecem Kaito (Fogo); Kaito/Akane (Fogo) fortalecem Gonta/Kanae (Terra).
- Luz e Sombra ficam fora dos ciclos (são especiais do caminho).

| Elemento | Vence (controle) | Perde para | Fortalece (geração) | É fortalecido por |
|---|---|---|---|---|
| 🔥 Fogo | Vento | Água | Terra | Raio |
| 🌪️ Vento | Terra | Fogo | Raio | Água |
| 🪨 Terra | Raio | Vento | Água | Fogo |
| ⚡ Raio | Água | Terra | Fogo | Vento |
| 💧 Água | Fogo | Raio | Vento | Terra |

### 4.2 Fusões (exigem dominar os 2 elementos)
| Kanji | Fusão | Receita | Ideia de skill |
|---|---|---|---|
| 氷 | Gelo | Água + Vento | Congela inimigos, transforma cachoeira em plataforma |
| 熔 | Lava | Fogo + Terra | Chão derretido, dano em área contínuo |
| 木 | Madeira | Água + Terra | Raízes que prendem e criam escadas |
| 砂 | Areia | Vento + Terra | Escudo automático, tempestade que cega |
| 爆 | Explosão | Fogo + Vento | Bombas, impulso aéreo |
| 嵐 | Tempestade | Raio + Vento | Teleporte relâmpago |
| 陽 | Sol | Fogo + Raio | Raio laser concentrado |

### 4.3 Especiais (definidos pelo caminho do jogador)
🟡 **Proposta: o caminho é uma balança, não uma escolha única** — ver "Balança do Caminho" na seção 8.


- 光 **Luz:** bênção dos kami. Cura, purificação, dano extra contra yokai. Libera armas **Divinas**.
- 闇 **Sombra:** pacto com yokai. Roubo de vida, invocação de sombras. Libera armas **Amaldiçoadas**.

### 4.4 Regras
- Todo ninja nasce com **1 afinidade primária** e libera **1 secundária** na história.
- Os demais elementos são aprendidos em locais específicos do mundo (templos e mestres).
- Ninjutsu custa **chakra** e tem tempo de recarga.

---

## 5. Combate e habilidades

### 5.1 Controles por gesto (estilo Torneio de Campeões)
| Gesto | Ação |
|---|---|
| Toque no lado direito | Golpe leve (combo de até 5) |
| Deslizar para frente | Golpe médio (avança) |
| Segurar no lado direito | Golpe pesado (carregável, quebra defesa) |
| Segurar no lado esquerdo | Defender (bloqueio reduz o dano) |
| Deslizar para trás | Esquiva para trás |
| Defender no momento exato | **Aparar** (parry): atordoa o inimigo e abre combo |
| Esquivar no momento exato | **Contra-ataque relâmpago** |
| Botão de especial (canto inferior esquerdo) | Usa a barra de chakra |

### 5.2 Barra de chakra e especiais
A barra de chakra tem **3 segmentos** e enche ao bater e ao receber dano.
| Especial | Custo | Selos (animação) | Exemplo (Kaito, Fogo) |
|---|---|---|---|
| **Especial 1** | 1 barra | 1 selo rápido | *Lâmina de Fogo*: corte flamejante rápido |
| **Especial 2** | 2 barras | 3 selos | *Dragão de Fogo*: dragão que atravessa a tela |
| **Especial 3 / Ougi** | 3 barras | 5 selos + cinemática | *Kuchiyose: Hō-ō, a Fênix* (invocação) |

**Selos ✅ (simples):** o jogador só aperta o botão de especial. **O próprio personagem faz os selos** na animação, e os kanji do Kuji-in (臨 兵 闘 者 皆 陣 列 在 前) brilham na tela como efeito visual. Não há mini-jogo.
💡 Ideia para o futuro (não agora): tornar os selos interativos.

### 5.3 Invocações (Kuchiyose)
Cada ninja tem **uma criatura de invocação** que aparece no Especial 3: Fênix (Fogo), Dragão Ryūjin (Água), Corvo Tengu (Vento), Tartaruga de pedra (Terra), Raijū, a fera do trovão (Raio), Raposa de nove caudas (Kitsune). A invocação também evolui (ver 8).

### 5.4 Habilidade de assinatura e passivas
Cada ninja tem passivas próprias (ex.: Kaito aplica **Queimadura** a cada 4º golpe) e uma **habilidade de assinatura** que desperta e fica mais forte conforme o ninja ganha estrelas (ver 8.1).

### 5.5 Vantagem de elemento (como as "classes")
O ciclo de elementos (seção 4) funciona como vantagem de classe: lutar com vantagem dá +30% de dano e -30% de dano recebido.

### 5.6 Troca de especiais ✅ (tela "Especiais" no canvas)
Cada ninja tem **3 slots** (Especial 1, 2 e 3) e escolhe qual técnica colocar em cada um, a partir de um **pergaminho** que cresce ao longo do jogo.

**De onde vêm os especiais:**
| Origem | Exemplo (Kaito) | Como libera |
|---|---|---|
| **Clã** | Lâmina de Fogo, Chuva de Fogo, Sol Negro | Nível do elemento, estrelas, capítulos da história |
| **Elemento secundário** | Passo do Vento | Nível no elemento secundário |
| **Fusão** | Explosão Giratória, Tempestade de Fogo | Dominar a fusão (ex.: 爆 Explosão) |
| **Aliado** | Kuchiyose: Corvo (do Clã Tengu) | Missões de amizade com outro herói |

**Regras:**
- Cada especial pertence a um **slot fixo** (1, 2 ou 3), conforme o custo de chakra.
- Cada especial tem **sua própria sequência de selos** na animação (só visual).
- Os especiais de **Invocação** só cabem no slot 3.
- Isso dá variedade: dois jogadores com o mesmo Kaito podem lutar de jeitos diferentes.

**Evolução de especial:** Nv 1 a 10 com ramificação nos níveis 5 e 10.
> Ex.: *Dragão de Fogo* → nv5: **Dragão Duplo** *ou* **Dragão Perfurante** → nv10: **Dragão Imperial**.

### 5.7 Especiais em equipe 🟡 (ideias, a decidir)
O jogador monta uma **equipe de 3 ninjas** (arena e história). Ideias:
1. **Afinidade de equipe:** certas duplas dão bônus passivo para a equipe toda.
   - "Fogo e Vento" (Kaito + Hayate): especiais de fogo ganham área.
   - "Rivais" (Kaito + Ryū): +10% crítico para os dois.
   - "Mestre e Aluno" (Monge Jōen + qualquer Genin): +XP.
2. **Assistência:** um botão de chamar aliado. Ele entra, faz um golpe característico e sai, com recarga longa (ex.: Gonta levanta um muro de pedra, Shizuka cura).
3. **Técnica combinada (合体 Gattai):** se o aliado certo está na equipe, o Especial 3 vira uma **técnica em dupla**. O aliado aparece na cinemática e os dois fazem os selos juntos. Ex.: Kaito + Hayate = **Tornado de Fogo**, Shizuka + Hayate = **Nevasca**.
4. **Elo de chakra:** quando um ninja da equipe é derrotado, o próximo entra com parte da barra de chakra dele.
5. *(futuro)* **Troca durante a luta (tag):** trocar de ninja no meio da luta.

### 5.8 Camadas de técnica
1. **Taijutsu:** os golpes leve, médio e pesado.
2. **Bukijutsu:** a arma equipada muda a animação, o alcance e o efeito dos golpes.
3. **Ninjutsu:** os especiais 1 e 2.
4. **Ougi (奥義):** especial 3 com selos e invocação.

**Fusão de especiais:** dois especiais no nível máximo podem gerar uma técnica combinada (ex.: Dragão de Fogo + Passo do Vento = Dragão de Explosão).

---

## 6. Armas

### 6.1 Quem usa o quê ✅ *(Opção C híbrida)*
- **A. Livre:** qualquer personagem usa qualquer arma. Muita liberdade, pouca identidade, muitas animações.
- **B. Exclusiva por clã:** identidade forte, pouca liberdade.
- **C. Híbrida (recomendada):** cada personagem tem 2–3 **armas de afinidade** (moveset completo + bônus). As outras ele usa com um combo básico e sem bônus. O **protagonista** pode aprender a afinidade de qualquer arma treinando com o mestre do clã.

### 6.2 Tipos de arma
| Arma | Tipo | Estilo |
|---|---|---|
| Katana | Principal | Equilibrada, combos rápidos |
| Tantō / kunai | Principal | Muito rápida, alto crítico, curto alcance |
| Kusarigama | Principal | Alcance médio, puxar inimigos |
| Naginata | Principal | Longo alcance, varredura |
| Kanabō | Principal | Lenta, quebra defesa e paredes |
| Tessen (leque) | Principal | Ataques de vento, defesa |
| Shuriken | Arremesso | Distância, munição |
| Yumi (arco) | Arremesso | Distância longa, carregável |

### 6.3 Tiers de raridade
| Tier | Cor | Como obter |
|---|---|---|
| Comum (ferro) | Cinza | Loja, inimigos |
| Forjada (tamahagane) | Prata | Ferreiro |
| Mestre (assinada) | Azul | Ferreiro + missão |
| Lendária | Dourado | Chefes, ascensão |
| Milenar (tsukumogami) | Vermelho | Despertar a alma (arma com 100 "anos" de uso) |
| Divina / Amaldiçoada | Branco / Roxo | Caminho Luz ou Sombra, fim de jogo |

### 6.4 Os 5 caminhos de evolução (abas do ferreiro)
1. **Refinar** (+1 a +15): sobe status com materiais comuns e tem chance de falha a partir do +10.
2. **Ascender:** sobe de tier. Exige material raro + **missão de forja** (ex.: temperar no Vulcão de Aso).
3. **Imbuir:** adiciona um elemento à arma (Katana → Katana de Raio).
4. **Abençoar / Amaldiçoar:** santuário (bônus contra yokai) ou pacto oni (dano alto, custa vida).
5. **Despertar alma:** a arma vira **tsukumogami**, ganha nome, voz, personalidade e uma skill própria.

**Troca por arma milenar sem perder progresso:** ao "sacrificar" uma arma evoluída para forjar uma milenar, parte dos níveis passa para a nova (herança).

### 6.5 Armas lendárias (topo)
- **Kusanagi no Tsurugi:** a espada do vento, controla tempestades.
- **Muramasa Sedenta** *(Amaldiçoada)*: o dano cresce a cada abate, mas drena vida.
- **Masamune Pura** *(Divina)*: cura ao acertar, imune a maldições.
- **Ama-no-Nuboko:** a lança da criação, arma suprema da Terra.
- **Shuriken do Sol Negro:** gira em órbita ao redor do ninja.

---

## 7. Armaduras

Slots: **Kabuto** (elmo) · **Menpō** (máscara) · **Dō** (peitoral) · **Kote** (braços) · **Suneate** (pernas) · **Omamori** (amuleto)

- Usam os mesmos tiers e o mesmo sistema de refino das armas.
- **Sets** com bônus em 2/4/5 peças. Ex.: *Set Tengu*: 2 peças dão pulo duplo, 4 dão esquiva aérea e 5 dão asas de vento no Ougi.
- **A máscara define a aura** (passiva): Oni = dano, Kitsune = esquiva, Tengu = velocidade, Hannya = roubo de vida.
- **Inscrições de ofuda:** talismãs encaixáveis que dão bônus extras (como gemas).

---

## 7.5 Raridade dos itens ✅ (cor única + nome temático por categoria)

A raridade fica **nos itens**, nunca nos personagens. Todas as categorias usam as mesmas 6 cores, mas cada categoria tem nomes próprios.

| Cor | Nível | Bônus (ofudas) | Armas | Especiais | Trajes | Talentos |
|---|---|---|---|---|---|---|
| ⚪ Cinza | 1 | 0 | Comum (ferro) | Pergaminho de Treino | Traje de Treino | Básico |
| 🟢 Verde | 2 | 1 | Forjada (tamahagane) | Pergaminho de Missão | Traje de Missão | Aprimorado |
| 🔵 Azul | 3 | 2 | Mestre (assinada) | Pergaminho do Clã | Traje do Clã | Mestre |
| 🟣 Roxo | 4 | 3 | Secreta | **Hiden** (técnica secreta) | Traje Cerimonial | Secreto |
| 🟡 Dourado | 5 | 3 + efeito único | Lendária | **Kinjutsu** (proibida, custa vida) | Traje Lendário | Lendário |
| 🔴 Vermelho | 6 | Efeito único + alma | Milenar (tsukumogami) | Técnica Ancestral | Traje de Herói Antigo | Ancestral |

**Outras categorias com raridade:** máscaras (definem a aura), faixas/hachimaki (bônus de atributo), omamori (proteções), pactos de invocação e ferramentas ninja (bomba de fumaça, kunai explosiva, pílula de soldado).

**Onde achar itens raros:** chefes (garantido na 1ª vitória), ferreiro, santuários (oferendas), **loja** e mercador ambulante, ronin errantes (o equipamento deles) e festivais sazonais (Hanami, Tanabata, Obon, Inverno).

---

## 8. Progressão do personagem

| Sistema | Como funciona |
|---|---|
| **Nível (XP)** | Status base, ganho nas lutas |
| **Estrelas ★1 a ★7** | A evolução do próprio ninja (ver 8.1) |
| **Kuji-in (9 selos)** | Árvore espiritual de fim de jogo, liberada por missões e não por XP |
| **Balança do Caminho** 🟡 | Medidor Luz ↔ Sombra que muda com as escolhas; pode ser trocado durante o jogo (ver abaixo) |

### 8.0 Balança do Caminho 🟡 (proposta)
- Medidor de **-100 (Sombra) a +100 (Luz)**, começa em 0.
- **Move com as escolhas:** poupar ou selar um renegado derrotado, missões de clã ou de nukenin, usar Hiden ou Kinjutsu, oferendas em santuários ou pactos com yokai.
- **Faixas:** ≥ +50 = Caminho da Luz · ≤ -50 = Caminho da Sombra · no meio = **Equilíbrio**.
- **Mudar de lado é possível a qualquer momento**, mas custa: o **Rito de Purificação** (vai para a Luz) ou o **Pacto de Sangue** (vai para a Sombra) são missões especiais que levam a balança ao outro lado.
- **Nunca se perde um ninja já recrutado.** O que muda é o bônus de **Lealdade**: ninjas alinhados ao seu caminho ganham +status; os do lado oposto lutam normalmente, sem o bônus.
- **Armas Divinas/Amaldiçoadas:** o efeito único só funciona por completo no caminho correspondente.
- **Recompensa do Equilíbrio:** quem mantém a balança no meio por muito tempo libera o elemento secreto **Vazio (空, Kū)** do Godai: o mais difícil de conseguir.

### 8.1 Evolução de ★1 a ★7 ✅ (o mesmo personagem)
**Não existem cópias nem raridade.** Cada ninja começa em ★1 e **evolui ele mesmo** até ★7. Não há tabela de raridade nem "tirar o mesmo ninja de novo".

✅ **Cada estrela abre um dos 7 chakras.** Isso junta dois sistemas em um e combina com a cultura do jogo:

| ★ | Chakra aberto | O que o ninja ganha |
|---|---|---|
| ★1 | Raiz | Ninja recrutado: golpes básicos + Especial 1 |
| ★2 | Sacral | Especial 2 + mais chakra |
| ★3 | Plexo solar | Especial 3 (invocação) + **habilidade de assinatura** |
| ★4 | Coração | Novos especiais do clã para trocar nos slots |
| ★5 | Garganta | Visual novo (roupa e aura) |
| ★6 | Terceiro olho | Assinatura evoluída + invocação evoluída |
| ★7 | Coroa | **Despertar / Modo Sennin**: transformação durante a luta |

**Como subir uma estrela** (tudo dentro da história do jogo):
1. Chegar ao **nível máximo** da estrela atual (lutando).
2. Juntar **Pergaminhos do Clã** (ganhos em lutas e missões daquele clã).
3. Vencer a **Prova do Chakra**: um duelo especial contra um mestre num local sagrado (ex.: a prova ★5 do Kaito é no Vulcão de Aso).

### 8.2 Como recrutar ninjas ✅ (sem cristais, tudo no contexto do jogo)
| Forma | Como funciona | Exemplo |
|---|---|---|
| **Vencer e convencer** | Rivais da história se juntam a você depois do duelo | Ryū entra no elenco ao ser derrotado no Capítulo 1 |
| **Confiança do clã** | Missões para um clã sobem a reputação, e no topo o líder envia um ninja | O Clã Iwa envia Gonta |
| **Torneio das Vilas** | Vencer o torneio da temporada recruta o campeão daquela vila | Hayate, campeão de Kurama |
| **Ronin errantes** | Ninjas sem clã aparecem no mapa de vez em quando. Vença 3 duelos para que ele aceite segui-lo | Um espadachim misterioso |
| **Selar um yokai** | Chefes yokai derrotados podem virar aliados (caminho da Sombra) | Tamamo, a kitsune |

### 8.3 Atributos ✅ (6, mostrados num hexágono)
| Kanji | Atributo | Efeito |
|---|---|---|
| 力 | Força | Dano dos golpes, quebra de defesa |
| 速 | Velocidade | Velocidade do combo, esquiva, avanço |
| 体 | Resistência | Vida, defesa, menos empurrão |
| 気 | Chakra | Recarga da barra, dano dos especiais |
| 技 | Técnica | Crítico, janela de aparar |
| 知 | Estratégia | Duração dos efeitos causados e recebidos, "leitura" do oponente |

**Como sobem:** estrelas (grande), nível (pequeno, automático), **pontos de treino com distribuição livre** ✅ (ganhos ao subir de nível e no Dojo) e equipamento.
Cada ninja tem um **perfil base** diferente (ex.: Gonta = Força/Resistência, Hayate = Velocidade).

### 8.4 Talentos ✅
- **1 talento inato:** fixo, é a identidade do ninja.
- **2 slots de talentos aprendidos:** trocáveis à vontade entre **todos os que o jogador possui**, comprados na **loja** (com ryō/Honra) ou ganhos no jogo. Talentos têm raridade (7.5).

Exemplos por atributo:
- **力 Força:** Punho de Ferro, Fúria do Oni, Inabalável.
- **速 Velocidade:** Passo Fantasma, Golpe Relâmpago, Primeiro a Atacar.
- **知 Estratégia:** Leitura de Combate, Armadilha de Selo, Paciência, Analista.
- **技 Técnica:** Aparar Perfeito, Ponto Vital, Mestre de Armas.
- **体 Resistência:** Pele de Pedra, Último Suspiro, Regeneração.
- **気 Chakra:** Fonte de Chakra, Eco do Selo, Meditação.
- **Truques ninja:** Kawarimi (substituição), Bomba de Fumaça, Clone das Sombras.

**Moedas e materiais do mundo:**
- **Ryō:** dinheiro (ferreiro, loja).
- **Pergaminhos do Clã:** evolução de estrelas.
- **Honra:** ganha na arena, troca por equipamentos.
- **Essência elemental:** imbuir armas e evoluir especiais.

---

## 9. Modos de jogo e arenas

### Modos
- **História:** mapa com nós (lutas, baús, eventos) por capítulo, terminando num chefe.
- **Arena do Torneio:** sequência de lutas com 3 ninjas do seu elenco para ganhar recompensas.
- **Dojo / Treino:** testar golpes e especiais contra um boneco.
- *(futuro)* Eventos semanais e um modo de clã cooperativo assíncrono.

### Arenas (cada capítulo tem a sua)
| # | Arena | Elemento/tema | Chefe |
|---|---|---|---|
| 0 | Vila Oculta na Névoa (hub) | Ferreiro, templo, dojo, loja | — |
| 1 | Pátio do Templo / Floresta de Bambu | Tutorial | Oni Vermelho |
| 2 | Monte Kurama | Vento / Raio, tengu | Rei Tengu |
| 3 | Castelo do Daimyō | Furtividade noturna, telhados | Ninja traidor |
| 4 | Vulcão de Aso | Fogo, forja sagrada | Salamandra de lava |
| 5 | Templo submerso Ryūgū-jō | Água | Dragão Ryūjin |
| 6 | Aokigahara / Yomi | Mundo dos mortos, armas amaldiçoadas | Izanami (sombra) |
| 7 | Takamagahara | Planície celestial, bênção divina | Rei Oni |

Arenas têm **efeitos de cenário** (ex.: no vulcão, o chão causa queimadura a cada 10 s; no templo submerso, os golpes de Raio se espalham).

---

## 10. Monetização 🟡

**v1 (aprendizado):** sem monetização.

**Futuro (se for lançado):**
- **Cosméticos:** auras de chakra, cachecóis, máscaras, efeitos de arma, poses de vitória.
- **Anúncios opcionais:** "assista e ganhe material extra" (o jogador escolhe).
- ❌ **Sem cristais, sem gacha** e sem "pagar para ganhar" (decisão do Cleyton).

## 11. Online 🟡

- **v1:** single-player 100% offline, com save local.
- **v2:** save na nuvem e ranking de tempo por fase.
- **v3:** PvP assíncrono (enfrentar a IA do personagem de outro jogador).
- ❌ Co-op e PvP em tempo real ficam fora do escopo (complexidade muito alta).

---

## 12. Técnica

| Item | Escolha |
|---|---|
| Engine | **Godot 4** (versão padrão, sem C#) |
| Linguagem | **GDScript** |
| Câmera | `Camera3D` lateral que enquadra os dois lutadores; movimento só no eixo X (2.5D) |
| Lutadores | `CharacterBody3D` + máquina de estados (parado, andar, golpes, defesa, esquiva, atordoado, especial) |
| Golpes | Hitbox/hurtbox com `Area3D`, dados de cada golpe em `Resource` |
| IA do oponente | Máquina de estados com níveis de dificuldade (reação, chance de aparar) |
| Cinemáticas | `AnimationPlayer` controlando câmera e personagens nos especiais |
| Resolução base | 1280×720, horizontal, escalável |
| Dados de armas/skills | `Resource` (.tres), fáceis de editar e balancear |
| Save | `ConfigFile` / JSON local em `user://` |
| Controle de versão | Git |
| Instalação | `ferramentas/instalar.bat` |

### Arte (sem modelagem própria por enquanto)
- **Protótipo:** formas simples (cápsulas e cubos) com cores.
- **Depois:** modelos gratuitos e estilizados (packs CC0 low-poly como Quaternius e Kenney), animações do Mixamo e visual anime com shader *toon* (cel-shading) feito na Godot.
- ❓ Aprender o básico de Blender mais à frente, para ajustar modelos e criar armas.

### Regras de direção de arte ✅ (valem para todo personagem)
1. **Sem bandana, faixa ou placa na testa.** Nenhum ninja usa protetor de testa — é a marca de outro anime e queremos identidade própria.
2. **Brasão do clã** fica na ombreira, braçadeira, fivela do cinto, broche do cachecol ou costas da roupa. Leal = brasão inteiro; Nukenin = rachado ou invertido.
3. **Brasões e símbolos originais:** nada de redemoinho, folha ou símbolos de outras obras.
4. Arte de referência e prompts: `docs/prompts-nano-banana.md`; imagens geradas: pasta `Personagens/`.

---

## 13. Roadmap: fatia vertical (v0.1)

| Etapa | Entrega | Você aprende |
|---|---|---|
| 1 | Projeto Godot + arena 2.5D, dois lutadores-cápsula, câmera que enquadra os dois | Cenas, nós, câmera |
| 2 | Gestos: toque, deslizar e segurar viram leve, médio, pesado, defesa e esquiva | Input de toque, sinais |
| 3 | Combo de golpes leves + hitbox/hurtbox + vida | Máquina de estados, colisão |
| 4 | Oponente com IA simples (ataca, defende, esquiva) | IA, timers |
| 5 | Barra de chakra + Especial 1 e 2 + aparar | HUD, recursos, partículas |
| 6 | Especial 3: animação de selos + invocação simples | AnimationPlayer, cinemática |
| 7 | Tela de elenco + ferreiro (refinar +1 a +5) + save | Resources, menus, save |
| 8 | Modelos e animações reais (Mixamo) + shader toon | Importar 3D, AnimationTree, shaders |
| 9 | Exportar APK e rodar no celular | Build Android |

**Meta da v0.1:** Kaito contra Ryū no Pátio do Templo, com os 3 especiais funcionando.

---

## 14. Sugestões de nome ❓

| Nome | Significado |
|---|---|
| **Shinobi no Michi** | "O Caminho do Ninja" (provisório) |
| **Godai: Lâminas dos Cinco Céus** | Referência aos 5 elementos |
| **Tsukumogami** | As armas com alma, o diferencial do jogo |
| **Kage no Ken** | "A Espada da Sombra" |
| **Ninja Ascend** | Internacional, foca na evolução |
| **Lâmina Milenar** | Em português, direto ao ponto |

---

## 15. Decisões pendentes

- [x] Sistema de elementos: **B**
- [x] Regra de armas: **C (híbrida)**
- [x] Como se ganham ninjas: **dentro do jogo** (duelos, clãs, torneio, ronin, yokai); **sem cristais**
- [x] Especiais trocáveis por slot, vindos de clã/elemento/fusão/aliado
- [x] Evolução do mesmo ninja de ★1 a ★7 (sem cópias/raridade)
- [x] Selos: automáticos, feitos pelo personagem na animação
- [x] Cada estrela abre um chakra (8.1)
- [x] Raridade fica nos itens (armas, especiais, roupas...), não nos personagens
- [x] Raridade: cor única + nome temático por categoria (7.5)
- [x] 6 atributos, pontos de treino livres, 1 talento inato + 2 trocáveis (8.3, 8.4)
- [x] Elenco de lançamento: 2 ninjas por clã = 12 (3.2), animações por estilo de arma (3.3)
- [x] Elementos: B + ciclos de controle e geração da C (4.1b)
- [ ] Especiais em equipe: quais ideias da 5.7 entram (a sinergia de geração da 4.1b já cobre a "afinidade de equipe")
- [ ] Confirmar single-player e sem monetização na v1
- [ ] Nome do jogo
- [ ] Nome do mundo, do vilão e origem do protagonista
