# Trialog Deployment Guide

## 📋 Übersicht

Dieser Guide erklärt, wie Sie Firestore Rules, Indexes und die Web-App deployen.

## ✅ Voraussetzungen

- ✅ Firebase Projekt erstellt (`trialog-8a95b`)
- ✅ Firestore Database aktiviert
- ✅ Firebase CLI installiert: `npm install -g firebase-tools`

## 🔥 Schritt 1: Firestore Rules & Indexes deployen

### 1.1 Firebase Login
```bash
firebase login
```

### 1.2 Firestore Rules deployen
```bash
firebase deploy --only firestore:rules
```

**Was passiert:**
- `firestore.rules` wird zu Firebase hochgeladen
- Definiert Zugriffskontrolle für Firestore
- **Read**: Öffentlich (für URL-Zugriff)
- **Write**: Nur für Admins (Marcel, Daniel)

### 1.3 Firestore Indexes deployen
```bash
firebase deploy --only firestore:indexes
```

**Was passiert:**
- `firestore.indexes.json` wird zu Firebase hochgeladen
- Optimiert Firestore-Queries
- Verbessert Performance

### 1.4 Beides zusammen deployen
```bash
firebase deploy --only firestore
```

## 🔒 Security Rules Erklärung

### Aktuelle Rules (`firestore.rules`):

```javascript
// Organigramm
match /organization_chart/{document} {
  allow read: if true;  // Öffentlich lesbar (für URL-Zugriff)
  allow write: if isAdmin();  // Nur Admins können ändern
}
```

### Admin-Benutzer:
- marcel.liebetrau@trialog.com
- daniel.lippert@trialog.com

### Sicherheitsstufen:

**Stufe 1 (Aktuell - Public Read):**
- ✅ Jeder kann Organigramm sehen
- ✅ Nur Admins können ändern
- ✅ Gut für öffentliche URL

**Stufe 2 (Optional - Auth Required):**
```javascript
allow read: if isAuthenticated();
allow write: if isAdmin();
```
- Nur angemeldete Benutzer sehen Organigramm
- Nur Admins können ändern

**Stufe 3 (Optional - Full Auth):**
- Firebase Authentication implementieren
- Login-Screen hinzufügen
- Token-basierte Zugriffskontrolle

## 🌐 Schritt 2: Web-App deployen

### 2.1 Flutter Web Build erstellen
```bash
flutter build web --release
```

**Build-Optionen:**
```bash
# Mit Web Renderer Auswahl
flutter build web --release --web-renderer canvaskit  # Bessere Grafik
flutter build web --release --web-renderer html       # Kleinere Größe
flutter build web --release --web-renderer auto       # Automatisch
```

### 2.2 Firebase Hosting deployen
```bash
firebase deploy --only hosting
```

### 2.3 Kompletter Deploy (Rules + Indexes + Hosting)
```bash
firebase deploy
```

## 📱 Schritt 3: App testen

### Nach dem Deployment:

**URL öffnen:**
```
https://trialog-8a95b.web.app
```

**Funktionen testen:**
1. ✅ Organigramm wird angezeigt (Marcel, Daniel, Trialog)
2. ✅ Mitarbeiter hinzufügen funktioniert
3. ✅ Mitarbeiter löschen funktioniert
4. ✅ Daten bleiben nach Reload erhalten (Firestore)
5. ✅ URL in anderem Browser öffnen → gleiche Daten

## 🔧 Entwicklungs-Workflow

### Lokale Entwicklung:
```bash
# Lokaler Server mit Firestore-Verbindung
flutter run -d chrome

# Änderungen werden direkt in Firestore gespeichert
```

### Testing vor Deploy:
```bash
# Build erstellen
flutter build web --release

# Lokal testen
cd build/web
python -m http.server 8000

# Browser: http://localhost:8000
```

### Deploy-Workflow:
```bash
# 1. Code testen
flutter run -d chrome

# 2. Analyze
flutter analyze

# 3. Build
flutter build web --release

# 4. Deploy
firebase deploy --only hosting

# 5. Testen
# https://trialog-8a95b.web.app öffnen
```

## 📊 Firebase Console Überprüfung

### Firestore Database prüfen:

1. Öffnen: https://console.firebase.google.com
2. Projekt auswählen: `trialog-8a95b`
3. Firestore Database → Data
4. Collection: `organization_chart`
5. Document: `trialog_org`

**Erwartete Struktur:**
```
organization_chart/
└── trialog_org
    ├── id: "company-root"
    ├── name: "Trialog"
    ├── type: "company"
    ├── level: 0
    └── children: [Array of employees]
```

### Rules überprüfen:

1. Firestore Database → Rules
2. Sollte Inhalt von `firestore.rules` zeigen
3. Status: **Published** (grün)

### Hosting überprüfen:

1. Hosting → Dashboard
2. Domains anzeigen
3. Release History

## 🚨 Troubleshooting

### Problem: "Permission Denied" beim Schreiben
**Ursache:** Firestore Rules nicht deployed oder zu restriktiv
**Lösung:**
```bash
firebase deploy --only firestore:rules
```

### Problem: "Missing index" Error
**Ursache:** Firestore benötigt Index für Query
**Lösung:**
```bash
firebase deploy --only firestore:indexes
```
Oder: Firebase Console zeigt Link zum automatischen Index-Erstellen

### Problem: Web-App lädt nicht
**Lösung:**
```bash
flutter clean
flutter pub get
flutter build web --release
firebase deploy --only hosting
```

### Problem: Firestore-Daten verschwinden
**Ursache:** Evtl. Test-Modus läuft ab
**Lösung:** Firestore Rules deployen (permanente Rules)

## 📝 Checkliste vor Production-Deploy

- [ ] `flutter analyze` - Keine Fehler
- [ ] `flutter build web --release` - Build erfolgreich
- [ ] Firestore Rules deployed
- [ ] Firestore Indexes deployed
- [ ] Security Rules getestet
- [ ] App lokal getestet
- [ ] Staging-Deployment getestet
- [ ] Admin-Zugriff verifiziert
- [ ] Performance-Test durchgeführt

## 🎯 Nächste Schritte

### Jetzt sofort deployen:

```bash
# Im Projekt-Verzeichnis (C:\myProjects\trialog)

# 1. Rules & Indexes deployen
firebase deploy --only firestore

# 2. Web-Build erstellen
flutter build web --release

# 3. Hosting deployen
firebase deploy --only hosting

# 4. URL öffnen
# https://trialog-8a95b.web.app
```

### Optional: Custom Domain einrichten

1. Firebase Console → Hosting → Add custom domain
2. Domain: z.B. `organigramm.trialog.com`
3. DNS-Einträge beim Domain-Provider hinzufügen
4. SSL-Zertifikat wird automatisch erstellt

## 📚 Weitere Infos

- Firebase Console: https://console.firebase.google.com/project/trialog-8a95b
- Firebase Docs: https://firebase.google.com/docs
- Flutter Web Docs: https://docs.flutter.dev/platform-integration/web

---

**Status:** ✅ Ready to Deploy

Alle Konfigurationsdateien sind erstellt und bereit für Deployment!
