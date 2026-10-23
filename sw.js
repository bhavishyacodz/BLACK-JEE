/* BLACK-JEE app-shell cache: instant page shell, live data stays network-backed.
   Bump CACHE_NAME whenever shell files change so installed clients refresh cleanly. */
const CACHE_NAME = "black-jee-shell-v37";
const APP_FILES = [
  "index.html",
  "attempt.html",
  "pyq.html",
  "archive.html",
  "profile.html",
  "pyq-admin.html",
  "chapterwise.html",
  "chapter-practice.html",
  "mock-tests.html",
  "prep.html",
  "rules.html",
  "admin.html",
  "owner-dashboard.html",
  "shift-workbench.html",
  "diagram-audit.html"
];

self.addEventListener("install", event => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    await Promise.allSettled(APP_FILES.map(async file => {
      const url = new URL(file, self.registration.scope);
      const response = await fetch(url, { cache: "reload" });
      if (response.ok) await cache.put(url.href, response);
    }));
    await self.skipWaiting();
  })());
});

self.addEventListener("activate", event => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(key => key.startsWith("black-jee-shell-") && key !== CACHE_NAME).map(key => caches.delete(key)));
    await self.clients.claim();
  })());
});

self.addEventListener("fetch", event => {
  const request = event.request;
  if (request.method !== "GET" || new URL(request.url).origin !== self.location.origin) return;

  const url = new URL(request.url);
  const isPage = request.mode === "navigate" && (url.pathname.endsWith("/") || APP_FILES.some(file => url.pathname.endsWith("/" + file)));
  if (!isPage) return;

  event.respondWith((async () => {
    const cache = await caches.open(CACHE_NAME);
    const isHomeRoot = url.pathname.endsWith("/");
    const cacheUrl = isHomeRoot ? new URL("index.html", self.registration.scope).href : url.href;
    const cached = await cache.match(cacheUrl);

    const refresh = fetch(request).then(async response => {
      if (response.ok) {
        const target = isHomeRoot ? new URL("index.html", self.registration.scope).href : url.href;
        await cache.put(target, response.clone());
      }
      return response;
    });

    if (cached) {
      event.waitUntil(refresh.catch(() => {}));
      return cached;
    }
    return refresh;
  })());
});
