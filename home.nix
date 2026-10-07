# home.nix common accross all systems

# Import hostname as it is defined in flake.nix (used to define monitors.lua)
{ config, pkgs, lib, hostname, ... }:

{
  home.stateVersion = "26.05";
  home.username = "niall";
  home.homeDirectory = "/home/niall";

  # Kitty terminal settings including importing noctalia colours
  programs.kitty = {
    enable = true;
    extraConfig = ''
      include themes/noctalia.conf
    '';
    settings = {
      background_opacity = "0.4";
      shell_integration = "no-cursor";
      cursor_shape = "block";
      cursor_shape_unfocused = "hollow";
      cursor_trail = "1";
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = "0";
      scrollbar = "scrolled";
      scrollbar_jump_on_click = "no";
      enable_audio_bell = "no";
      confirm_os_window_close = "0";
      font_family = "Hack Nerd Font Mono";
    };
  };

  # Shell settigns, per user shell defined in common.nix
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      fastfetch
    '';
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
      fastfetch
    '';
  };

  programs.starship = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
      logo = {
        type = "small";
        source = "";
      };
      display = {
        key = {
          type = "icon"; # use built-in Nerd Font icons instead of text labels
        };
      };
      modules = [
        {
          type = "os";
          format = "{name} {arch}";
        }
        {
          type = "wm";
          format = "{pretty-name} ({protocol-name})";
        }
        {
          type = "display";
          format = "{width}x{height} @ {refresh-rate}Hz";
        }
        {
          type = "cpu";
          format = "{name}";
        }
        {
          type = "gpu";
          hideType = "integrated"; # show discrete GPU only, if present
          format = "{name}"; # no integrated/discrete label
        }
        {
          type = "gpu";
          hideType = "discrete"; # fallback: show integrated GPU
          format = "{name}";
          condition = {
            succeeded = false; # only runs if the discrete-GPU entry above found nothing
          };
        }
        "memory"
        {
          type = "disk";
          format = "{size-used} / {size-total} ({size-percentage}%)"; # no filesystem (ext4, etc.)
        }
	{
	  type = "packages";
	}
        "break"
        "colors"
      ];
    };
  };

  programs.cava = {
    enable = true;
  };

  # Gnome settings for specifying GTK theme (requires programs.dconf.enable = true)
  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = "adw-gtk3";
    color-scheme = "prefer-dark"; # or prefer-light
  };

  # Symlink for hyprland.lua and respective monitors.lua
  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
  xdg.configFile."hypr/monitors.lua".source = ./hosts/${hostname}/monitors.lua;

  # Small script for running hyprctl reload when noctalia has changed wallpaper for instant hyrpland color changing
  xdg.configFile."noctalia/hooks.toml".text = ''
    [hooks]
    colors_changed = "hyprctl reload"
  '';

  # Start Steam minimised to tray on login (nialls-pc only)
  xdg.configFile."autostart/steam.desktop" = lib.mkIf (hostname == "nialls-pc") {
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Steam
      Exec=steam -silent -pipewire
      Icon=steam
    '';
  };


  # Enable home manager cli commands
  programs.home-manager.enable = true;

}
