{ vars, ... }:

{
  services.openssh.settings = {
    # only allow the main user
    AllowUsers = [ vars.user.name ];

    # disable root login
    PermitRootLogin = "no";
  };
}
