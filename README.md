# ☀️ Maya Web

> Uma calculadora do **Kin Maia** no navegador — descubra seu selo, tom, cor, onda encantada e relações em segundos.

A browser-based **Mayan Tzolkin kin calculator** built by compiling a tiny, purely-functional PureScript library down to a single static `.js` module. No backend, no framework, no runtime dependencies — just an HTML file, a built bundle, and ~70 KB of math.

This is the PureScript port of the original [Haskell library](https://github.com/gustavoguichard/maya).

---

## ✨ O que você encontra

- 🗓️ **Seu Kin** para qualquer data — passada, presente ou futura
- 🎴 **Cartão do Kin** com selo, tom maia (pontos e barras), cor e número
- 🧭 **Relações** do Kin: Guia, Análogo, Antípoda e Oculto
- 🌊 **Onda Encantada** completa (os 13 dias do seu ciclo)
- 🌎 **Família Terrestre** do seu selo (4 selos irmãos)

---

## 🚀 Começando

Você precisa do **Node.js 20+**.

```bash
npm install       # baixa PureScript, Spago e esbuild
npm run build     # gera public/maya.js (~70 KB)
npm run dev       # serve em http://localhost:3000
```

Abra `http://localhost:3000`, informe uma data e o seu Kin aparece. ✨

> ⚠️ Ao abrir `public/index.html` direto pelo `file://` os módulos ES não carregam — use sempre o servidor local (`npm run dev`) ou um deploy estático.

---

## 🧪 Testes

```bash
npm test
```

Roda o `spago test` com [`purescript-spec`](https://github.com/purescript-spec/purescript-spec). Cobre:

- Direção do `diff` (`a - b`)
- Kin de referência em **21/12/2012** = Kin 207 (Mão Cristal Azul)
- 29/fev e 1/mar de ano bissexto produzem o mesmo Kin (Dreamspell *null day*)
- O Tzolkin tem exatamente 260 Kins
- Toda onda encantada tem 13 Kins
- `findKin` e `kinIndex` são inversos

---

## ☁️ Deploy

A pasta `public/` é tudo que o site precisa. Qualquer host estático funciona:

| Host | Comando |
|------|---------|
| **Vercel** | `vercel deploy public/` ou conecte o repositório (output: `public/`, build: `npm run build`) |
| **Netlify** | `netlify deploy --dir public --prod` |
| **Cloudflare Pages** | conecte o repositório (build: `npm run build`, output: `public/`, Node 20+) |

Sem backend, sem variáveis de ambiente — a conta roda 100% no navegador.

---

## 🧩 Como funciona

### Estrutura

```
src/
  Helpers.purs     # cycleIndex, elemPos — utilitários de array
  Kins.purs        # Selo, Tom, Cor, Kin + todas as relações
  Maya.purs        # data gregoriana → número do Kin
  Facade.purs      # API JS (kinInfo)
test/
  Main.purs        # runner do purescript-spec
  MayaSpec.purs    # casos dourados
public/
  index.html       # UI + script inline
  maya.js          # bundle gerado (gitignored)
```

### API JavaScript

Depois de `npm run build`, o bundle expõe uma única função:

```js
import { kinInfo } from './maya.js';

const info = kinInfo({ year: 2012, month: 12, day: 21 });
// {
//   number: 207,
//   name: "Mao Cristal Azul",
//   seal: "Mao",
//   tone: "Cristal",
//   color: "Azul",
//   guide:    "Tormenta Cristal Azul",
//   analog:   "Humano Cristal Amarelo",
//   antipode: "Terra Cristal Vermelho",
//   hidden:   "Mago Lunar Branco",
//   wavespell: [ /* 13 strings */ ],
//   family:    [ /* 4 seal names */ ]
// }
```

Todos os campos são tipos JS nativos (`number`, `string`, `Array<string>`) — nenhuma estrutura do PureScript vaza para o lado JS.

---

## 🌙 Notas sobre o Dreamspell

Este projeto implementa o sistema **Dreamspell** de José Argüelles — **não** o Tzolkin tradicional da contagem longa maia. Duas consequências práticas:

1. **29 de fevereiro é um "dia nulo":** não avança a contagem do Kin. Portanto, 29/02 e 01/03 compartilham o mesmo Kin em anos bissextos.
2. **Anos bissextos** seguem as regras gregorianas completas (divisível por 4, exceto séculos, salvo se divisível por 400). Anos como 1900 e 2100 são corretamente tratados como **não** bissextos.

Como o Dreamspell é ancorado no calendário gregoriano (introduzido em 1582), datas muito anteriores são extrapolações matemáticas — úteis, mas não historicamente exatas.

---

## 🔧 Sobre o porte

O código PureScript é uma tradução quase mecânica das três fontes Haskell originais:

| Haskell | PureScript |
|---------|-----------|
| `[a]` | `Array a` |
| `deriving (Eq, Ord, Show)` | `derive instance` + `genericShow` |
| `[Dragao .. Sol]` (Bounded/Enum) | literais de array explícitos |
| `Data.Time.Day` + `diffDays` | `Data.Date.Date` + `diff` |
| operadores `!!<` e `!!?` | funções `cycleIndex` / `elemPos` |

Toda a aritmética fica em `Int`. Os deltas de dias para qualquer período humano razoável cabem em `Int32`. O `mod` da `EuclideanRing Int` do PureScript é não-negativo, igualando o `mod` do Haskell.

---

## 💛 Créditos

- Sistema **Dreamspell** — José Argüelles & [Foundation for the Law of Time](https://lawoftime.org/)
- Biblioteca Haskell original — [gustavoguichard/maya](https://github.com/gustavoguichard/maya)
- Porte PureScript + UI — este repositório

---

<sub>Feito com 💛 em PureScript. *In Lak'ech.*</sub>
