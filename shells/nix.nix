{
  inputs,
  mkShell,
  ...
}: (
  system: let
    pkgs = import inputs.nixpkgs {inherit system;};
    packages = with pkgs;
      [
        alejandra
        deadnix
        niv
        nixd
        statix
        vulnix
      ]
      ++ (
        if pkgs.stdenv.hostPlatform.isDarwin
        then
          with pkgs; [
            darwin.apple_sdk.frameworks.Foundation
          ]
        else []
      );
    attr = {
      inherit packages;
      name = "nix";
      shellHook = ''
        if [ -f .env ] then
          echo direnv: loading local .env
          source .env
        fi
      '';
    };
  in
    mkShell pkgs attr
)
