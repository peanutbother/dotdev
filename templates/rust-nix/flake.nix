{
  description = "A flake for building a Rust package.";

  inputs = {
    dotdev.url = "github:peanutbother/dotdev";
  };

  outputs = {dotdev, ...}: {
    packages = dotdev.lib.common.eachSystemWithPkgs (
      # deadnix: skip
      system: pkgs: let
        inherit (dotfiles.lib.${system}.rust) buildPackage;
      in {
        default = buildPackage {
          src = ./.;
        };
      }
    );
  };
}
