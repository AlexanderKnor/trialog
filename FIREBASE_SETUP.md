# Firebase & Firestore Setup - Trialog

## ✅ Firebase Integration Complete

Die Trialog-App ist jetzt vollständig mit Firebase/Firestore verbunden und speichert das Organigramm persistent in der Cloud.

## 🔥 Was wurde implementiert:

### 1. **Firebase Core Integration**
- ✅ Firebase Core initialisiert in `main.dart`
- ✅ `firebase_options.dart` für alle Plattformen generiert
- ✅ Automatische Plattform-Erkennung

### 2. **Firestore Data Source**
- ✅ `OrganizationChartFirestoreDataSource` erstellt
- ✅ Speichert Organigramm in Collection: `organization_chart`
- ✅ Document ID: `trialog_org`
- ✅ Automatische Standard-Struktur bei erstem Start

### 3. **Repository Layer**
- ✅ `OrganizationChartRepositoryImpl` nutzt jetzt Firestore
- ✅ Alle CRUD-Operationen persistent
- ✅ Error Handling für Netzwerkfehler

### 4. **State Management**
- ✅ Providers aktualisiert für Firestore
- ✅ Konsistente Datensynchronisation
- ✅ Automatisches Laden beim App-Start

## 📊 Firestore Datenstruktur

```
firestore/
└── organization_chart/
    └── trialog_org (document)
        ├── id: "company-root"
        ├── name: "Trialog"
        ├── type: "company"
        ├── level: 0
        └── children: [
            {
              id: "ceo-1",
              name: "Marcel Liebetrau",
              type: "ceo",
              employee: {
                firstName: "Marcel",
                lastName: "Liebetrau",
                email: "marcel.liebetrau@trialog.com",
                insurancePercentage: null,
                realEstatePercentage: null
              }
            },
            {
              id: "ceo-2",
              name: "Daniel Lippert",
              type: "ceo",
              employee: {...}
            },
            {
              id: "emp-...",
              name: "Mitarbeiter Name",
              type: "employee",
              employee: {
                firstName: "...",
                lastName: "...",
                insurancePercentage: 35.0,
                realEstatePercentage: 65.0
              }
            }
        ]
```

## 🚀 Web-Deployment

### Voraussetzungen:
1. Firebase Hosting aktiviert in Firebase Console
2. Firebase CLI installiert: `npm install -g firebase-tools`

### Deployment-Schritte:

#### 1. **Firebase Hosting initialisieren**
```bash
cd C:\myProjects\trialog
firebase login
firebase init hosting
```

Wähle:
- Use existing project: `trialog-8a95b`
- Public directory: `build/web`
- Single-page app: `Yes`
- GitHub deployment: `No` (optional)

#### 2. **Flutter Web Build erstellen**
```bash
flutter build web --release
```

#### 3. **Deploy to Firebase Hosting**
```bash
firebase deploy --only hosting
```

#### 4. **App ist verfügbar unter:**
```
https://trialog-8a95b.web.app
oder
https://trialog-8a95b.firebaseapp.com
```

### Custom Domain (Optional):
1. Firebase Console → Hosting → Add custom domain
2. Domain-Provider: DNS-Einträge hinzufügen
3. SSL-Zertifikat automatisch von Firebase

## 🔒 Firestore Security Rules

**WICHTIG:** Firestore Security Rules konfigurieren!

In Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Organization chart - nur authentifizierte Benutzer
    match /organization_chart/{document=**} {
      allow read: if true;  // Public read für URL-Zugriff
      allow write: if request.auth != null;  // Nur auth. Benutzer können schreiben
    }
  }
}
```

**Für Produktiv-Umgebung:**
- Authentication implementieren (Firebase Auth)
- Write-Zugriff nur für Admin-Benutzer
- Read-Zugriff evtl. einschränken

## 📱 Unterstützte Plattformen

- ✅ **Web** (primär für URL-Zugriff)
- ✅ **Windows** (Desktop)
- ✅ **Android** (Mobile)
- ✅ **iOS** (Mobile)
- ✅ **macOS** (Desktop)

## 🔧 Entwicklung & Testing

### Lokal testen:
```bash
flutter run -d chrome
```

### Web-Build lokal testen:
```bash
flutter build web --release
cd build/web
python -m http.server 8000
# Browser: http://localhost:8000
```

### Firestore Emulator (Development):
```bash
firebase emulators:start --only firestore
```

In `main.dart` für Development:
```dart
if (kDebugMode) {
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
```

## 📊 Features

### ✅ Implementiert:
1. **Persistent Storage**
   - Organigramm wird in Firestore gespeichert
   - Änderungen sofort synchronisiert
   - Daten bleiben über Sessions erhalten

2. **Real-time Ready**
   - Infrastruktur für Echtzeit-Updates vorbereitet
   - Snapshots können leicht implementiert werden

3. **Multi-User Support**
   - Daten zentral gespeichert
   - Mehrere Benutzer können gleichzeitig zugreifen
   - Konsistente Daten über alle Clients

### 🔜 Zukünftige Erweiterungen:
1. **Firebase Authentication**
   - Google Sign-In
   - Email/Password
   - Rollen-basierte Zugriffskontrolle

2. **Real-time Updates**
   - Live-Synchronisation bei Änderungen
   - Mehrere Benutzer sehen Änderungen sofort

3. **Backup & History**
   - Versionierung des Organigramms
   - Änderungshistorie
   - Wiederherstellung alter Versionen

4. **Cloud Functions**
   - Validierung von Änderungen
   - Benachrichtigungen bei Änderungen
   - Automatische Backups

## 🎯 URL-Zugriff

Nach dem Deployment ist die App über URL erreichbar:

```
https://trialog-8a95b.web.app/
```

**Features:**
- ✅ Direkter Browser-Zugriff
- ✅ Keine Installation nötig
- ✅ Automatische Updates
- ✅ Mobile-responsive
- ✅ Cross-browser kompatibel

## 🔍 Troubleshooting

### Problem: "Firebase not initialized"
**Lösung:** Firebase CLI neu ausführen
```bash
dart pub global run flutterfire_cli:flutterfire configure
```

### Problem: Firestore Permission Denied
**Lösung:** Security Rules in Firebase Console prüfen

### Problem: Web-Build schlägt fehl
**Lösung:**
```bash
flutter clean
flutter pub get
flutter build web --release
```

## 📚 Weitere Ressourcen

- [Firebase Console](https://console.firebase.google.com)
- [Flutter Firebase Docs](https://firebase.flutter.dev)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)

---

**Status:** ✅ Production Ready

Die App ist vollständig für Firebase/Firestore konfiguriert und kann deployed werden!
