# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# This config is common accross all nixos systems. i made it myself yaay...

{ config, lib, pkgs, inputs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel. mkDefault set incase custom kernels used instead
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Locale set to united kingdom
  i18n.defaultLocale = "en_GB.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow propriatary packages eg. nvidia drivers
  nixpkgs.config.allowUnfree = true;

  # Enable GPU acceleration
  hardware.graphics.enable = true;

  # Enable sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  security.rtkit.enable = true;

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable Tailscale
  services.tailscale = {
    enable = true;
  };

  # Enable display manager (Ly)
  services.displayManager.ly.enable = true;

  # Enable Plymouth for boot screen customisation
  boot = {
    plymouth = {
      enable = true;
      theme = "splash";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "splash" ];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    # Added limit to number of generations that can be stored in boot partition to prevent filling up
    loader = {
      timeout = 0;
      systemd-boot.configurationLimit = 5;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # Specify user using fish shell
  users.users.niall = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
    ];
  };

  # Enable fish shell. (shell defined per user in users block)
  programs.fish.enable = true;

  # Enable Hyprland desktop enviroment. (with UWSM for things like screen sharing)
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Enable Noctalia shell
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  # Enable Flatpaks
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    kitty
    asciiquarium-transparent
    neovim
    nautilus
    libheif #for nautilus
    udiskie #for nautlius
    git
    gh
    xdg-user-dirs
    bibata-cursors
    adw-gtk3 #for noctalia theming of gtk
    grim
    slurp
    wl-clipboard
    nextcloud-client
    seahorse
    localsend
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    discord
    spotify
    vscodium
    freecad
    gmsh # Freecad mesher
    calculix-ccx # Freecad solver
    orca-slicer
    kicad
    libreoffice
    darktable
    claude-code
  ];

  #Font settings
  fonts.packages = with pkgs; [
    google-fonts
    nerd-fonts.hack
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  #UPDATE ROBOTO TO GOOGLE SANS FLEX WHEN AVAILABLE IN GOOGLE FONTS PACKAGE
  fonts.fontconfig.defaultFonts = {
    monospace = [ "Hack Nerd Font Mono" "Noto Sans Mono" "Noto Color Emoji" ];
    sansSerif = [ "Roboto flex" "Noto Sans" "Noto Color Emoji" ];
    serif     = [ "Newsreader" "Noto Serif" "Noto Color Emoji" ];
    emoji     = [ "Noto Color Emoji" ];
  };

  # Nautlius file browser settings
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    })
  ];
  environment.pathsToLink = [ "share/thumbnailers" ];

  # Enable configuration of gnome and gtk settings (theme declared in home.nix)
  programs.dconf.enable = true;

  # Services to keep nextcloud client loggedin for nautilus
  services.gnome.gnome-keyring.enable = true;

  # Steam settings
  programs.steam = {
    enable = true; # Master switch, already covered in installation
    remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
    # Other general flags if available can be set here.
  };

  # Basic firewall with allowance for localsend: 53317
  networking.firewall = {
    enable = true;
    # enabled ports for localsend: 53317,
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

}
