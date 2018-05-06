let
  pkgs = import <nixpkgs> { overlays = [ (import ./default.nix) ]; };

  tests = import ./tests/default.nix;

  jobs = rec {
    loginTest     = tests.loginTest;
    linux_3_18_rt = pkgs.linux_3_18_rt;
    linux_4_1_rt  = pkgs.linux_4_1_rt;
    linux_4_4_rt  = pkgs.linux_4_4_rt;
    linux_4_9_rt  = pkgs.linux_4_9_rt;
    linux_4_11_rt = pkgs.linux_4_11_rt;
    linux_4_13_rt = pkgs.linux_4_13_rt;
    linux_4_14_rt = pkgs.linux_4_14_rt;
  };
in
  jobs
