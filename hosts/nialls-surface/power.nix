# Battery life / heat tuning for the Surface Pro 8 (mostly used for YouTube)
#
# Replaces power-profiles-daemon with TLP. tlp-pd provides the same DBus API,
# so the GNOME quick-settings power mode buttons keep working:
#   Performance  -> *_ON_AC  settings
#   Balanced     -> *_ON_BAT settings  (auto-selected when plugged in)
#   Power Saver  -> *_ON_SAV settings  (auto-selected on battery)
# Check what is active with: sudo tlp-stat -s -p

{ config, lib, pkgs, ... }:

{
  # GNOME turns this on by default; tlp-pd takes over its DBus interface
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    pd.enable = true;

    settings = {
      # Plugged in -> Balanced, on battery -> Power Saver
      TLP_PROFILE_AC = "BAL";
      TLP_PROFILE_BAT = "SAV";

      # Balanced: full boost still available, but leaning towards efficiency
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      PLATFORM_PROFILE_ON_BAT = "balanced";

      # Power Saver: no turbo (caps at 3.0 GHz base clock, which kills most of
      # the heat), CPU max at 60%, EPP 'power' and Surface EC low-power profile.
      # Video decode runs on the iGPU media engine so playback is unaffected.
      CPU_ENERGY_PERF_POLICY_ON_SAV = "power";
      CPU_BOOST_ON_SAV = 0;
      CPU_HWP_DYN_BOOST_ON_SAV = 0;
      CPU_MAX_PERF_ON_SAV = 60;
      PLATFORM_PROFILE_ON_SAV = "low-power";
      PCIE_ASPM_ON_SAV = "powersupersave";

      # Runtime PM for PCIe devices + wifi power saving on battery
      RUNTIME_PM_ON_BAT = "auto";
      WIFI_PWR_ON_BAT = "on";
    };
  };
}
