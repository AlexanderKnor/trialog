# Trialog Revenue Tracking App

Eine Flutter-App zum Tracking von Mitarbeiter-Umsätzen für Trialog.

## Übersicht

Die Trialog App ermöglicht es Mitarbeitern, ihre Umsätze einfach zu erfassen und zu verwalten.

## Features

### Für Mitarbeiter
- Umsätze erfassen und verwalten
- Übersicht eigener Umsätze
- Filterung nach Zeitraum
- Detailansicht einzelner Einträge
- Umsätze bearbeiten und löschen

## Architektur

Das Projekt folgt der **Clean Architecture** nach dem Universal Project Blueprint:

```
lib/
├── core/                      # Kern-Funktionalität
│   ├── config/               # App-Konfiguration
│   ├── constants/            # Konstanten (Farben, Text-Styles, etc.)
│   ├── errors/               # Error Handling (Failures, Exceptions)
│   ├── theme/                # App Theme
│   └── utils/                # Utilities (Formatters, Validators)
│
├── features/                 # Feature-Module
│   └── revenue_tracking/     # Umsatz-Tracking
│       ├── domain/          # Business Logic
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── use_cases/
│       ├── data/            # Daten-Layer
│       │   ├── models/
│       │   ├── repositories/
│       │   └── data_sources/
│       └── presentation/    # UI-Layer
│           ├── screens/
│           ├── widgets/
│           └── state/
│
└── shared/                   # Geteilte Komponenten
    ├── components/          # Wiederverwendbare UI-Komponenten
    ├── services/            # Geteilte Services
    └── models/              # Geteilte Models
```

## Corporate Design

### Farben
- **Primary**: #10274C (Dunkelblau) - rgba(16,39,76,255)
- Verwendet für Hauptelemente, Buttons, AppBar

### Schriftart
- **Logo**: Bodoni 72, Größe 12
- **Text**: Bodoni 72, Größe 9

> **Hinweis**: Die Bodoni 72 Schriftart muss manuell zum Projekt hinzugefügt werden.
> Siehe Abschnitt "Schriftarten hinzufügen" unten.

## Setup

### Voraussetzungen
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / Xcode (für mobile Entwicklung)

### Installation

1. Repository klonen:
```bash
cd /mnt/c/myProjects/trialog
```

2. Dependencies installieren:
```bash
flutter pub get
```

3. App starten:
```bash
flutter run
```

## Schriftarten hinzufügen

Um die Bodoni 72 Schriftart zu verwenden:

1. Erstelle einen `assets/fonts/` Ordner im Projekt-Root
2. Füge die Bodoni 72 Schriftdateien hinzu:
   - `Bodoni72-Book.otf` (Regular, weight 400)
   - `Bodoni72-Bold.otf` (Bold, weight 600)
3. Entkommentiere die Schriftart-Konfiguration in `pubspec.yaml`
4. Führe `flutter pub get` aus

Falls die Schriftart nicht verfügbar ist, nutzt die App automatisch System-Serif-Schriften als Fallback.

## Entwicklung

### State Management
Das Projekt verwendet **Riverpod** für State Management.

### Dependency Injection
Repositories und Services werden über Riverpod Providers bereitgestellt.

### Testing
```bash
# Unit Tests
flutter test

# Integration Tests
flutter test integration_test/
```

## Deployment

### Web (URL-basiert)
```bash
# Production Build für Web
flutter build web --release

# Build Output: build/web/
```

Die App ist **vollständig für Web optimiert** mit:
- ✅ URL-basiertem Routing (Clean URLs ohne #)
- ✅ Deep Linking zu allen Seiten
- ✅ PWA Support
- ✅ Responsive Design

**Verfügbare URLs:**
- `/` - Umsatz-Übersicht (Home)
- `/revenues/add` - Umsatz hinzufügen
- `/revenues/{id}` - Umsatz Details
- `/revenues/{id}/edit` - Umsatz bearbeiten
- `/profile` - Profil
- `/login` - Login

📖 **Vollständige Web-Deployment-Anleitung:** Siehe [WEB_DEPLOYMENT.md](WEB_DEPLOYMENT.md)

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Nächste Schritte

### TODO
- [ ] Authentication implementieren
- [ ] Backend API anbinden
- [ ] State Management mit Riverpod vervollständigen
- [ ] Umsatz-Erfassungsformular erstellen
- [ ] Umsatz-Detailansicht erstellen
- [ ] Filterung und Suche implementieren
- [ ] Statistiken und Übersichten für Mitarbeiter
- [ ] Offline-Support mit lokaler Datenbank
- [ ] Unit Tests schreiben
- [ ] Integration Tests schreiben
- [ ] Bodoni 72 Schriftart hinzufügen

## Technologie-Stack

- **Framework**: Flutter (Web, iOS, Android)
- **Sprache**: Dart
- **Routing**: Go Router (URL-basiert)
- **State Management**: Riverpod
- **Networking**: Dio
- **Local Storage**: SharedPreferences
- **Functional Programming**: Dartz
- **Formatting**: Intl

## Lizenz

Private - Trialog Internal Use Only

## Kontakt

Entwicklung: [Kontaktinformationen]
