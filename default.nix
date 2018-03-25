self: super:

let

  lib = super.lib;

  kernelConfigLatencyTOP = ''
    LATENCYTOP y
    SCHEDSTATS y
  '';

  kernelConfigOptimize = ''
    IOSCHED_DEADLINE y
    DEFAULT_DEADLINE y
    DEFAULT_IOSCHED deadline
    HPET_TIMER y
    TREE_RCU_TRACE? n
    RT_GROUP_SCHED? n
  '';

  kernelConfigRealtime = ''
    PREEMPT_RT_FULL y
    PREEMPT y
    RT_GROUP_SCHED? n
  '';

  musnixRealtimeKernelExtraConfig =
    { optimize ? true, latencytop ? false }:
    kernelConfigRealtime
    + lib.optionalString optimize kernelConfigOptimize
    + lib.optionalString latencytop kernelConfigLatencyTOP;

  musnixStandardKernelExtraConfig =
    { optimize ? true, latencytop ? false }:
    if optimize
      then "PREEMPT y\n"
           + kernelConfigOptimize
           + lib.optionalString latencytop kernelConfigLatencyTOP
      else if latencytop
        then kernelConfigLatencyTOP
        else "";

in rec {

  linux_3_18_rt = super.callPackage ./pkgs/os-specific/linux/kernel/linux-3.18-rt.nix {
    kernelPatches = [ super.kernelPatches.bridge_stp_helper
                      realtimePatches.realtimePatch_3_18
                    ];
    extraConfig   = musnixRealtimeKernelExtraConfig {};
  };

  linux_4_1_rt = super.callPackage ./pkgs/os-specific/linux/kernel/linux-4.1-rt.nix {
    kernelPatches = [ super.kernelPatches.bridge_stp_helper
                      realtimePatches.realtimePatch_4_1
                    ];
    extraConfig   = musnixRealtimeKernelExtraConfig {};
  };

  linux_4_4_rt = super.callPackage ./pkgs/os-specific/linux/kernel/linux-4.4-rt.nix {
    kernelPatches = [ super.kernelPatches.bridge_stp_helper
                      realtimePatches.realtimePatch_4_4
                    ];
    extraConfig   = musnixRealtimeKernelExtraConfig {};
  };

  linux_4_9_rt = super.callPackage ./pkgs/os-specific/linux/kernel/linux-4.9-rt.nix {
    kernelPatches = [ super.kernelPatches.bridge_stp_helper
                      super.kernelPatches.modinst_arg_list_too_long
                      realtimePatches.realtimePatch_4_9
                    ];
    extraConfig   = musnixRealtimeKernelExtraConfig {};
  };

  linux_4_11_rt = super.callPackage ./pkgs/os-specific/linux/kernel/linux-4.11-rt.nix {
    kernelPatches = [ super.kernelPatches.bridge_stp_helper
                      super.kernelPatches.modinst_arg_list_too_long
                      realtimePatches.realtimePatch_4_11
                    ];
    extraConfig   = musnixRealtimeKernelExtraConfig {};
  };

  linux_4_13_rt = super.callPackage ./pkgs/os-specific/linux/kernel/linux-4.13-rt.nix {
    kernelPatches = [ super.kernelPatches.bridge_stp_helper
                      super.kernelPatches.modinst_arg_list_too_long
                      realtimePatches.realtimePatch_4_13
                    ];
    extraConfig   = musnixRealtimeKernelExtraConfig {};
  };

  linux_4_14_rt = super.callPackage ./pkgs/os-specific/linux/kernel/linux-4.14-rt.nix {
    kernelPatches = [ super.kernelPatches.bridge_stp_helper
                      super.kernelPatches.modinst_arg_list_too_long
                      realtimePatches.realtimePatch_4_14
                    ];
    extraConfig   = musnixRealtimeKernelExtraConfig {};
  };

  linux_opt = super.linux.override {
    extraConfig = musnixStandardKernelExtraConfig {};
  };

  linuxPackages_3_18_rt = super.recurseIntoAttrs (super.linuxPackagesFor linux_3_18_rt);
  linuxPackages_4_1_rt  = super.recurseIntoAttrs (super.linuxPackagesFor linux_4_1_rt);
  linuxPackages_4_4_rt  = super.recurseIntoAttrs (super.linuxPackagesFor linux_4_4_rt);
  linuxPackages_4_9_rt  = super.recurseIntoAttrs (super.linuxPackagesFor linux_4_9_rt);
  linuxPackages_4_11_rt = super.recurseIntoAttrs (super.linuxPackagesFor linux_4_11_rt);
  linuxPackages_4_13_rt = super.recurseIntoAttrs (super.linuxPackagesFor linux_4_13_rt);
  linuxPackages_4_14_rt = super.recurseIntoAttrs (super.linuxPackagesFor linux_4_14_rt);
  linuxPackages_opt     = super.recurseIntoAttrs (super.linuxPackagesFor linux_opt);

  linuxPackages_latest_rt = linuxPackages_4_14_rt;

  realtimePatches = super.callPackage ./pkgs/os-specific/linux/kernel/patches.nix {};
}
