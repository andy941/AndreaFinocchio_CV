{
  description = ''
    Nix flake to build a CV

    # Run inheriting your environment for development
    nix develop -c $SHELL

    # Run without your environment for production
    # (to check that all the necessary packages are specified in the flake)
    nix develop --ignore-environment
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        # Import nixpkgs for the current system
        pkgs = import nixpkgs { inherit system; };
        prodPackages = with pkgs; [
          zsh
          texlab
          texliveFull
        ];
      in {
        devShells.default = pkgs.mkShell {

          packages = prodPackages;

          shellHook = ''
            echo "Welcome to your Tex environment!"
          '';

          # Allow unfree packages (by default they are not enabled)
          allowUnfree = false;
        };
      });
}
