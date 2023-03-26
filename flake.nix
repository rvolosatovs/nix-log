{
  inputs.nix-flake-tests.url = github:antifuchs/nix-flake-tests;
  inputs.nixify.url = github:rvolosatovs/nixify;
  inputs.nixlib.url = github:nix-community/nixpkgs.lib;

  outputs = {nixify, ...} @ inputs:
    nixify.lib.mkFlake {
      withChecks = {
        checks,
        pkgs,
        ...
      }:
        checks // import ./checks inputs pkgs;
    }
    // {
      lib = import ./lib inputs;
    };
}
