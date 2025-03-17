{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    localization.enable = lib.mkEnableOption "enables localization";
  };

  config = lib.mkIf config.localization.enable {
    time.timeZone = "Europe/Berlin"; # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    services.xserver.xkb.layout = "ch,fr";
  };
}
