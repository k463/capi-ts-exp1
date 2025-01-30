{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
    # default = Darwin+Linux+x86+ARM, or default-linux, default-darwin, etc.
    # see https://github.com/nix-systems/
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = (import systems);
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells.default = pkgs.mkShell {
          # packages needed for building the software in this repo
          nativeBuildInputs = with pkgs; [
            clusterctl
            nodejs_18
            yarn
            yq-go
          ];
          # packages needed at runtime for running software in this repo
          packages = with pkgs; [];
        };
      };
    };
}
