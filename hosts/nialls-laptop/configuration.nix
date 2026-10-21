# nialls-laptop specific configuration (Framework 13, AMD Ryzen 7040 series)

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # Defined hostname
  networking.hostName = "nialls-laptop";

  # AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = true;

  # Enable fingerprint reader and ly compatibility
  services.fprintd.enable = true;
  security.pam.services.ly.fprintAuth = true;

  # Firmware updating service
  services.fwupd.enable = true;

  system.stateVersion = "26.05"; # match whatever nixos-generate-config reports on first install
}
