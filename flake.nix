# Boilerplate nix flake for installing software in a new shell
{
    description = "Install all software dependencies for flutter tutorial.";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs";
        devshell.url = "github:numtide/devshell";
        flake-utils.url = "github:numtide/flake-utils";
    };
    outputs = { self, nixpkgs, devshell, flake-utils }: flake-utils.lib.eachDefaultSystem (system: 
        let 
            pkgs = import nixpkgs { inherit system; overlays = [ devshell.overlay ]; };
        in {
            devShell = pkgs.devshell.mkShell {
                name = "flutter-tutorial-shell";
                packages = with pkgs; [ 
                    #flutter # https://github.com/NixOS/nixpkgs/pull/210067
                    nixpkgs-fmt 
                ];
            };
        }
    );
}