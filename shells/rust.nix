{
  inputs,
  mkShell,
  ...
}: (
  system: let
    pkgs = import inputs.nixpkgs {inherit system;};
    packages = with pkgs;
      [
        rustPlatform.bindgenHook # fix llvm / cxx for rust
      ]
      ++ (
        if pkgs.stdenv.hostPlatform.isDarwin
        then
          with pkgs; [
            darwin.apple_sdk.frameworks.Foundation
            libiconv
          ]
        else []
      );
    attr = {
      packages = with pkgs; packages ++ [rustup];
      _packages = packages; # shell packages without tools
      name = "rust";
      shellHook = ''
        if [ -f .env ] then
          echo direnv: loading local .env
          source .env
        fi

        rustc --version
      '';
    };
  in
    mkShell pkgs attr
)
