# Shinobi no Michi — Roteiro do Anime

Roteiro para transformar a arte que já temos em **animação com IA** (imagem → vídeo).
Mundo, personagens e regras vêm do `docs/GDD.md`. Imagens prontas para usar: `Personagens/9 - Para vídeo (jpg)/`.

---

## 0. Como produzir (fluxo de cada cena)

Cada **plano** (cena curta de 5–8 s) tem 4 partes:

| Parte | O que é | Onde fazer |
|---|---|---|
| 🖼️ **Imagem-base** | O primeiro quadro do vídeo. Ou é uma foto que já temos, ou um **quadro-chave** que você gera antes (quando aparecem 2+ personagens juntos ou um cenário novo) | Gemini (Nano Banana), anexando as imagens indicadas |
| 🎬 **Movimento** | Prompt em inglês dizendo o que se mexe e como a câmera anda | IA de vídeo que aceita imagem inicial (ex.: Veo no Gemini/Flow, Kling, Runway, Hailuo) |
| 🔊 **Áudio** | Fala/narração (português) e efeitos sonoros | Voz por IA (ex.: ElevenLabs) ou gravada; efeitos de bancos gratuitos |
| ⏱️ **Duração** | Quanto o plano dura na montagem | Editor (ex.: CapCut, DaVinci Resolve) |

**Passo a passo**
1. Gere os **quadros-chave** marcados com 🆕 no Gemini (anexe as imagens citadas).
2. Leve cada imagem-base para a IA de vídeo com o **prompt de movimento** + o **bloco de estilo** abaixo.
3. Gere a narração/falas e monte tudo no editor, na ordem dos planos.

### Bloco de estilo (cole no fim de TODO prompt de movimento)
```
Style: 2D Japanese anime, cel-shaded, clean line art, cinematic composition, smooth fluid animation, dramatic lighting, keep the character design exactly as in the reference image. No text, no subtitles, no watermark, no headband or forehead protector on any character.
```

### Regras de continuidade
- Ninguém usa bandana/placa na testa (regra de arte do GDD). Brasão do clã: ombro, braço, cinto ou cachecol.
- Kaito: cachecol vermelho, armadura prateada, olhos com brilho azul quando usa chakra.
- Ryū: máscara, cachecol roxo rasgado, kunai com raios roxos.
- Leais têm luz quente; Nukenin têm luz fria roxa/vermelha.
- Formato: **16:9 horizontal** (igual ao jogo).

---

## 1. Bíblia da história

**Logline:** num Japão feudal onde kami e yokai caminham entre os homens, o jovem Kaito, do Clã Homura, persegue o rival renegado que roubou o Selo do Fogo — e descobre que os seis selos que mantêm fechado o portão de **Yomi** (o mundo dos mortos) estão sendo roubados, um a um.

**Tema:** Luz × Sombra. Cada clã tem um leal (Shinobi) e um renegado (Nukenin). A pergunta da série: *trazer os renegados de volta… ou cair junto com eles?* (no jogo, é a Balança do Caminho).

**O mistério:** **Jōen**, o velho mestre Yamabushi, caiu no Kinjutsu em busca da imortalidade. Ele manipula os nukenin — cada um com o seu motivo — para reunir os seis selos e abrir Yomi, onde pretende fazer um pacto com o **Rei Oni**.

**Os seis selos** (um por clã): Fogo (Homura), Raio (Kage), Vento (Tengu), Água (Mizuchi), Terra (Iwa), Luz (Yamabushi).

### Temporada 1 — 7 episódios
| Ep | Título | Lugar | Renegado em foco | Quem se junta a Kaito |
|---|---|---|---|---|
| 1 | O Selo Quebrado | Pátio do Templo Homura | Ryū | — |
| 2 | Ventos de Kurama | Monte Kurama | Tsubasa | Hayate, **Ryū** (redenção) |
| 3 | O Castelo da Raposa | Castelo do Daimyō | Tamamo | Kagerō |
| 4 | Cinzas de Aso | Vulcão de Aso | Akane | Akane (se poupada) |
| 5 | O Palácio do Rei Dragão | Templo submerso Ryūgū-jō | Minato | Shizuka, Minato |
| 6 | A Vila Esquecida | Bordas de Aokigahara | Kanae | Gonta, Kanae |
| 7 | A Sombra da Montanha | Yomi → Takamagahara | Jōen + Rei Oni | Sayo, Tsubasa — todos os 12 |

---

## 2. TRAILER (~75 s, 12 planos)
Objetivo: apresentar o mundo, o conflito Luz × Sombra e os 12 ninjas. Dá para fazer **quase todo com as imagens que já existem**.

**T1 — Abertura** · 6 s
- 🖼️ `Arena - Pátio do Templo.jpg`
- 🎬 `Slow cinematic push-in on the temple courtyard at night, cherry blossom petals drifting, lantern flames flickering, the huge moon glowing, light fog rolling over the stone floor.`
- 🔊 Narração: *"Há mil anos, seis clãs selaram o portão dos mortos."* · Som: vento, sino de templo distante.

**T2 — Os selos** · 5 s
- 🖼️ 🆕 Quadro-chave (Gemini): `Anime illustration, 16:9: six glowing ancient seals floating in a circle in a dark sky, each a different color and kanji: red 火, purple 雷, green 風, blue 水, brown 土, gold 光. Mystical, cinematic.`
- 🎬 `The six seals rotate slowly in a circle, glowing and pulsing; then one by one they crack with bright light.`
- 🔊 *"Mas os selos… estão se partindo."* · Som: vidro rachando, grave profundo.

**T3 — Kaito** · 6 s
- 🖼️ `Kaito.jpg`
- 🎬 `The ninja tightens his grip on the katana, flames swirl around him, his red scarf whips in the wind, his eyes glow blue, slow camera orbit.`
- 🔊 Kaito: *"Eu vou trazer o selo de volta. Custe o que custar."*

**T4 — Ryū** · 5 s
- 🖼️ `Ryū.jpg`
- 🎬 `The masked ninja raises his head, purple lightning crackles along both kunai, his torn violet scarf flutters, dark aura pulses.`
- 🔊 Ryū: *"Você não faz ideia do que está vindo, Kaito."*

**T5 — Os Leais** · 7 s
- 🖼️ `Elenco Leais (Luz).jpg`
- 🎬 `Slow pan from left to right across the six heroes; each one shifts into a fighting stance as the camera passes; warm golden light, wind and petals.`
- 🔊 Narração: *"Os Shinobi juraram proteger os selos…"*

**T6 — Os Nukenin** · 7 s
- 🖼️ `Elenco Nukenin - opção B.jpg`
- 🎬 `Slow pan from right to left across the six renegades; dark purple aura flares behind them, embers and black flames rise, cold purple light.`
- 🔊 *"…os Nukenin abandonaram tudo para quebrá-los."*

**T7 — Jōen** · 5 s
- 🖼️ `Jōen.jpg`
- 🎬 `The old fallen monk slowly lifts his ringed staff, burning black talismans orbit him, his eyes flare violet, dark energy drips from the staff.`
- 🔊 Jōen (voz calma): *"A imortalidade tem um preço. E eu vou pagá-lo com o mundo."*

**T8 — Choque de lâminas** · 5 s
- 🖼️ 🆕 Quadro-chave (anexe `Kaito.jpg` + `Ryū.jpg` + `Arena - Pátio do Templo.jpg`): `Anime illustration 16:9: Kaito (left, katana with flames) and Ryū (right, kunai with purple lightning) clashing blades in the center of the temple courtyard at night, sparks exploding between them, side view like a fighting game.`
- 🎬 `The two fighters push against each other, fire and purple lightning burst from the clash point, shockwave blows cherry petals away, camera shakes slightly.`
- 🔊 Som: impacto metálico, trovão.

**T9 — Selos de mão** · 4 s
- 🖼️ 🆕 Quadro-chave (anexe `Kaito.jpg`): `Anime close-up of Kaito performing a ninja hand seal with both hands in front of his chest, glowing blue chakra between his fingers, bare forehead, red scarf.`
- 🎬 `Fast sequence of hand movements forming seals, glowing kanji 臨 兵 闘 appear and fade around his hands, chakra intensifies.`
- 🔊 Kaito: *"Kuchiyose…"*

**T10 — A Fênix** · 6 s
- 🖼️ `Hō-ō, a Fênix (Kaito).jpg`
- 🎬 `The giant fire phoenix spreads its wings and lets out a cry, flames burst outward, embers rain down, camera tilts up dramatically.`
- 🔊 Kaito: *"…Hō-ō!"* · Som: grito de fênix, explosão de fogo.

**T11 — Rei Oni** · 5 s
- 🖼️ `Rei Oni.jpg`
- 🎬 `The giant oni king slowly opens his glowing eyes and grins, dark flames erupt along his iron club, smoke swirls.`
- 🔊 Rei Oni (voz grave): *"Finalmente… o portão se abre."*

**T12 — Título** · 6 s
- 🖼️ 🆕 Quadro-chave: `Anime title card 16:9: a huge red sun behind a lone ninja silhouette on a cliff at night, long red scarf flowing, the title "SHINOBI NO MICHI" in bold brush calligraphy style, ink splash effects.` *(se a IA errar o texto, gere sem texto e escreva o título no editor)*
- 🎬 `The scarf flows in the wind, ink splashes animate around the title, embers drift upward.`
- 🔊 Narração: *"Shinobi no Michi. Escolha o seu caminho."*

---

## 3. EPISÓDIO 1 — "O Selo Quebrado" (~3 min, 20 planos)

**Resumo:** Noite de festival no Templo Homura. Ryū invade e rouba o Selo do Fogo. Kaito o enfrenta no pátio. Durante a luta, o selo rachado deixa escapar o primeiro yokai de Yomi — o **Oni Vermelho**. Kaito desperta a invocação da Fênix pela primeira vez e vence o Oni, mas Ryū foge com o selo. Na última cena, alguém nas sombras recebe o selo: Jōen.

### Ato 1 — O roubo
**E1-01** · 6 s — 🖼️ `Arena - Pátio do Templo.jpg`
🎬 `Night festival at the temple: paper lanterns sway, cherry petals fall, slow wide establishing shot with gentle camera drift.`
🔊 Narração: *"Templo do Clã Homura. Noite do Festival das Chamas."* · Som: tambores taiko ao longe.

**E1-02** · 5 s — 🖼️ 🆕 `Anime illustration 16:9: inside a dark temple shrine, a glowing red seal (round stone with the kanji 火) resting on an altar, candles around it, ofuda paper talismans on the wooden walls.`
🎬 `The red seal pulses softly with warm light, candle flames flicker, dust floats in the air.`

**E1-03** · 4 s — 🖼️ 🆕 (anexe `Ryū.jpg`) `Anime illustration: Ryū crouching on the temple roof at night, masked, purple scarf, looking down, the moon behind him.`
🎬 `The masked ninja's red eyes open, his scarf moves in the wind, he leaps down out of frame.`

**E1-04** · 4 s — 🖼️ mesmo quadro do E1-02
🎬 `A shadow passes, a gloved hand grabs the seal from the altar, purple sparks, candles blow out.`
🔊 Som: alarme de sino, gritos distantes.

### Ato 2 — O duelo
**E1-05** · 5 s — 🖼️ `Kaito.jpg`
🎬 `The young ninja runs into the courtyard, stops and draws his katana, embers ignite along the blade, he takes a fighting stance.`
🔊 Kaito: *"Ryū! Devolve o selo!"*

**E1-06** · 5 s — 🖼️ `Ryū.jpg`
🎬 `Ryū lands, turns slowly, the red seal hanging from his belt glowing, he spins his kunai and purple lightning crackles.`
🔊 Ryū: *"Você ainda segue as regras do clã que te usa, Kaito?"*

**E1-07** · 6 s — 🖼️ 🆕 (anexe `Kaito.jpg` + `Ryū.jpg` + arena) `Anime 16:9 side view like a fighting game: Kaito (left) and Ryū (right) facing each other in fighting stances in the temple courtyard at night, three meters apart, wind blowing petals between them.`
🎬 `Both fighters hold still, petals cross between them, then both dash toward each other at the same moment.`

**E1-08** · 4 s — 🖼️ o quadro-chave T8 (choque de lâminas)
🎬 `Rapid exchange of strikes, katana against twin kunai, sparks and small fire and lightning bursts, fast camera movement.`
🔊 Som: lâminas, impactos.

**E1-09** · 4 s — 🖼️ 🆕 (anexe `Kaito.jpg` + `Ryū.jpg`) `Anime: Ryū dodging backward in mid-air, leaving a purple afterimage, while Kaito's flaming slash cuts through empty air.`
🎬 `Ryū flips backward leaving a fading afterimage, Kaito's fiery slash misses and leaves a trail of fire.`

**E1-10** · 5 s — 🖼️ o quadro-chave T9 (selos de mão) — agora com Ryū
🎬 `Ryū forms hand seals quickly, lightning gathers around him, then he throws a bolt of purple lightning forward.`
🔊 Ryū: *"Raiton…"*

**E1-11** · 4 s — 🖼️ `Kaito.jpg`
🎬 `Kaito raises his katana to block, lightning hits the blade and explodes, he slides backward on the stone floor, scarf flying.`

### Ato 3 — O Oni
**E1-12** · 5 s — 🖼️ 🆕 `Anime 16:9: the red seal on Ryū's belt cracking with bright red light, a crack opens in the ground of the temple courtyard, red light and black smoke pouring out.`
🎬 `The crack in the ground widens, the earth shakes, red light and black smoke burst upward, both ninjas stagger.`
🔊 Ryū (surpreso): *"Não… ainda não era para…"*

**E1-13** · 6 s — 🖼️ 🆕 (anexe `Rei Oni.jpg` como referência de estilo) `Anime 16:9: a huge red oni demon (smaller than the Oni King, simple loincloth, one horn broken, iron club) climbing out of a glowing crack in the temple courtyard at night, red eyes, roaring.`
🎬 `The red oni climbs out of the crack, roars, swings its club and smashes a stone lantern.`
🔊 Som: rugido, pedra quebrando.

**E1-14** · 4 s — 🖼️ `Ryū.jpg`
🎬 `Ryū looks at the oni, hesitates, then turns away and vanishes in a burst of purple smoke.`
🔊 Ryū: *"Esse é o seu problema agora."*

**E1-15** · 5 s — 🖼️ `Kaito.jpg`
🎬 `Kaito, alone, wipes blood from his lip, his eyes glow brighter blue, flames rise around his body.`
🔊 Kaito: *"Então eu resolvo."*

**E1-16** · 5 s — 🖼️ o quadro-chave T9 (selos de mão do Kaito)
🎬 `Kaito performs five hand seals, the kanji 臨 兵 闘 者 皆 appear one by one in glowing gold around him.`
🔊 Kaito: *"Kuchiyose… Hō-ō!"*

**E1-17** · 6 s — 🖼️ `Hō-ō, a Fênix (Kaito).jpg`
🎬 `The phoenix bursts out of a pillar of fire, wings spread, and dives forward in a stream of flames.`

**E1-18** · 5 s — 🖼️ 🆕 `Anime 16:9: a giant fire phoenix crashing into the red oni in the temple courtyard, huge explosion of flames, silhouette of the oni disintegrating into ash.`
🎬 `The phoenix hits the oni, a massive explosion of fire fills the screen, the oni turns to ash and is pulled back into the crack, which closes.`

### Epílogo
**E1-19** · 5 s — 🖼️ `Arena - Pátio do Templo.jpg` (versão destruída 🆕 opcional: `same courtyard, damaged, broken lanterns, smoke, dawn light`)
🎬 `Dawn breaks over the damaged courtyard, smoke rises, Kaito kneels exhausted in the center, the empty altar visible behind him.`
🔊 Narração: *"O selo do fogo se foi. E os outros cinco… também estão em perigo."*

**E1-20** · 6 s — 🖼️ 🆕 (anexe `Jōen.jpg`) `Anime 16:9: a dark mountain shrine, only an old monk's hand and ringed staff visible in purple light, receiving a glowing red seal from a masked ninja's hand.`
🎬 `The masked ninja hands over the red seal, the old hand closes around it, violet eyes light up in the darkness, black talismans ignite.`
🔊 Jōen: *"Um selo. Faltam cinco."* · Música sobe → corte para o preto.

---

## 4. EPISÓDIOS 2 a 7 — resumos e planos-chave
(Detalhamos plano a plano quando você for produzir cada um.)

### Ep 2 — Ventos de Kurama
Kaito sobe o Monte Kurama para avisar o Clã Tengu. **Hayate** o recebe; **Tsubasa** tenta roubar o Selo do Vento. Ryū reaparece — mas ataca Tsubasa: descobriu que Jōen pretende abrir Yomi, e isso ele não aceita. Tsubasa foge com o selo; **Ryū se junta a Kaito** (primeira redenção).
- Planos-chave: montanha com templos tengu entre nuvens · Hayate com os leques gerando tornados · Tsubasa saltando entre árvores · Ryū e Kaito lado a lado pela primeira vez.
- Imagens: `Hayate.jpg`, `Tsubasa.jpg`, `Ryū.jpg`, `Kaito.jpg` · 🆕 cenário Monte Kurama.

### Ep 3 — O Castelo da Raposa
O daimyō da região age estranho: está enfeitiçado por **Tamamo**, a kitsune. **Kagerō** (leal do Clã Kage) chega caçando Ryū. Um guarda-costas silencioso, **Minato**, protege o castelo. Kaito, Ryū e Kagerō precisam confiar uns nos outros para quebrar o feitiço.
- Planos-chave: castelo em telhados ao luar · Tamamo com fogo de raposa azul · Kagerō girando a kusarigama · Minato sacando a katana num relâmpago.
- Imagens: `Tamamo.jpg`, `Kagerō.jpg`, `Minato.jpg` · 🆕 cenário Castelo do Daimyō.

### Ep 4 — Cinzas de Aso
No vulcão sagrado, Kaito enfrenta **Akane**, renegada do seu próprio clã: expulsa por usar o fogo proibido para vingar a família. Ela revela que os anciões Homura esconderam a verdade sobre a morte dos pais dela. Kaito vence — e precisa escolher: **poupar** ou **selar o poder dela** (Balança do Caminho).
- Planos-chave: rios de lava · Akane com punhos em chamas negras · duelo fogo contra fogo · Kaito estendendo a mão para Akane caída.
- Imagens: `Akane.jpg`, `Kaito.jpg` · 🆕 cenário Vulcão de Aso.

### Ep 5 — O Palácio do Rei Dragão
No templo submerso Ryūgū-jō, **Shizuka** guarda o Selo da Água. **Minato** vem buscá-lo: o Clã Mizuchi traiu o mestre dele anos atrás. Shizuka e Minato lutam sobre a água; a verdade sobre a traição muda o lado de Minato.
- Planos-chave: palácio de coral sob o mar · naginata de água contra iaijutsu · dragão d'água de Shizuka · Minato embainhando a espada e baixando a cabeça.
- Imagens: `Shizuka.jpg`, `Minato.jpg` · 🆕 cenário Ryūgū-jō.

### Ep 6 — A Vila Esquecida
Nas bordas da floresta Aokigahara, yokai escapam pelas rachaduras de Yomi. **Kanae** defende sozinha uma vila que o Clã Iwa abandonou. **Gonta**, do mesmo clã, chega com Kaito. Juntos, os dois de Iwa erguem uma muralha de pedra para salvar a vila. Kanae entrega o Selo da Terra… só para descobrir que Jōen já tem os outros quatro.
- Planos-chave: floresta escura com névoa roxa · yokai saindo do chão · Gonta e Kanae batendo os punhos no chão juntos · muralha de pedra subindo.
- Imagens: `Kanae.jpg`, `Gonta.jpg` · 🆕 cenário Aokigahara.

### Ep 7 — A Sombra da Montanha
**Sayo**, aprendiz de Jōen, descobre a queda do mestre e se une a Kaito. Jōen abre o portão de Yomi com os seis selos e liberta o **Rei Oni** — que o trai. Os 12 ninjas, leais e renegados, lutam juntos até Takamagahara, a planície celestial. No fim, Kaito encara Jōen e precisa escolher entre **purificar** o mestre caído ou **tomar o poder** dele — final aberto (no jogo, decidido pela Balança do Caminho).
- Planos-chave: portão de Yomi se abrindo · Rei Oni saindo das trevas · os 12 ninjas lado a lado · Sayo com os leques dourados contra Jōen · Fênix contra Rei Oni no céu dourado.
- Imagens: `Sayo.jpg`, `Jōen.jpg`, `Rei Oni.jpg`, os dois elencos, `Hō-ō, a Fênix (Kaito).jpg` · 🆕 cenários Yomi e Takamagahara.

---

## 5. Cenários que faltam gerar (Gemini / Nano Banana)
Anexe `Arena - Pátio do Templo.jpg` como referência de estilo em todos.

```
Same art style as the attached image. Anime background 16:9, no characters: [CENÁRIO]
```
| Cenário | Texto para [CENÁRIO] |
|---|---|
| Vila Oculta na Névoa | `a hidden ninja village in the mountains wrapped in morning mist, wooden houses on stilts, red bridges, waterfalls, cherry trees.` |
| Floresta de bambu | `a dense bamboo forest at night, moonlight beams through the stalks, fireflies, a narrow stone path.` |
| Monte Kurama | `sacred mountain peak above the clouds, small tengu shrines on cliffs, twisted pine trees, strong wind, dawn light.` |
| Castelo do Daimyō | `a feudal Japanese castle at night seen from the rooftops, moonlight on the tiles, paper lanterns, blue fox-fire glowing in a window.` |
| Vulcão de Aso | `inside an active volcano crater, rivers of lava, a sacred forge shrine on a black rock platform, heat haze, red sky.` |
| Ryūgū-jō | `an underwater dragon palace made of coral and gold, glowing jellyfish, beams of light from the surface, giant pearl gates.` |
| Aokigahara | `a dark misty forest with twisted roots, purple glowing cracks in the ground, ghostly lights between the trees, an abandoned village at the edge.` |
| Portão de Yomi | `a colossal black stone gate in an underworld of purple fog, six empty seal slots glowing around it, chains breaking.` |
| Takamagahara | `the celestial plain of the gods above golden clouds, giant torii gates floating in the sky, rays of divine light.` |
