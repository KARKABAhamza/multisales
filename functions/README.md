# MULTISALES - Cloud Functions

Ce dossier contient les Cloud Functions destinées au projet Firebase `multisales-18e57`.

Fonctions fournies:

- `onOrderCreate` (Firestore trigger) : décrémente stock & crée notification
- `onUserCreate` (Auth trigger) : crée le profil utilisateur dans Firestore
- `getSignedUploadUrl` (HTTPS Callable) : génère une URL signée pour upload direct en Storage
- `sendContactEmail` (HTTPS Callable) : enregistre le message contact et envoie un email via SendGrid

## Prérequis

- Node.js 18
- Firebase CLI (`npm i -g firebase-tools`)
- Être connecté avec `firebase login`
- Avoir initialisé le projet Firebase (ou simplement copier ce dossier à la racine du repo)

## Installation

```bash
cd functions
npm install
```

## Lancement en local (Emulator Suite)

```bash
# À la racine du repo
firebase emulators:start --only functions
# ou depuis functions/
npm start
```

Le port par défaut des Functions Emulator est `5001`. Vous pouvez configurer les ports via `firebase.json` ou `firebase.json` global.

## Déploiement

```bash
# Depuis functions/
npm run deploy
# équivaut à
firebase deploy --only functions --project=multisales-18e57
```

## Configuration SendGrid

Deux options sont possibles pour fournir la clé d'API SendGrid :

1) Via le gestionnaire de secrets Firebase (recommandé)

```bash
# Remplacez le projet si besoin
firebase functions:secrets:set SENDGRID_API_KEY --project=multisales-18e57
# Saisissez la clé quand demandé (elle ne sera pas affichée)
```

Dans le code, la fonction `sendContactEmail` est déclarée avec `runWith({ secrets: ['SENDGRID_API_KEY'] })` et lira automatiquement la clé depuis `process.env.SENDGRID_API_KEY`.

1) Via la configuration Functions (alternative)

```bash
firebase functions:config:set sendgrid.key="<API_KEY>" sendgrid.from="no-reply@multisales.ma" sendgrid.to="contact@multisales.ma"
```

Vous pouvez aussi définir `SENDGRID_FROM` et `SENDGRID_TO` via `functions.config().sendgrid` (non sensibles) ou des variables d'environnement selon vos préférences.

Après configuration, redeployez les fonctions:

```bash
firebase deploy --only functions --project=multisales-18e57
```

## Appels depuis le client

### sendContactEmail (Flutter)

Configuration requise SendGrid (une des options) :

> Remarque: si vous utilisez le gestionnaire de secrets (recommandé), seule `SENDGRID_API_KEY` est nécessaire. Les adresses `from`/`to` peuvent rester en config Functions (`sendgrid.from`, `sendgrid.to`).

Appel depuis Flutter avec `cloud_functions` :

```dart
import 'package:cloud_functions/cloud_functions.dart';

Future<void> sendContact({required String name, required String email, required String message}) async {
  final callable = FirebaseFunctions.instance.httpsCallable('sendContactEmail');
  final res = await callable.call({ 'name': name, 'email': email, 'message': message });
  final data = Map<String, dynamic>.from(res.data as Map);
  // data = { success: true, savedId: '...', emailSent: true/false }
}
```

### getSignedUploadUrl (Flutter)

Exemple avec `cloud_functions` et `http` pour uploader ensuite via PUT:

```dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;

Future<void> uploadWithSignedUrl() async {
  final callable = FirebaseFunctions.instance.httpsCallable('getSignedUploadUrl');
  final res = await callable.call({
    'path': 'products/123/images/photo.jpg',
    'contentType': 'image/jpeg',
    'expiresInSeconds': 300,
  });

  final data = Map<String, dynamic>.from(res.data as Map);
  final uploadUrl = data['uploadUrl'] as String;
  final publicUrl = data['publicUrl'] as String;

  // Ex: bytes = await pickedFile.readAsBytes();
  final bytes = <int>[]; // TODO: vos octets ici

  final putRes = await http.put(
    Uri.parse(uploadUrl),
    headers: {'Content-Type': 'image/jpeg'},
    body: bytes,
  );

  if (putRes.statusCode == 200) {
    print('Upload OK: $publicUrl');
  } else {
    print('Upload échoué: ${putRes.statusCode} ${putRes.body}');
  }
}
```

### Triggers

- `onOrderCreate`: créez un doc sous `orders/{orderId}` avec un tableau `items` (champs `productId`, `qty`). Le stock de chaque `products/{productId}` est décrémenté et une notification est créée sous `notifications/`.
- `onUserCreate`: à chaque création d’utilisateur Firebase Auth, un profil `users/{uid}` est créé/complété.

## Journalisation et erreurs

- Les logs sont visibles dans la console Firebase et via `functions.logger`.
- En cas d’erreur dans `onOrderCreate`, un document est écrit dans `functionErrors`.

## Configuration additionnelle

- Assurez-vous que votre bucket Storage par défaut est configuré.
- Vérifiez les règles de sécurité Firestore/Storage pour autoriser les accès nécessaires.
- Pour `sendContactEmail`, configurez SendGrid comme indiqué ci‑dessus. Si non configuré, la fonction sauvegarde le contact mais n'enverra pas d'email (emailSent:false).
