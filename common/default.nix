{ ... }:

{
  imports = [
    ./system.nix
    ./apps.nix
  ];
  home-manager.users.niall.imports = [ ./home.nix ];
}
