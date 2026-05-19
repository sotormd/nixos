{ config, lib, ... }:

let
  inherit (config.vars.services) ssh;
in
lib.mkIf ssh.enable {

  services.openssh = {
    settings = {
      # only allow the main user
      AllowUsers = lib.mkForce [ config.vars.user.name ];

      # disable root login
      PermitRootLogin = "no";

      # disable password authentication
      PubkeyAuthentication = true;
      AuthenticationMethods = "publickey";
      PasswordAuthentication = false;
      PermitEmptyPasswords = false;

      # reduce brute-force window
      MaxSessions = 2;
      MaxAuthTries = 2;
      LoginGraceTime = 20;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 1;

      # disable unused features
      X11Forwarding = false;
      AllowStreamLocalForwarding = false;
      PermitTunnel = false;
      PermitUserEnvironment = false;
      KbdInteractiveAuthentication = false;
      AllowTCPForwarding = false;
      TCPKeepAlive = false;
      AllowAgentForwarding = false;

      # use only good algorithms
      KexAlgorithms = lib.mkForce [
        # Post-Quantum: https://www.openssh.org/pq.html
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512"
        "curve25519-sha256@libssh.org"
        "ecdh-sha2-nistp521"
        "ecdh-sha2-nistp384"
        "ecdh-sha2-nistp256"
        "diffie-hellman-group-exchange-sha256"
      ];
      Ciphers = lib.mkForce [
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        # stream cipher alternative to aes256, proven to be resilient
        # Very fast on basically anything
        "chacha20-poly1305@openssh.com"
        # industry standard, fast if you have AES-NI hardware
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];
      Macs = lib.mkForce [
        # Combines the SHA-512 hash func with a secret key to create a MAC
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-512"
        "hmac-sha2-256"
        "umac-128@openssh.com"
      ];

      # reduce identity leakage
      UseDns = false;
      PrintMotd = false;
      VersionAddendum = "none";

      # ensure filesystem permissions are safe
      StrictModes = true;

      # verbose logging
      LogLevel = "VERBOSE";
    };

    # host keys
    hostKeys = lib.mkForce [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

}
