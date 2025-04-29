{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" =
    { firefox-addons, ... }:
    {
      programs.firefox.profiles."${vars.user.name}".extensions.packages =
        with firefox-addons.packages."x86_64-linux"; [
          bitwarden
          darkreader
          enhanced-h264ify
          ublock-origin
        ];
    };
}
