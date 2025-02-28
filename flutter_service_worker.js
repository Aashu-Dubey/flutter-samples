'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"index.html": "1b17c1b958923bc6124eb2bc754ced6f",
"/": "1b17c1b958923bc6124eb2bc754ced6f",
"assets/NOTICES": "2ff6909c19d96b5b1ffdc304ef860b86",
"assets/assets/fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/assets/fonts/Inter-SemiBold.ttf": "3e87064b7567bef4ecd2ba977ce028bc",
"assets/assets/fonts/Inter-Regular.ttf": "eba360005eef21ac6807e45dc8422042",
"assets/assets/samples/animations/custom_caret.png": "20981f24710cf990547de0fc7afeb02b",
"assets/assets/samples/animations/grid_magnification.png": "41f29b27e0ebe06677eb922e2d0662a9",
"assets/assets/samples/ui/rive_app/course_rive.png": "d44d0e167f27418546a2d99637026da7",
"assets/assets/samples/ui/rive_app/images/backgrounds/spline.png": "ff232f0cf3ebd732ca4383c381450714",
"assets/assets/samples/ui/rive_app/images/icon_email.png": "d51efbd50789a569a1e4a37c261ba1ab",
"assets/assets/samples/ui/rive_app/images/avatars/avatar_3.jpg": "4431bc261ac4f57a09dc1e041b32b4d1",
"assets/assets/samples/ui/rive_app/images/avatars/avatar_4.jpg": "95617f142e8dcfa6547ea80557eee016",
"assets/assets/samples/ui/rive_app/images/avatars/avatar_5.jpg": "405a74c93f4806312fcd25e7722d9f90",
"assets/assets/samples/ui/rive_app/images/avatars/avatar_2.jpg": "9eecb4a8f2da90198bf8c4f8c3e8c527",
"assets/assets/samples/ui/rive_app/images/avatars/avatar_default.jpg": "fe9d7eaf1b437a1e6c84f1e6fdb77dcf",
"assets/assets/samples/ui/rive_app/images/avatars/avatar_6.jpg": "57b1f154ef47c7a76a78544e9e6af44f",
"assets/assets/samples/ui/rive_app/images/avatars/avatar_1.jpg": "60f969aae689291e30cffc6deafd1ec2",
"assets/assets/samples/ui/rive_app/images/logo_email.png": "5fe423ad3604e1dbe76d28abb4e5ff32",
"assets/assets/samples/ui/rive_app/images/icon_lock.png": "6304d0d510c62248bdd66496eda1aa29",
"assets/assets/samples/ui/rive_app/images/logo_apple.png": "0076612741142de81e9fb1f30143fa84",
"assets/assets/samples/ui/rive_app/images/logo_google.png": "2b6687b80bdccdf64a6ebccb12aefc80",
"assets/assets/samples/ui/rive_app/images/topics/topic_2.png": "6890179d440608f2f6795e9ee8e6c288",
"assets/assets/samples/ui/rive_app/images/topics/topic_1.png": "39f4beb48bac22f2e10895a831a4e7a6",
"assets/assets/samples/ui/rive_app/rive/menu_button.riv": "f8fdfd9fd8dc7873dfac6f005f3233c1",
"assets/assets/samples/ui/rive_app/rive/button.riv": "c8ffe2900d31d8236247928cd7c2b5f3",
"assets/assets/samples/ui/rive_app/rive/check.riv": "14f9269423eabd7e2e10cafdc6ad4d41",
"assets/assets/samples/ui/rive_app/rive/icons.riv": "3d29f9acebef13f01f371b59e84e664b",
"assets/assets/samples/ui/rive_app/rive/shapes.riv": "8839d67714d5e9c52b3e0dbb2b1e89c1",
"assets/assets/samples/ui/rive_app/rive/confetti.riv": "ad0d13cbea799085305316f0e8118274",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "ae3a20a7eea8976ba172bb25ac407f48",
"assets/fonts/MaterialIcons-Regular.otf": "0f669f8a3fa93246c3e1c8b996181431",
"assets/FontManifest.json": "fbd224bbd2dd10a4d8a2cf2a79533de1",
"assets/AssetManifest.bin.json": "ce734a8a8817371252befddf3e8c5b17",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/AssetManifest.json": "24d28a40de012adffe2a58e900753199",
"version.json": "f3ff2a099e28b54b319f65daca5d95ad",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js": "b95a2ced08d39ab8984d1f4abb55db53",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "2e25d5541cf06e58f1f971d0c999c9cf",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "640e4a0579baf13ac707e8c44e689b38"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
