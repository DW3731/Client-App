importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDtupIb8fQ6Bt-npxuQZZeS8zDBc2SmMXM",
    authDomain: "fooddeliverydw.firebaseapp.com",
    databaseURL: "https://fooddeliverydw-default-rtdb.firebaseio.com",
    projectId: "fooddeliverydw",
    storageBucket: "fooddeliverydw.appspot.com",
    messagingSenderId: "658226305344",
    appId: "1:658226305344:web:a4f9dbd1fcffdc3e2d82a5",
    measurementId: "G-Y4HTMWRWJ9"
   databaseURL: "https://fooddeliverydw-default-rtdb.firebaseio.com",
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});