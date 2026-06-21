{
  # templates
  templates = {
    embedded = {
      description = "embedded development environment";
      path = ./embedded;
    };
    nix = {
      description = "nix development environment";
      path = ./nix;
    };
    nodejs = {
      description = "nodejs development environment";
      path = ./nodejs;
    };
    rust = {
      description = "rust development environment";
      path = ./rust;
    };
    rust-nix = {
      description = "rust development environment with a flake build script";
      path = ./rust-nix;
    };
    typescript = {
      description = "typescript development environment";
      path = ./typescript;
    };
  };
}
