{
  lib,
  buildGoModule,
  fetchFromGitHub,
  updater-nix-update,
}:

buildGoModule (finalAttrs: {
  pname = "xkcd-wall";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "sotormd";
    repo = "xkcd-wall";
    tag = finalAttrs.version;
    hash = "sha256-PSsn2Bm02N8Z/MnGEsNMuvFZha2by485A+S4Q6XUAB0=";
  };
  subPackages = [ "./cmd/xkcd-wall" ];
  vendorHash = null;

  passthru.updateScript = updater-nix-update;

  meta = {
    description = "Create wallpapers from xkcd comics";
    homepage = "https://github.com/sotormd/xkcd-wall";
    license = lib.licenses.gpl3Only;
    mainProgram = "xkcd-wall";
  };
})
