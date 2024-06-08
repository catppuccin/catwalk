{
  pkgs ? import <nixpkgs> {
    inherit system;
    config = { };
    overlays = [ ];
  },
  system ? builtins.currentSystem,
  catwalk ? import ./default.nix { inherit pkgs; },
}:
pkgs.mkShell {
  inputsFrom = [ catwalk ];

  packages = [
    pkgs.clippy
    pkgs.rustfmt
    pkgs.rust-analyzer
  ];

  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  # NOTE: this is the secret sauce for wasm32 support
  CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "lld";
}
