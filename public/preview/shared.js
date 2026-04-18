import { kinInfo } from '../maya.js';

export { kinInfo };

export const SEAL_PT = {
  Dragao: 'Dragão', Vento: 'Vento', Noite: 'Noite', Semente: 'Semente',
  Serpente: 'Serpente', EnlacadorDeMundos: 'Enlaçador de Mundos',
  Mao: 'Mão', Estrela: 'Estrela', Lua: 'Lua', Cachorro: 'Cachorro',
  Macaco: 'Macaco', Humano: 'Humano', CaminhanteDoCeu: 'Caminhante do Céu',
  Mago: 'Mago', Aguia: 'Águia', Guerreiro: 'Guerreiro', Terra: 'Terra',
  Espelho: 'Espelho', Tormenta: 'Tormenta', Sol: 'Sol',
};

export const TONE_PT = {
  Magnetico: 'Magnético', Lunar: 'Lunar', Eletrico: 'Elétrico',
  AutoExistente: 'Autoexistente', Harmonico: 'Harmônico', Ritmico: 'Rítmico',
  Ressonante: 'Ressonante', Galatico: 'Galáctico', Solar: 'Solar',
  Planetario: 'Planetário', Espectral: 'Espectral', Cristal: 'Cristal',
  Cosmico: 'Cósmico',
};

export const TONE_NUMBER = {
  Magnetico: 1, Lunar: 2, Eletrico: 3, AutoExistente: 4, Harmonico: 5,
  Ritmico: 6, Ressonante: 7, Galatico: 8, Solar: 9, Planetario: 10,
  Espectral: 11, Cristal: 12, Cosmico: 13,
};

export const SEAL_EMOJI = {
  Dragao: '🐉', Vento: '🌬️', Noite: '🌙', Semente: '🌱', Serpente: '🐍',
  EnlacadorDeMundos: '🌉', Mao: '✋', Estrela: '⭐', Lua: '🌕', Cachorro: '🐕',
  Macaco: '🐒', Humano: '🧍', CaminhanteDoCeu: '🌤️', Mago: '🧙', Aguia: '🦅',
  Guerreiro: '⚔️', Terra: '🌎', Espelho: '🪞', Tormenta: '⛈️', Sol: '☀️',
};

export const COLOR_CSS = {
  Vermelho: 'vermelho', Branco: 'branco', Azul: 'azul', Amarelo: 'amarelo',
};

export const escape = (s) => String(s).replace(/[&<>"']/g, (c) =>
  ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]
);

export const parseKinName = (name) => {
  const [seal, tone, color] = name.split(' ');
  return { seal, tone, color };
};

export const prettyKin = (name) => {
  const { seal, tone, color } = parseKinName(name);
  return `${SEAL_PT[seal] ?? seal} ${TONE_PT[tone] ?? tone} ${color}`;
};

/** Mayan numeral SVG: dots on top (1–4), bars below (5 each). */
export const toneSvg = (n, opts = {}) => {
  const {
    width = 80, dotR = 6, dotGap = 8, barH = 9, barW = 56,
    gap = 5, className = 'tone-glyph'
  } = opts;

  const bars = Math.floor(n / 5);
  const dots = n % 5;

  let y = 2;
  const parts = [];

  if (dots > 0) {
    const totalW = dots * (dotR * 2) + (dots - 1) * dotGap;
    const startX = (width - totalW) / 2 + dotR;
    for (let i = 0; i < dots; i++) {
      parts.push(`<circle cx="${startX + i * (dotR * 2 + dotGap)}" cy="${y + dotR}" r="${dotR}"/>`);
    }
    y += dotR * 2 + gap;
  }

  for (let i = 0; i < bars; i++) {
    parts.push(`<rect x="${(width - barW) / 2}" y="${y}" width="${barW}" height="${barH}" rx="2"/>`);
    y += barH + gap;
  }

  return `<svg class="${className}" viewBox="0 0 ${width} ${y}" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">${parts.join('')}</svg>`;
};

export function setupForm(renderFn) {
  const form = document.getElementById('form');
  const input = document.getElementById('date');
  const result = document.getElementById('result');

  const today = new Date();
  const pad = (n) => String(n).padStart(2, '0');
  input.value = `${today.getFullYear()}-${pad(today.getMonth() + 1)}-${pad(today.getDate())}`;

  const compute = () => {
    const [y, m, d] = input.value.split('-').map(Number);
    if (!y || !m || !d) return;
    result.innerHTML = renderFn(kinInfo({ year: y, month: m, day: d }));
  };

  form.addEventListener('submit', (e) => { e.preventDefault(); compute(); });
  compute();
}
