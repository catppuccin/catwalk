{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      ...
    }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      inherit (nixpkgs) lib;
      forEachSystem =
        f:
        (lib.listToAttrs (
          map (system: {
            name = system;
            value = f {
              inherit system;
              pkgs = import nixpkgs {
                inherit system;
                overlays = [ rust-overlay.overlays.default ];
              };
            };
          }) systems
        ));
    in
    {
      devShells = forEachSystem (
        { pkgs, system }:
        let
          rust-toolchain = (
            pkgs.rust-bin.stable.latest.default.override {
              extensions = [
                "rustfmt"
                "rust-analyzer"
                "clippy"
                "rust-src"
              ];
              targets = [ "wasm32-unknown-unknown" ];
            }
          );
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.default ];
            packages = [ rust-toolchain ];
            env.RUST_SRC_PATH = "${rust-toolchain}/lib/rustlib/src/rust/library";
          };
        }
      );

      packages = forEachSystem (
        { pkgs, system }:
        {
          default = self.packages.${system}.catwalk;
          catwalk = pkgs.callPackage ./default.nix {
            rustPlatform =
              let
                toolchain = pkgs.rust-bin.stable.latest.default;
              in
              pkgs.makeRustPlatform {
                cargo = toolchain;
                rustc = toolchain;
              };
          };
        }
      );

      overlays.default = final: _: { catppuccin-catwalk = final.callPackage ./default.nix { }; };
    };

  nixConfig = {
    extra-substituters = [
      "https://catppuccin.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
