{
  pkgs ? import <nixpkgs> {
    inherit system;
    config = { };
    overlays = [ ];
  },
  system ? builtins.currentSystem,
}:
let
  # re-use our overlay definition
  pkgs' = import ./overlay.nix pkgs null;
in
{
	catwalk = pkgs'.catppuccin-catwalk;
}
