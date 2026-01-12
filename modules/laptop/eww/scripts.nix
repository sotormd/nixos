{ pkgs, ... }:

let
  musicSh = pkgs.writeTextFile {
    name = "music.sh";
    text = builtins.readFile (
      pkgs.replaceVars ./scripts/music.sh {
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        bc = "${pkgs.bc}/bin/bc";
      }
    );
    destination = "/music.sh";
    executable = true;
  };

  calSh = pkgs.writeTextFile {
    name = "cal.sh";
    text = builtins.readFile (
      pkgs.replaceVars ./scripts/cal.sh {
        calPy = "${calPy}/cal.py";
      }
    );
    destination = "/cal.sh";
    executable = true;
  };

  doCalendarAction = pkgs.writeTextFile {
    name = "do-calendar-action";
    text = builtins.readFile (
      pkgs.replaceVars ./scripts/do-calendar-action.sh {
        calPy = "${calPy}/cal.py";
      }
    );
    destination = "/do-calendar-action";
    executable = true;
  };

  calPy = pkgs.writeTextFile {
    name = "cal.py";
    text = builtins.readFile ./scripts/cal.py;
    destination = "/cal.py";
    executable = true;
  };

  dockClientsJSON = pkgs.writeTextFile {
    name = "dock-clients.json";
    text = builtins.readFile ./scripts/dock-clients.json;
    destination = "/dock-clients.json";
  };

  lyricsPy = pkgs.writeTextFile {
    name = "lyrics.py";
    text = builtins.readFile (
      pkgs.replaceVars ./scripts/lyrics.py {
        python3 = "${pkgs.python3.withPackages (ps: with ps; [ syncedlyrics ])}/bin/python3";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
      }
    );
    destination = "/lyrics.py";
    executable = true;
  };

  dockPy = pkgs.writeTextFile {
    name = "dock.py";
    text = builtins.readFile (
      pkgs.replaceVars ./scripts/dock.py {
        python3 = "${pkgs.python3.withPackages (ps: with ps; [ i3ipc ])}/bin/python3";
        swaymsg = "${pkgs.swayfx}/bin/swaymsg";
        dockClientsJSON = "${dockClientsJSON}/dock-clients.json";
      }
    );
    destination = "/dock.py";
    executable = true;
  };
in
{
  scriptsDir = pkgs.symlinkJoin {
    name = "eww-scripts";
    paths = [
      musicSh
      calSh
      doCalendarAction
      calPy
      dockClientsJSON
      lyricsPy
      dockPy
    ];
  };
}
