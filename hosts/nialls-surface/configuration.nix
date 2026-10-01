# nialls-surface specific configuration (Surface Pro 8, Intel)

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];

  networking.hostName = "nialls-surface";

  # common.nix turns these on unconditionally — force them off here
  services.displayManager.ly.enable = lib.mkForce false;
  programs.hyprland.enable = lib.mkForce false;
  programs.noctalia.enable = lib.mkForce false;

  # GNOME + GDM instead
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # GNOME OSK auto-appear fix
  i18n.inputMethod.ibus.waylandFrontend = true;

  # Additional system packages
  environment.systemPackages = with pkgs; [ gnome-extension-manager ];

  system.stateVersion = "26.05"; # match nixos-generate-config on first install

  # Thick screen protector sensitivity tweaks
  services.iptsd = {
  enable = true;
  config = {
    Touchscreen = {
      Overshoot = 0.8;              # default 0.5 — more forgiving near the bezel edge
    };

    Contacts = {
      # Lower = registers weaker/fainter contacts (what a thick protector gives you)
      ActivationThreshold   = 8;    # default 24
      DeactivationThreshold = 5;    # default 20 — must stay below ActivationThreshold

      # Protectors often make contacts measure smaller/fuzzier than bare glass,
      # so widen the accepted size window rather than narrowing it via calibration
      SizeMin = 0.12;               # default 0.2
      SizeMax = 2.2;                # default 2.0

      # More tolerant of a contact's size/position wobbling before it's
      # dropped as "unstable" — helps light drags and swipes not get lost
      SizeThresholdMin     = 0.05;  # default 0.1
      PositionThresholdMin = 0.02;  # default 0.04
    };
  };
};

}
