use std::process::Command;

fn main() {
    // Set volume to 100%
    Command::new("pactl")
        .args(["set-sink-volume", "@DEFAULT_SINK@", "100%"])
        .status()
        .expect("Fehler beim Setzen der Lautstärke");

    // Play sound
    Command::new("paplay")
        .arg("/home/leon/sound.wav")
        .status()
        .expect("Fehler beim Abspielen des Sounds");
}
