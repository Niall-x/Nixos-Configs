# nialls-pc specific configurations

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../hyprland
    inputs.esp32-ir-remote.nixosModules.default

    # Implemented fix for steam vr popup. check nixos steam vr docs to see if fixed
    ./steamvr-setcap-fix.nix
  ];

  # Defined hostname
  networking.hostName = "nialls-pc";

  # Hardware specific settings
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Extra group for this machine (serial/USB device access)
  users.users.niall.extraGroups = [ "dialout" ];

  # ESP32 IR remote — mirrors PC power state to the TV
  services.esp32-ir-remote.enable = true;

  # nialls-pc exclusive packages
  environment.systemPackages = with pkgs; [
    wayvr
    bs-manager
  ];

  #fix for steam frame adaptop unreliability (may be fixed by valve later)
  systemd.services.wpa_supplicant = {
    after = [ "sys-subsystem-net-devices-wlp8s0.device" ];
    wants = [ "sys-subsystem-net-devices-wlp8s0.device" ];
  };


  system.stateVersion = "26.05";

}
