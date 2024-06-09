final: _: {
  catppuccin-catwalk = final.callPackage (
    {
      lib,
      rustPlatform,
      installShellFiles,
    }:
    rustPlatform.buildRustPackage {
      pname = "catppuccin-catwalk";
      inherit ((lib.importTOML ./Cargo.toml).package) version;

      src = lib.fileset.toSource {
        root = ./.;
        fileset = lib.fileset.intersection (lib.fileset.fromSource (lib.sources.cleanSource ./.)) (
          lib.fileset.unions [
            ./Cargo.toml
            ./Cargo.lock
            ./src
            ./LICENSE
          ]
        );
      };

      cargoLock.lockFile = ./Cargo.lock;

      nativeBuildInputs = [ installShellFiles ];

      postInstall = ''
        installShellCompletion --cmd catwalk \
          --bash <("$out/bin/catwalk" completion bash) \
          --zsh <("$out/bin/catwalk" completion zsh) \
          --fish <("$out/bin/catwalk" completion fish)
      '';

      meta = {
        homepage = "https://github.com/catppuccin/catwalk";
        description = "🚶 Soothing pastel previews for the high-spirited!";
        license = lib.licenses.mit;
        mainProgram = "catwalk";
      };
    }
  ) { };
}
