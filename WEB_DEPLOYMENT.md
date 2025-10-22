# Web Deployment Guide - Trialog

Diese Anleitung beschreibt, wie die Trialog-App als Web-Anwendung deployed wird und über URLs erreichbar ist.

## Übersicht

Die Trialog-App ist vollständig für Web optimiert und nutzt:
- **Go Router** für URL-basiertes Routing
- **Clean URLs** ohne Hash (#) im Pfad
- **Deep Linking** für direkte Verlinkung zu spezifischen Seiten
- **Progressive Web App (PWA)** Support
- **Responsive Design** für Desktop und Mobile

## Verfügbare URLs

Nach dem Deployment sind folgende URLs für Mitarbeiter verfügbar:

```
https://ihre-domain.de/                      - Umsatz-Übersicht (Home)
https://ihre-domain.de/revenues/add          - Umsatz hinzufügen
https://ihre-domain.de/revenues/{id}         - Umsatz Details
https://ihre-domain.de/revenues/{id}/edit    - Umsatz bearbeiten
https://ihre-domain.de/profile               - Benutzerprofil
https://ihre-domain.de/login                 - Login
```

**Hinweis:** Admin Dashboard Features sind aktuell nicht implementiert.

## Build für Production

### 1. Web Build erstellen

```bash
cd /mnt/c/myProjects/trialog

# Production Build
flutter build web --release

# Oder mit Optimierungen
flutter build web --release --web-renderer canvaskit

# Build output: build/web/
```

### Build-Optionen

```bash
# HTML Renderer (kleinerer Build, schnelleres Laden)
flutter build web --release --web-renderer html

# CanvasKit Renderer (bessere Performance, größerer Build)
flutter build web --release --web-renderer canvaskit

# Auto (Flutter wählt basierend auf Browser)
flutter build web --release --web-renderer auto
```

## Hosting-Optionen

### Option 1: Firebase Hosting (Empfohlen)

```bash
# Firebase CLI installieren
npm install -g firebase-tools

# Firebase Login
firebase login

# Firebase Projekt initialisieren
firebase init hosting

# Konfiguration:
# - Public directory: build/web
# - Single-page app: Yes
# - GitHub auto-deploy: Optional

# Deploy
firebase deploy --only hosting
```

**firebase.json Konfiguration:**
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css|woff2|woff|ttf)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

### Option 2: Nginx

**nginx.conf:**
```nginx
server {
    listen 80;
    server_name ihre-domain.de;

    root /var/www/trialog/build/web;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
}
```

### Option 3: Apache

**.htaccess:**
```apache
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.html [L]
</IfModule>

# Cache static assets
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/jpg "access plus 1 year"
  ExpiresByType image/jpeg "access plus 1 year"
  ExpiresByType image/png "access plus 1 year"
  ExpiresByType text/css "access plus 1 year"
  ExpiresByType application/javascript "access plus 1 year"
  ExpiresByType font/woff2 "access plus 1 year"
</IfModule>
```

### Option 4: GitHub Pages

```bash
# 1. Build erstellen
flutter build web --release --base-href "/trialog/"

# 2. Build zum gh-pages Branch pushen
cd build/web
git init
git add .
git commit -m "Deploy to GitHub Pages"
git branch -M gh-pages
git remote add origin https://github.com/username/trialog.git
git push -f origin gh-pages

# URL: https://username.github.io/trialog/
```

### Option 5: Netlify

```bash
# netlify.toml im Root erstellen
# Dann einfach build/web Ordner hochladen oder Git verbinden
```

**netlify.toml:**
```toml
[build]
  command = "flutter build web --release"
  publish = "build/web"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

## Lokaler Test

```bash
# Development Server starten
flutter run -d chrome

# Oder mit custom port
flutter run -d chrome --web-port=8080

# Production Build lokal testen
cd build/web
python3 -m http.server 8080
# Öffne: http://localhost:8080
```

## SSL/HTTPS Konfiguration

Für Production ist HTTPS **zwingend erforderlich** für PWA-Features.

### Mit Certbot (Let's Encrypt)

```bash
# Certbot installieren
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# Zertifikat erstellen
sudo certbot --nginx -d ihre-domain.de

# Auto-Renewal
sudo certbot renew --dry-run
```

## Performance-Optimierungen

### 1. Build-Optimierungen

```bash
# Minification und Tree-shaking sind standardmäßig aktiv
flutter build web --release

# Source maps deaktivieren für Production
flutter build web --release --source-maps=false

# Dart2js Optimierungen
flutter build web --release --dart-define=Dart2jsOptimization=O4
```

### 2. Caching-Strategie

Service Worker ist automatisch konfiguriert für:
- Offline-Support
- Asset Caching
- API Response Caching (TODO)

### 3. CDN Integration

Für optimale Performance, hoste statische Assets auf CDN:

```bash
# Build mit CDN URL
flutter build web --release --base-href https://cdn.ihre-domain.de/
```

## Umgebungsvariablen

```bash
# Development
flutter build web --dart-define=ENVIRONMENT=development

# Staging
flutter build web --dart-define=ENVIRONMENT=staging

# Production
flutter build web --dart-define=ENVIRONMENT=production --release
```

## Monitoring & Analytics

### Google Analytics Integration

TODO: Implementierung in `lib/core/services/analytics_service.dart`

### Error Tracking

TODO: Sentry Integration für Error Tracking

## SEO Optimierung

Die `web/index.html` ist bereits optimiert mit:
- ✅ Meta Description
- ✅ Meta Keywords
- ✅ Open Graph Tags (TODO)
- ✅ Twitter Cards (TODO)
- ✅ Schema.org Markup (TODO)

## Checkliste für Production Deployment

- [ ] `flutter build web --release` erfolgreich
- [ ] Alle URLs funktionieren (Deep Links testen)
- [ ] SSL/HTTPS konfiguriert
- [ ] Caching-Headers gesetzt
- [ ] Gzip Compression aktiviert
- [ ] Error Tracking konfiguriert
- [ ] Analytics implementiert
- [ ] Backup-Strategie vorhanden
- [ ] Monitoring aufgesetzt
- [ ] Performance getestet (Lighthouse Score)
- [ ] Mobile Responsiveness geprüft
- [ ] Cross-Browser Kompatibilität getestet

## Troubleshooting

### Problem: URLs funktionieren nicht (404)

**Lösung:** Server muss alle Requests zu `/index.html` umleiten (SPA Routing)

### Problem: Assets werden nicht geladen

**Lösung:** `--base-href` Parameter beim Build setzen

### Problem: App lädt langsam

**Lösung:**
- Verwende HTML Renderer statt CanvasKit
- Aktiviere Gzip Compression
- Nutze CDN für Assets

### Problem: PWA funktioniert nicht

**Lösung:**
- HTTPS erforderlich
- Service Worker überprüfen
- manifest.json validieren

## Support & Kontakt

Bei Fragen zum Deployment:
- Dokumentation: [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- Team: [Kontaktinformationen]
