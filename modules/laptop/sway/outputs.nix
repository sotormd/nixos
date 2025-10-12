{ vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    wayland.windowManager.sway.config = {
      # output config
      output = {
        "${vars.outputs.laptop}" = {
          mode = "1920x1200@60Hz";
          position = "0 0";
        };
        "${vars.outputs.monitor}" = {
          mode = "1920x1080@75Hz";
          position = "1920 0";
        };
        "*" = {
          bg = "~/.local/share/backgrounds/wall.png fill";
        };
      };

      # assing workspaces to outputs
      workspaceOutputAssign = [
        {
          output = vars.outputs.laptop;
          workspace = "01";
        }
        {
          output = vars.outputs.laptop;
          workspace = "02";
        }
        {
          output = vars.outputs.laptop;
          workspace = "03";
        }
        {
          output = vars.outputs.laptop;
          workspace = "04";
        }
        {
          output = vars.outputs.laptop;
          workspace = "05";
        }
        {
          output = vars.outputs.laptop;
          workspace = "06";
        }
        {
          output = vars.outputs.laptop;
          workspace = "07";
        }
        {
          output = vars.outputs.laptop;
          workspace = "08";
        }
        {
          output = vars.outputs.laptop;
          workspace = "09";
        }
        {
          output = vars.outputs.laptop;
          workspace = "010";
        }
        {
          output = vars.outputs.monitor;
          workspace = "11";
        }
        {
          output = vars.outputs.monitor;
          workspace = "12";
        }
        {
          output = vars.outputs.monitor;
          workspace = "13";
        }
        {
          output = vars.outputs.monitor;
          workspace = "14";
        }
        {
          output = vars.outputs.monitor;
          workspace = "15";
        }
        {
          output = vars.outputs.monitor;
          workspace = "16";
        }
        {
          output = vars.outputs.monitor;
          workspace = "17";
        }
        {
          output = vars.outputs.monitor;
          workspace = "18";
        }
        {
          output = vars.outputs.monitor;
          workspace = "19";
        }
        {
          output = vars.outputs.monitor;
          workspace = "110";
        }
      ];
    };
  };
}
