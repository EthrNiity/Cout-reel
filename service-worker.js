// Service worker minimal : met en cache l'app shell pour un chargement rapide
// et un affichage possible même avec une connexion faible.
// Les données elles-mêmes viennent toujours de Supabase (jamais mises en cache ici).

const CACHE_NAME = 'cout-reel-v3';
const APP_SHELL = [
  './',
  './index.html',
  './manifest.json',
  './icon.svg',
  './icon-192.png',
  './icon-512.png',
  './icon-192-maskable.png',
  './icon-512-maskable.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  // Ne jamais mettre en cache les appels à Supabase : toujours du réseau frais.
  if (url.hostname.endsWith('.supabase.co')) return;

  // Stratégie "réseau d'abord" : on va toujours chercher la dernière version
  // en ligne en priorité, et on ne retombe sur le cache qu'en cas d'échec
  // (hors-ligne). Ça évite qu'une ancienne version reste bloquée en cache
  // après une mise à jour du code.
  event.respondWith(
    fetch(event.request)
      .then((response) => {
        const copy = response.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
        return response;
      })
      .catch(() => caches.match(event.request))
  );
});
