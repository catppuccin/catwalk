{
  pkgs ? import <nixpkgs> {
    inherit system;
    config = { };
    overlays = [ ];
  },
  system ? builtins.currentSystem,
}:
{
  catwalk = pkgs.callPackage ./nix/package.nix { };
}
