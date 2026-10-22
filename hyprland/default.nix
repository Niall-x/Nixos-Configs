{ ... }:

{
  imports = [
    ./hyprland.nix
  ];
  home-manager.users.niall.imports = [ ./home.nix ];
}
