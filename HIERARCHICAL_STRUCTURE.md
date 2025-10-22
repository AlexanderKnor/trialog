# Hierarchische Strukturvertrieb - Dokumentation

## ✅ Expandable Tree System implementiert!

Die Trialog-App unterstützt jetzt eine **vollständig expandierbare, hierarchische Struktur** für Strukturvertrieb mit unbegrenzter Tiefe.

## 🌳 Konzept: Rekursive Baum-Struktur

### Visuelle Hierarchie:

```
Marcel Liebetrau ━━━━ Trialog [-] ━━━━ Daniel Lippert
                          |
          ────────────────┼────────────────
          |               |               |
    Team Leader A [+]  Manager B [-]  Mitarbeiter C
                          |
                      ────┴────
                      |       |
                  MA B1 [+] MA B2
                      |
                   ───┴───
                   |     |
                 MA1   MA2
```

**Legende:**
- **[+]** = Hat Team, eingeklappt
- **[-]** = Hat Team, ausgeklappt
- **Keine Buttons** = Keine Mitarbeiter
- **Zahl-Badge** = Anzahl direkter Mitarbeiter

## 🎨 UI/UX Features

### 1. **Expansion/Collapse**
- **Click auf [+]** → Zeigt Team darunter
- **Click auf [-]** → Versteckt Team
- **Smooth Animation** beim Ein-/Ausklappen
- **State wird beibehalten** (auch nach Refresh)

### 2. **Hover-Interaktion**
- **Hover über Karte** → Zeigt Action-Buttons
- **"Mitarbeiter hinzufügen"** Button (grün)
- **"Löschen"** Button (rot) - außer für CEOs/Company

### 3. **Visuelle Hierarchie**
- **Verbindungslinien** zeigen Parent-Child-Beziehung
- **Badge** zeigt Anzahl direkter Mitarbeiter
- **Indentation** durch Verbindungslinien
- **Unbegrenzte Tiefe** möglich

### 4. **Smart Actions**
- **Mitarbeiter hinzufügen unter jedem Node**
- **Auto-Expand** wenn neuer Mitarbeiter hinzugefügt
- **Warnung beim Löschen** (inkl. aller Unter-Mitarbeiter)
- **Click auf Karte** → Detail-Ansicht

## 🏗️ Technische Architektur

### 1. **Recursive Widget: `ExpandableOrgNode`**

```dart
ExpandableOrgNode
  ├── OrganizationNodeCard (die Karte selbst)
  ├── Expansion Button [+]/[-]
  ├── Children Count Badge
  ├── Action Buttons (on hover)
  └── Children (wenn expanded)
      └── Für jedes Child: ExpandableOrgNode (rekursiv!)
```

### 2. **State Management**

```dart
OrganizationChartState {
  OrganizationNode rootNode;
  Set<String> expandedNodeIds;  // Welche Nodes sind ausgeklappt

  bool isNodeExpanded(String id);
  toggleNodeExpansion(String id);
}
```

### 3. **Connection Lines**

- **1 Kind:** Direkte vertikale Linie
- **Mehrere Kinder:** Horizontale Verbindung + vertikale Linien
- **Rekursiv:** Jede Ebene rendert ihre eigenen Linien

## 🎯 Anwendungsfälle

### Strukturvertrieb-Szenarien:

**Szenario 1: Team Leader mit Team**
```
Team Leader A [+]
├── Vertriebsmitarbeiter 1
├── Vertriebsmitarbeiter 2
└── Vertriebsmitarbeiter 3
```

**Szenario 2: Multi-Level Marketing**
```
Team Leader A [-]
├── Senior Partner 1 [+]
│   ├── Partner 1.1
│   └── Partner 1.2 [-]
│       ├── Agent 1.2.1
│       └── Agent 1.2.2
└── Senior Partner 2
```

**Szenario 3: Abteilungsstruktur**
```
Vertriebsleitung [-]
├── Region Nord [+]
│   ├── Team Hamburg
│   └── Team Berlin
└── Region Süd [+]
    ├── Team München
    └── Team Stuttgart
```

## 📊 Interaktions-Flow

### Mitarbeiter hinzufügen:

1. **Hover** über gewünschte Karte (z.B. "Team Leader A")
2. **Click** auf grünen "+" Button
3. **Formular** öffnet sich
4. **Daten eingeben** (Name, Versicherung %, Immobilien %)
5. **Hinzufügen** → Mitarbeiter erscheint unter "Team Leader A"
6. **Auto-Expand** → Team wird automatisch ausgeklappt

### Navigation in der Hierarchie:

1. **Expand** → Click auf [+] Button
2. **Collapse** → Click auf [-] Button
3. **Details** → Click auf Karte
4. **Löschen** → Hover + Click auf roten Button

## 🔧 Technische Details

### Expansion State:

```dart
// Initial: Nur Root expanded
expandedNodeIds: {'company-root'}

// Nach User-Interaktion:
expandedNodeIds: {'company-root', 'emp-123', 'emp-456'}
```

### Rekursive Rendering:

```dart
Widget _buildChildren(List<OrganizationNode> children) {
  return Row(
    children: children.map((child) {
      return ExpandableOrgNode(node: child); // Rekursiv!
    }).toList(),
  );
}
```

### Performance:

- ✅ **Lazy Rendering**: Collapsed Nodes werden nicht gerendert
- ✅ **Effizient**: Nur expanded Bereiche im Widget-Tree
- ✅ **Schnell**: Keine unnötigen Rebuilds

## 🎨 Styling-Details

### Karten-Badges:

```dart
// Children Count Badge (oben links)
┌─[3]──────────┐
│  Team Leader │
│     [+]      │  ← Expansion Button (unten)
└──────────────┘
```

### Action-Buttons (on hover):

```dart
┌────────────[+][x]  ← Hover-Buttons (oben rechts)
│  Mitarbeiter   │
│    V: 40%      │
│    I: 60%      │
└────────────────┘
```

### Hierarchie-Farben (optional):

```dart
Level 0 (Trialog):  #10274C (dunkel)
Level 1 (CEOs):     #10274C
Level 2:            #1A3B6B (etwas heller)
Level 3:            #2E4E8A (noch heller)
Level 4+:           Gradient fortsetzend
```

## 📋 Neue Funktionen

### Für jeden Mitarbeiter:

1. **[+]/[-] Button** - Team ein-/ausklappen
2. **Badge mit Zahl** - Anzahl direkter Mitarbeiter
3. **Hover-Actions:**
   - ✅ Mitarbeiter hinzufügen (grün)
   - ✅ Löschen (rot) - mit Warnung
4. **Click auf Karte** - Details anzeigen

### Smart Behaviors:

- ✅ **Auto-Expand** beim Hinzufügen neuer Mitarbeiter
- ✅ **Warnung beim Löschen** - zeigt Anzahl betroffener Unter-Mitarbeiter
- ✅ **State-Persistence** - Expansion bleibt erhalten
- ✅ **Smooth Animations** - beim Expand/Collapse

## 🚀 Beispiel-Nutzung

### Team aufbauen:

```
1. Hover über "Trialog" → Click "+"
   → "Team Leader A" hinzufügen

2. Hover über "Team Leader A" → Click "+"
   → "Vertriebsmitarbeiter 1" hinzufügen

3. Team Leader A zeigt jetzt [+] Button
   → Click [+] zum Ausklappen
   → Zeigt Vertriebsmitarbeiter 1

4. Hover über "Vertriebsmitarbeiter 1" → Click "+"
   → Weiteren Mitarbeiter darunter hinzufügen

5. Beliebig tief verschachtelbar!
```

### Struktur kollabieren:

```
Team Leader A [-]  ← Click auf [-]
├── (12 Mitarbeiter versteckt)
```

## 🎯 Vorteile

### Für Benutzer:
- ✅ **Übersichtlich** - Nur relevante Ebenen sichtbar
- ✅ **Skalierbar** - Funktioniert mit 10 oder 1000 Mitarbeitern
- ✅ **Intuitiv** - Bekannte Expand/Collapse Pattern
- ✅ **Schnell** - Direkter Zugriff auf alle Ebenen

### Für Strukturvertrieb:
- ✅ **Unbegrenzte Downline-Tiefe**
- ✅ **Klare Hierarchie-Darstellung**
- ✅ **Einfaches Team-Management**
- ✅ **Schneller Überblick** über Team-Größen

### Technisch:
- ✅ **DDD-konform** - Clean Architecture
- ✅ **Performance** - Lazy Rendering
- ✅ **Wartbar** - Rekursive Komponente
- ✅ **Erweiterbar** - Einfach neue Features hinzufügen

## 🔄 Datenfluss

```
User Action (Click [+])
  ↓
Notifier.toggleNodeExpansion(nodeId)
  ↓
State updated (expandedNodeIds)
  ↓
Widget rebuild
  ↓
ExpandableOrgNode prüft isExpanded
  ↓
Rendert Children wenn expanded
  ↓
Jedes Child rendert sich rekursiv
```

## 📚 Nächste Erweiterungen (optional)

### Phase 1 (Aktuell): ✅ Implementiert
- Expandable Tree
- Hover Actions
- Unbegrenzte Hierarchie

### Phase 2 (Zukünftig):
- Drag & Drop zum Umstrukturieren
- Visuelle Statistiken (Team-Größe, Umsatz)
- Filter & Suche in der Hierarchie
- Export als PDF/Image

### Phase 3 (Advanced):
- Real-time Updates (Firestore Snapshots)
- Multi-User Collaboration
- Konflikte-Erkennung
- Änderungshistorie

---

**Status:** ✅ Vollständig implementiert

Das Expandable Tree System ist einsatzbereit und bietet eine elegante, skalierbare Lösung für Strukturvertrieb mit unbegrenzter Hierarchie-Tiefe!
