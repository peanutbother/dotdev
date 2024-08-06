{
  description = "A flake for building a Rust package.";

  inputs = {
    dotdev.url = "github:peanutbother/dotdev";
  };

  outputs = {dotdev, ...}: let
    eachSystem = dotdev.lib.common.eachSystemWithPkgs;
    mkBuildInputs = pkgs:
      with pkgs;
        dotdev.devShells.${system}.rust.packages
        ++ [
          # put your required libs here
        ]
        ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          # required libs specific to darwin
        ];
  in {
    inherit (dotdev) formatter;

    packages = eachSystem (system: pkgs:
      with dotdev.lib.${system}.rust; let
        buildInputs = mkBuildInputs pkgs;
        src = cleanCargoSource ./.;
        defaultBuildArgs = {
          inherit buildInputs src;
          doCheck = false;
        };
        cargoArtifacts = buildDepsOnly defaultBuildArgs;
      in rec {
        default = buildPackage (defaultBuildArgs
          // {
            inherit cargoArtifacts;
            # cargoExtraArgs = "--no-default-features";
          });
      });

    checks =
      dotdev.checks
      // eachSystem (system: pkgs:
        with dotdev.lib.${system}.rust; let
          buildInputs = mkBuildInputs pkgs;
          src = cleanCargoSource ./.;
          defaultBuildArgs = {
            inherit buildInputs src;
            doCheck = false;
          };
          cargoArtifacts = buildDepsOnly defaultBuildArgs;
        in {
          clippy = cargoClippy (defaultBuildArgs
            // {
              inherit cargoArtifacts;
              cargoClippyExtraArgs = "--all-targets -- --deny warnings";
            });
          docs = cargoDoc (defaultBuildArgs
            // {
              inherit cargoArtifacts;
            });
          fmt = cargoFmt {
            inherit (defaultBuildArgs) src;
          };
          deny = cargoDeny {
            inherit (defaultBuildArgs) src;
          };
          nextest = cargoNextest (defaultBuildArgs
            // {
              inherit cargoArtifacts;
              partitions = 1;
              partitionType = "count";
            });
        });

    devShells = eachSystem (system: pkgs: {
      default = dotdev.devShells.${system}.rust.override (_prev: {
        packages = mkBuildInputs pkgs;
      });
    });
  };
}
