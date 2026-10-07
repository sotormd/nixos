let
  mkWrapperScript =
    {
      name,
      command,
      runtimeShell,
      writeTextFile,
    }:
    writeTextFile {
      name = "${name}-wrapper-script";
      text = ''
        #!${runtimeShell}

        ${command}
      '';
      destination = "/bin/${name}";
      executable = true;
      meta.mainProgram = name;
    };

  mkWrapperPackage =
    {
      lib,
      callPackage,
      symlinkJoin,
      makeWrapper,

      name,
      base,
      type,

      binaryPath ? "$out/bin/${name}",
      keepNoConfig ? true,
      command ? "",
      args ? "",
    }:
    let
      defaultError = "${type} must be passed when mkWrapperPackage is called with type ${type}";
    in
    if
      !(builtins.elem type [
        "command"
        "wrapper"
      ])
    then
      throw "unexpected type ${type} passed to mkWrapperPackage"
    else if type == "command" && command == "" then
      throw defaultError
    else if type == "wrapper" && args == "" then
      throw defaultError
    else
      symlinkJoin {

        name = "${name}-wrapped";

        paths = [ base ];

        buildInputs = lib.optional (type == "wrapper") makeWrapper;

        postBuild = lib.concatStringsSep "\n" [

          (lib.optionalString keepNoConfig ''
            cp ${binaryPath} ${binaryPath}-noconfig
          '')

          (lib.optionalString (type == "command") (
            let
              script = callPackage mkWrapperScript { inherit name command; };
            in
            ''
              rm -f ${binaryPath}
              ln -s ${lib.getExe script} $out/bin/${name}
            ''
          ))

          (lib.optionalString (type == "wrapper") ''
            wrapProgram ${binaryPath} ${args}
          '')

        ];

        meta.mainProgram = name;

      };
in
{
  inherit mkWrapperPackage;
}
