# Mindset Sound Trigger

Dieses Projekt ermöglicht es, über Tastendruck (F9 oder Fn+F9) einen Sound auf voller Lautstärke abzuspielen.

## Voraussetzungen

* Linux (getestet auf Linux Mint mit X11)
* Rust (Installationsanleitung: [https://www.rust-lang.org/tools/install](https://www.rust-lang.org/tools/install))
* `xbindkeys`
* PulseAudio (Standard unter Linux Mint)
* `paplay` und `pactl` (Teil von PulseAudio)

## Installation

1. **Systempakete installieren**

   ```bash
   sudo apt update
   sudo apt install xbindkeys pulseaudio-utils
   ```

2. **Projekt klonen und kompilieren**

   ```bash
   # In dein Wunschverzeichnis wechseln
   git clone <dein-repo-url> mindset-sound-trigger
   cd mindset-sound-trigger

   # Rust-Programm kompilieren
   cargo build --release
   ```

3. **Binary installieren**

   ```bash
   # Kompilierte Binary ins Home-Verzeichnis kopieren
   cp target/release/mindset ~/mindset
   chmod +x ~/mindset
   ```

4. **Sound-Datei platzieren**

   Lege deine WAV-Datei als `sound.wav` in deinem Home-Verzeichnis ab:

   ```bash
   mv <dein-pfad>/Mentality\ Sound\ Effect.wav ~/sound.wav
   ```

## Konfiguration von xbindkeys

1. **Default-Konfiguration erzeugen (falls noch nicht vorhanden)**

   ```bash
   xbindkeys --defaults > ~/.xbindkeysrc
   ```

2. **`~/.xbindkeysrc` bearbeiten**
   Öffne die Datei in einem Editor deiner Wahl und füge ans Ende folgendes hinzu:

   ```text
   # Sound mit F9 oder Fn+F9 abspielen
   "/home/leon/mindset"
       m:0x0 + c:75
       m:0x40 + c:31
   ```

   * `m:0x0 + c:75` → Standard F9
   * `m:0x40 + c:31` → Fn+F9 (Mod4+i)

3. **xbindkeys neu starten**

   ```bash
   killall xbindkeys
   xbindkeys
   ```

## Nutzung

Drücke **F9** oder **Fn+F9**, um den Sound auf voller Lautstärke abzuspielen.

## Fehlerbehebung

* **Kein Sound**: Prüfe, ob PulseAudio läuft: `pulseaudio --check` und starte ggf. mit `pulseaudio --start`.
* **xbindkeys reagiert nicht**:

  * Stelle sicher, dass du in einer X11-Session bist (kein Wayland).
  * Starte xbindkeys im Verbose-Modus, um Events zu sehen: `xbindkeys -v`.

---

