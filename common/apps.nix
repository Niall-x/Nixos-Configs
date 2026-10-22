{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    #Common apps
    inputs.tetris-tui.packages.${pkgs.stdenv.hostPlatform.system}.default
    asciiquarium-transparent
    git
    gh
    nextcloud-client
    localsend
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    discord
    spotify
    zed-editor
    libreoffice
    darktable
    claude-code

    #Engineering
    freecad
    calculix-ccx
    gmsh
    kicad
    orca-slicer
  ];

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
