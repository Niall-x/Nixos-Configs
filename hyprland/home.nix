{ hostname, ... }:

{
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

  # Gnome settings for specifying GTK theme (requires programs.dconf.enable = true)
  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = "adw-gtk3";
    color-scheme = "prefer-dark"; # or prefer-light
  };

  # Symlink for hyprland.lua and respective monitors.lua
  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
  xdg.configFile."hypr/monitors.lua".source = ../hosts/${hostname}/monitors.lua;

  # Small script for running hyprctl reload when noctalia has changed wallpaper for instant hyrpland color changing
  xdg.configFile."noctalia/hooks.toml".text = ''
    [hooks]
    colors_changed = "hyprctl reload"
  '';

}
