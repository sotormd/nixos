{ vars, ... }:

{
  # disable password authentication
  services.openssh.settings.PasswordAuthentication = false;

  # authorized keys
  users.users."${vars.user.name}".openssh.authorizedKeys.keys = vars.network.ssh.keys;
}
