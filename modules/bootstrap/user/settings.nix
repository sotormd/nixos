{ lib, ... }:

{
  users.users.nixos = {
    isNormalUser = true;

    # password: nixos
    initialHashedPassword = lib.mkForce "$y$j9T$EcXwZmlJcTbO2yjHu4xOy.$.M/ehO.13pAGk1rzJD4XAwpYzCay8una0iKIgZW7vc8";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
    run0.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  programs.gnupg.agent.enable = true;

  time.timeZone = "UTC";
}
