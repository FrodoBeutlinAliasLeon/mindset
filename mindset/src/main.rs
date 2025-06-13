use std::process::Command;

fn main() {
    // Lautstärke auf 100 % setzen
    Command::new("pactl")
        .args(["set-sink-volume", "@DEFAULT_SINK@", "100%"])
        .status()
        .expect("Fehler beim Setzen der Lautstärke");

    // Sound abspielen (absolute Pfadangabe)
    Command::new("paplay")
        .arg("/home/leon/sound.wav")
        .status()
        .expect("Fehler beim Abspielen des Sounds");
}

