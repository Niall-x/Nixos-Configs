{ ... }:

{
  home.stateVersion = "26.05";
  home.username = "niall";
  home.homeDirectory = "/home/niall";

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

  programs.cava = {
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

  # Enable home manager cli commands
  programs.home-manager.enable = true;

}
