{ pkgs, ... }:

{
  boot = {
    plymouth = {
      enable = true;
      theme = "splash";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override { selected_themes = [ "splash" ]; })
      ];
    };
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
  };

  services.displayManager.ly.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

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

  # Enable configuration of gnome and gtk settings (theme declared in home.nix)
  programs.dconf.enable = true;

  # Services to keep nextcloud client loggedin for nautilus
  services.gnome.gnome-keyring.enable = true;

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

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  environment.systemPackages = with pkgs; [
    # Desktop Hyprland
    kitty
    neovim
    nautilus
    libheif
    libheif.out
    loupe
    btop
    mission-center
    xdg-user-dirs
    bibata-cursors
    adw-gtk3
    grim
    slurp
    wl-clipboard
    seahorse
  ];

}
