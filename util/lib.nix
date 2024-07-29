{inputs, ...}:
with inputs.nixpkgs; let
  # map each subfolder of given `path` with a `default.nix` to an attribute name with its exports
  eachDefaultFolder = path: lib.mapAttrs (name: _: import (path + "/${name}")) (lib.filterAttrs (_: d: d == "directory") (builtins.readDir path));

  # map files in a path to a list
  filesInPath = path: builtins.attrNames (builtins.readDir path);

  # map an expression to each system attribute
  eachSystem = fn:
    lib.genAttrs [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ]
    fn;

  # map an expression to each system attribute providing nixpkgs.pkgs
  eachSystemWithPkgs = fn:
    eachSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        allowUnfree = true;
      };
    in
      fn system pkgs);

  # make shells overridable
  mkShell = pkgs: attr:
    pkgs.mkShell attr
    // {
      override = override: pkgs.mkShell (attr // (override attr));
      packages = attr._packages or attr.packages;
    };
in
  eachSystemWithPkgs (_: pkgs: {
    rust = inputs.crane.mkLib pkgs;
  })
  // {
    common = {
      inherit eachDefaultFolder eachSystem eachSystemWithPkgs filesInPath mkShell;
    };
  }
