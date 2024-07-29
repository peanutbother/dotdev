{
  inputs,
  eachSystem,
  filesInPath,
  ...
} @ args:
with inputs.nixpkgs; let
  mkShell = path: name: (system: {
    ${lib.removeSuffix ".nix" name} = import (path + "/${name}") args system;
  });
in
  path: {
    devShells = eachSystem (system: builtins.foldl' (acc: elem: acc // (mkShell path elem system)) {} (filesInPath path));
  }
