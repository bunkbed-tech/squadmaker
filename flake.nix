# Boilerplate nix flake for installing software in a new shell
{
  description = "Install all software dependencies for flutter tutorial.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "flake-utils";
    flake-utils.url = "github:numtide/flake-utils";
    fenix-flake.url = "github:nix-community/fenix";
    fenix-flake.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, devshell, flake-utils, fenix-flake }: flake-utils.lib.eachDefaultSystem (system:
    let
      project = "squadmaker";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ devshell.overlay fenix-flake.overlays.default ];
      };
      mkApp = command: script: {
        type = "app";
        program = toString (pkgs.writers.writeBash command script);
      };
    in
    {
      apps.default = mkApp "test" ''
        export PGDATA="$(pwd)/data/postgresql"
        PGLOGS="$(pwd)/logs/postgresql"
        mkdir -p "$PGDATA"
        mkdir -p "$PGLOGS"
        [[ -d "$PGDATA" && ! $(ls -A "$PGDATA") ]] && initdb -D "$PGDATA"
        pg_ctl -l "$PGLOGS/$(date +"%Y%m%d")" start
        createuser -P test_user
        createdb -O test_user testing_db
        psql -f sql/schema.sql testing_db
        cargo run
        pg_ctl stop
        rm -rf "$PGDATA"
      '';
      packages.default = fenix-flake.packages.default.toolchain;
      devShell = pkgs.devshell.mkShell {
        name = "${project}-shell";
        packages = with pkgs; [
          #flutter # https://github.com/NixOS/nixpkgs/pull/210067
          nixpkgs-fmt
          (fenix.complete.withComponents [
            "cargo"
            "clippy"
            "rust-src"
            "rustc"
            "rustfmt"
          ])
          rust-analyzer-nightly
          postgresql
        ];
      };
    }
  );
}
