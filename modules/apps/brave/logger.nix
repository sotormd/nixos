{
  lib,
  coreutils,
  jail,
}:

''
  BASE="$XDG_RUNTIME_DIR/bubblewrap-brave-out"
  STDERR="$BASE/stderr"
  STDOUT="$BASE/stdout"

  ${lib.getExe' coreutils "mkdir"} -p "$BASE"

  ${jail} "$@" 2>"$STDERR" 1>"$STDOUT"
''
