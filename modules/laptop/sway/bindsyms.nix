{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    wayland.windowManager.sway.config = {
      # focus workspace
      keybindings."Mod4+1" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')1'';
      keybindings."Mod4+2" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')2'';
      keybindings."Mod4+3" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')3'';
      keybindings."Mod4+4" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')4'';
      keybindings."Mod4+5" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')5'';
      keybindings."Mod4+6" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')6'';
      keybindings."Mod4+7" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')7'';
      keybindings."Mod4+8" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')8'';
      keybindings."Mod4+9" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')9'';
      keybindings."Mod4+0" =
        ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')10'';

      # move to workspace
      keybindings."Mod4+shift+1" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')1'';
      keybindings."Mod4+shift+2" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')2'';
      keybindings."Mod4+shift+3" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')3'';
      keybindings."Mod4+shift+4" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')4'';
      keybindings."Mod4+shift+5" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')5'';
      keybindings."Mod4+shift+6" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')6'';
      keybindings."Mod4+shift+7" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')7'';
      keybindings."Mod4+shift+8" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')8'';
      keybindings."Mod4+shift+9" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')9'';
      keybindings."Mod4+shift+0" =
        ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')10'';
    };
  };
}
