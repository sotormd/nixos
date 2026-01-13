{ config, pkgs, ... }:

{
  style = pkgs.writeTextFile {
    name = "style";
    text = builtins.readFile (
      pkgs.replaceVars ./config/style.css {
        fontsNormal = "${config.colors.fonts.normal}";

        bg0 = "${config.colors.bg0}";

        waybarModeText = "${config.colors.waybar.mode.text}";

        waybarWorkspacesBorder = "${config.colors.waybar.workspaces.border}";
        waybarWorkspacesText = "${config.colors.waybar.workspaces.text}";
        waybarWorkspacesHover = "${config.colors.waybar.workspaces.hover}";

        waybarAnimationA = "${config.colors.waybar.animation.a}";
        waybarAnimationB = "${config.colors.waybar.animation.b}";
        waybarAnimationC = "${config.colors.waybar.animation.c}";
        waybarAnimationD = "${config.colors.waybar.animation.d}";
        waybarAnimationE = "${config.colors.waybar.animation.e}";
        waybarAnimationF = "${config.colors.waybar.animation.f}";
        waybarAnimationG = "${config.colors.waybar.animation.g}";
        waybarAnimationH = "${config.colors.waybar.animation.h}";

        waybarModulesText = "${config.colors.waybar.modules.text}";

        waybarUtilBg = "${config.colors.waybar.util.bg}";
        waybarNetworkBg = "${config.colors.waybar.network.bg}";
        waybarAudioBg = "${config.colors.waybar.audio.bg}";
        waybarBatteryBg = "${config.colors.waybar.battery.bg}";
        waybarClockBg = "${config.colors.waybar.clock.bg}";
      }
    );
    destination = "/style.css";
  };
}
