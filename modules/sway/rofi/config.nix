{ writeText, style }:

let
  configuration = writeText "rofi-config" ''
    configuration {
      location: 0;
      xoffset: 0;
      yoffset: 0;
    }
    @theme "${style}"
  '';
in
configuration
