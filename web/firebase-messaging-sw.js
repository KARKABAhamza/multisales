// Firebase Cloud Messaging Service Worker
// MultiSales App - Firebase Messaging Service Worker

// Import Firebase scripts
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Initialize Firebase
firebase.initializeApp({
  apiKey: "AIzaSyBz4EfU40riAMXt3sdKFFFq5Lc_X5W6WGQ",
  authDomain: "multisales-18e57.firebaseapp.com",
  projectId: "multisales-18e57",
  storageBucket: "multisales-18e57.firebasestorage.app",
  messagingSenderId: "967872205422",
  appId: "1:967872205422:web:b16f6c6b6d6cedc5464c7f",
  measurementId: "G-3DB4WDLJ7X"
});

// Retrieve Firebase Messaging object
const messaging = firebase.messaging();

// Background message handler
messaging.onBackgroundMessage(function(payload) {
  console.log('Received background message: ', payload);

  const notificationTitle = payload.notification.title || 'MultiSales Notification';
  const notificationOptions = {
    body: payload.notification.body || 'You have a new message',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: 'multisales-notification',
    data: payload.data
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification click
self.addEventListener('notificationclick', function(event) {
  console.log('Notification clicked:', event);

  event.notification.close();

  // Handle the click action
  event.waitUntil(
    clients.openWindow(event.notification.data?.url || '/')
  );
});
