{
  users.users.admin = {
    isNormalUser = true;
    home = "/tmp/admin";
    extraGroups = [ "wheel" ];
    password = "admin";
  };
}
