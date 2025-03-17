{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    variables = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config.variables = {
    host = "work";
  };
}
