{ pkgs, ... }:

{
  environment.etc."login.defs".text = pkgs.lib.mkForce ''
    PASS_MAX_DAYS 60
    PASS_MIN_DAYS 1
    PASS_MIN_LEN 20
    ENCRYPT_METHOD SHA512
    SHA_CRYPT_MIN_ROUNDS 100000
    SHA_CRYPT_MAX_ROUNDS 100000
    UMASK 027
    UID_MIN 1000
    GID_MIN 1000
  '';

  security.pam.services.passwd.text = (
    pkgs.lib.mkBefore "password requisite ${pkgs.libpwquality.lib}/lib/security/pam_pwquality.so"
  );
  security.pam.services.chpasswd.text = (
    pkgs.lib.mkBefore "password requisite ${pkgs.libpwquality.lib}/lib/security/pam_pwquality.so"
  );

  environment.etc."/security/pwquality.conf".text = ''
    dictcheck=1
    ocredit=-1
    minlen=20
  '';
}
