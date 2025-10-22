# Trialog Development Workflow

## 🔧 Hot Reload Problem (gelöst)

### Problem:
Bei Hot Reload (Refresh) im Web-Browser kann die App hängen bleiben, und VSCode öffnet eine leere `web_entrypoint.dart` Datei.

### ✅ Lösung implementiert:

#### 1. **Firebase Re-Initialisierung verhindert**
```dart
// main.dart
if (Firebase.apps.isEmpty) {
  await Firebase.initializeApp(...);
}
```
- Prüft, ob Firebase bereits initialisiert ist
- Verhindert Fehler bei Hot Reload

#### 2. **Provider Lifecycle optimiert**
```dart
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  ref.keepAlive();  // Provider bleibt aktiv
  return FirebaseFirestore.instance;
});
```
- `keepAlive()` verhindert Provider-Neustart
- Firestore-Verbindung bleibt bestehen

#### 3. **web_entrypoint.dart ignoriert**
```gitignore
**/web_entrypoint.dart
```
- Debug-Datei wird nicht mehr in Git eingecheckt
- Wird von Flutter automatisch generiert

## 🚀 Empfohlener Workflow

### Während der Entwicklung:

#### ❌ NICHT verwenden:
```
Browser Refresh (F5)         → Kann App einfrieren
Hot Reload (r)               → Probleme mit Firebase
```

#### ✅ STATTDESSEN:
```bash
# Bei Änderungen:
1. Code ändern
2. Hot Restart drücken: R (Shift + R in Terminal)
3. Oder: App neu starten (q + flutter run)
```

### VSCode Shortcuts:

**In VSCode Terminal:**
- `R` (Shift+R) - Hot Restart (empfohlen)
- `r` - Hot Reload (vermeiden)
- `q` - App beenden

**Oder VSCode Debug Controls:**
- Restart Button (Kreis-Pfeil) - Hot Restart ✅
- Stop + Start - Kompletter Neustart ✅

## 🧪 Testing-Workflow

### Lokale Entwicklung:
```bash
# 1. App im Debug-Modus starten
flutter run -d chrome

# 2. Bei Änderungen: Hot Restart (R)
# Drücke Shift+R im Terminal

# 3. Bei größeren Änderungen: Neustart
# q drücken, dann: flutter run -d chrome
```

### Production Testing:
```bash
# 1. Release-Build erstellen
flutter build web --release

# 2. Lokal testen
cd build/web
python -m http.server 8000

# 3. Browser öffnen
# http://localhost:8000

# 4. Testen ohne Debug-Probleme
```

## 🐛 Troubleshooting

### Problem: App hängt nach Refresh
**Lösung:**
1. Terminal öffnen
2. `q` drücken (App beenden)
3. `flutter run -d chrome` (Neustart)

### Problem: "Firebase already initialized" Error
**Status:** ✅ Behoben durch `Firebase.apps.isEmpty` Check

### Problem: web_entrypoint.dart öffnet sich
**Status:** ✅ Datei ist jetzt in .gitignore
**Aktion:** Einfach schließen, ist eine Debug-Datei

### Problem: Firestore Permission Denied
**Ursache:** Rules nicht deployed
**Lösung:**
```bash
firebase deploy --only firestore:rules
```

### Problem: Daten werden nicht gespeichert
**Prüfen:**
1. Firebase Console → Firestore → Data
2. Collection `organization_chart` vorhanden?
3. Document `trialog_org` vorhanden?
4. Network Tab im Browser → Firestore Requests erfolgreich?

## 🎯 Best Practices

### DO ✅
- Hot Restart (R) statt Hot Reload verwenden
- Release-Builds für Production-Testing
- Firestore Rules vor dem Deploy prüfen
- App komplett neu starten bei größeren Änderungen

### DON'T ❌
- Browser-Refresh (F5) vermeiden während Entwicklung
- Hot Reload (r) vermeiden mit Firebase
- Debug-Builds für Production verwenden

## 🚀 Deployment-Workflow

### Schritt-für-Schritt:

```bash
# 1. Code-Qualität prüfen
flutter analyze

# 2. Firestore Rules & Indexes deployen (bei Änderungen)
firebase deploy --only firestore

# 3. Release-Build erstellen
flutter build web --release

# 4. Hosting deployen
firebase deploy --only hosting

# 5. URL testen
# https://trialog-8a95b.web.app

# 6. Firestore Console prüfen
# https://console.firebase.google.com/project/trialog-8a95b/firestore
```

### Schnell-Deploy:
```bash
flutter build web --release && firebase deploy --only hosting
```

## 📊 Performance-Tipps

### Web-Build Optimierung:
```bash
# Standard (empfohlen)
flutter build web --release

# Mit Optimierungen
flutter build web --release --web-renderer canvaskit --dart-define=FLUTTER_WEB_USE_SKIA=true

# Kleinere Bundle-Size
flutter build web --release --web-renderer html --split-debug-info=build/debug --obfuscate
```

### Firestore Optimierung:
```dart
// Enable offline persistence (in development)
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

## 🔄 Git Workflow

```bash
# Vor Commit
1. flutter analyze                    # Keine Fehler
2. Test in Chrome                     # Funktioniert
3. flutter build web --release        # Build erfolgreich

# Commit
git add .
git commit -m "Description"
git push

# Deploy
firebase deploy
```

## 📚 Hilfreiche Befehle

```bash
# App starten
flutter run -d chrome

# Neustart während Entwicklung
# Im Terminal: Shift+R

# App beenden
# Im Terminal: q

# Logs anzeigen
# Im Browser: F12 → Console

# Firestore Live-Daten
# Firebase Console → Firestore → Data

# Hosting-URL
# https://trialog-8a95b.web.app
```

---

**Status:** ✅ Optimiert für stabiles Development

Die App ist jetzt resistent gegen Hot Reload-Probleme und bereit für produktive Entwicklung!
