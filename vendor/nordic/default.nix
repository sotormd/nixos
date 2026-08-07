{ lib, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "nordic-darker";
  version = "2.2.0-vendored";

  src = ./Nordic-darker.tar.xz;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/Nordic-darker
    cp -a . $out/share/themes/Nordic-darker

    # remove development/source files
    rm -rf $out/share/themes/Nordic-darker/{.gitignore,Art,FUNDING.yml,LICENSE,README.md}
    rm -rf $out/share/themes/Nordic-darker/{package.json,package-lock.json,Gulpfile.js}
    rm -rf $out/share/themes/Nordic-darker/src

    # remove unused sass/source assets
    rm -rf $out/share/themes/Nordic-darker/cinnamon/*.scss
    rm -rf $out/share/themes/Nordic-darker/gnome-shell/{earlier-versions,extensions,*.scss}
    rm -rf $out/share/themes/Nordic-darker/gtk-2.0/{assets.svg,assets.txt,links.fish,render-assets.sh}
    rm -rf $out/share/themes/Nordic-darker/gtk-3.0/{apps,widgets,*.scss}
    rm -rf $out/share/themes/Nordic-darker/gtk-4.0/{apps,widgets,*.scss}
    rm -rf $out/share/themes/Nordic-darker/xfwm4/{assets,render_assets.fish}

    runHook postInstall
  '';

  meta = {
    description = "Nordic darker GTK theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
