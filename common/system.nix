
{ config, lib, pkgs, ... }:

{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
      systemd-boot.configurationLimit= 5;
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic =  true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  users.users.niall = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };
  programs.fish.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

  hardware.graphics.enable = true;

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024; # 16 GiB
  }];
  zramSwap.enable = true;

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  security.rtkit.enable = true;

  # Enable Printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  # Enable Tailscale
  services.tailscale = {
    enable = true;
  };

}
