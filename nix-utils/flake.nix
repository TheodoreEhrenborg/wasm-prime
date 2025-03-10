{
  inputs = {
    nixpkgs.url = "nixpkgs/de0fe301211c";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        with pkgs; {
          devShells.default = mkShell {
            buildInputs = [
              wasm-pack
              elmPackages.elm
              elmPackages.elm-format
              elmPackages.elm-test
              elmPackages.elm-review
            ];
          };
        }
    );
}
