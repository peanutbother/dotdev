{
  description = "nix-conf";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    utils = import ./util inputs;
  in {
    description = "A flake with utils, devShells and templates to build convenient environments";
    inherit (utils) formatter checks lib devShells templates;
  };
}
