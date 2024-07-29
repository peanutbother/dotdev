inputs: let
  lib = import ./lib.nix {inherit inputs;};
  args = {
    inherit inputs;
    inherit (lib.common) eachDefaultFolder filesInPath eachSystem eachSystemWithPkgs mkShell;
  };

  formatterPackArgsPerSystem = lib.common.eachSystem (system: {
    inherit (inputs) nixpkgs;
    inherit system;

    checkFiles = [./.];

    config = {
      tools = {
        deadnix.enable = true;
        alejandra.enable = true;
        statix.enable = true;
      };
    };
  });
in
  {
    inherit lib;
    formatter = lib.common.eachSystem (system: inputs.nix-formatter-pack.lib.mkFormatter formatterPackArgsPerSystem.${system});
    checks = lib.common.eachSystem (system: {
      nix-formatter-pack-check = inputs.nix-formatter-pack.lib.mkCheck formatterPackArgsPerSystem.${system};
    });
  }
  // (import ./shells.nix args ../shells)
  // import ../templates
