console.log('[Service Worker] Hello world!')

var CACHE_NAME = 'v1-cached-assets'

function onInstall (event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function prefill (cache) {
      return cache.addAll([
        // files to cache
      ])
    })
  )
}

function onActivate (event) {
  console.log('[Serviceworker]', "Activating!", event)
  event.waitUntil(
    caches.keys().then(function (cacheNames) {
      return Promise.all(
        cacheNames.filter(function (cacheName) {
          // Return true if you want to remove this cache,
          // but remember that caches are shared across
          // the whole origin
           return cacheName.indexOf('v1') !== 0
        }).map(function (cacheName) {
          return caches.delete(cacheName)
        })
      )
    })
  )
}

self.addEventListener('install', onInstall)
self.addEventListener('activate', onActivate)
