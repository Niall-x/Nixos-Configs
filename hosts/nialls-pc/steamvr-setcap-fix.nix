# Re-apply cap_sys_nice whenever a SteamVR update replaces vrcompositor-launcher
# (stops the "requires superuser access" / "setup is incomplete" popups)

{ pkgs, ... }:

let
  launcher = "/home/niall/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
in
{
  systemd.paths.steamvr-setcap = {
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathChanged = launcher;
  };

  systemd.services.steamvr-setcap = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      f=${launcher}
      [ -f "$f" ] || exit 0
      ${pkgs.libcap}/bin/getcap "$f" | grep -q cap_sys_nice || ${pkgs.libcap}/bin/setcap CAP_SYS_NICE+ep "$f"
    '';
  };
}
