{ writeShellApplication, scowl }: writeShellApplication {
  name = "wordle";
  text = ''
    grep -E '^[a-z]{5}$' ${scowl}/share/dict/words.txt
  '';
}
