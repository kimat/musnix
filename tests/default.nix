{
  loginTest = import <nixpkgs/nixos/tests/make-test.nix> {

    machine =
      { config, pkgs, ... }:
      { imports =
          [ ../modules/base.nix
            ../modules/rtirq.nix
          ];

        nixpkgs.overlays = [ (import ../default.nix) ];

        boot.kernelPackages = pkgs.linuxPackages_latest_rt;

        musnix.enable = true;
        musnix.soundcardPciId = "00:05.0";
        musnix.rtirq.enable = true;
        musnix.rtirq.highList = "timer";
      };

    testScript = ''
      $machine->start;
      $machine->waitForUnit("default.target");
      $machine->succeed("uname") =~ /Linux/;
    '';
  };
}
