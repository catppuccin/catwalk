{
  pkgs ? import <nixpkgs> { },
}:
let
  mainPkg = pkgs.callPackage ./default.nix { };
in
mainPkg.overrideAttrs (oa: {
  postInstall = ''
    pkgs.installShellCompletion --cmd catwalk \
      --bash <($out/bin/catwalk completion bash) \
      --fish <($out/bin/catwalk completion fish) \
      --zsh <($out/bin/catwalk completion zsh)
  '';
  buildInputs = with pkgs; [ libwebp ];
  nativeBuildInputs = [
    pkgs.installShellFiles
    pkgs.pkg-config
    "rust-toolchain"
    "rust-analyzer"
    "deno"
    # wasm + publishing to npm
    "binaryen"
    "nodejs"
    "wasm-bindgen-cli"
    "wasm-pack"
    # wasm-bindgen can require lcurl to build
    "curl"
  ] ++ (oa.nativeBuildInputs or [ ]);
})
