{
  writeShellApplication,
  runCommand,
  python3,
  scowl,
}:
let
  wordleWords = runCommand "wordles" { buildInputs = [ python3 ]; } ''
    python <<EOF
    import re
    import unicodedata

    of = open("$out", "w")
    for line in open("${scowl}/share/dict/words.txt", encoding="iso8859-1"):
        word = (
            unicodedata.normalize("NFKD", line)
            .strip()
            .encode("ascii", errors="ignore")
            .decode("ascii")
        )
        if re.fullmatch("[a-z]{5}", word):
            print(word, file=of)
    EOF
  '';
in
writeShellApplication {
  name = "wordle";
  text = ''
    cat ${wordleWords}
  '';
}
