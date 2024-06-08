{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forEachSystem =
        function:
        nixpkgs.lib.genAttrs systems (
          system:
          function {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs, system }:
        {
          default = import ./shell.nix {
            inherit pkgs system;
            inherit (self.packages.${system}) catwalk;
          };
        }
      );

      formatter = forEachSystem ({ pkgs, ... }: pkgs.nixfmt-rfc-style);

      packages = forEachSystem (
        { pkgs, system }:
        let
          pkgs' = import ./default.nix { inherit pkgs system; };
        in
        {
          inherit (pkgs') catwalk;
          default = self.packages.${system}.catwalk;
        }
      );

      overlays.default = final: prev: import ./overlay.nix final prev;
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
