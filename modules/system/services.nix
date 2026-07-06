{ pkgs, ... }:

{
  # TLP is the ThinkPad-native power manager; supports EC-level battery thresholds
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC    = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT   = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Battery charge thresholds — extend longevity significantly
      START_CHARGE_THRESH_BAT0 = 20;
      STOP_CHARGE_THRESH_BAT0  = 80;

      USB_AUTOSUSPEND    = 1;
      RUNTIME_PM_ON_AC   = "on";
      RUNTIME_PM_ON_BAT  = "auto";

      PLATFORM_PROFILE_ON_AC  = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
    };
  };

  # Must be disabled when TLP is enabled
  services.power-profiles-daemon.enable = false;

  # Intel CPU thermal management
  services.thermald.enable = true;

  # Intel i915 power-saving kernel parameters
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "i915.enable_fbc=1"
    "i915.enable_psr=1"
  ];

  services.logind.settings.Login = {
    HandleLidSwitch              = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked        = "ignore";
    HandlePowerKey               = "suspend";
    IdleAction                   = "lock";
    IdleActionSec                = "10min";
  };

  services.openssh = {
    enable   = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin        = "no";
    };
  };

  networking.firewall.enable = false;

  # ThinkPad special keys
  services.acpid.enable = true;

  # Firmware updates via LVFS (BIOS, SSD, etc.)
  services.fwupd.enable = true;
}
