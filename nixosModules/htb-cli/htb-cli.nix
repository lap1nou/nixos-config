{
  self,
  pkgs,
  lib,
  config,
  ...
}:
let
  htb-cli = pkgs.buildGoModule rec {
    name = "htb-cli";
    version = "1.6.0";

    src = pkgs.fetchFromGitHub {
      owner = "GoToolSharing";
      repo = "htb-cli";
      rev = "v${version}";
      sha256 = "sha256-OGjw/ysW5pXQ/rJMCYDYJnxLi6du7gNlLw1sluG5iLs=";
    };

    vendorHash = "sha256-HqaxbbYKtquBoNE7lHmf+fVW4vUWwrluXFhn4NugXlw=";

    nativeBuildInputs = [ pkgs.installShellFiles ];

    # Doesn't work for some reason
    #postInstall = ''
    #  installShellCompletion --cmd htb-cli \
    #    --bash <($out/bin/htb-cli completion bash) \
    #    --zsh <($out/bin/htb-cli completion zsh) \
    #    --fish <($out/bin/htb-cli completion fish)
    #'';
  };
in
{
  options = {
    htb-cli.enable = lib.mkEnableOption "enables htb-cli";
  };

  config = lib.mkIf config.htb-cli.enable {
    home-manager.users.lapinou.home.packages = [
      htb-cli
    ];

    environment = {
      sessionVariables = rec {
        HTB_TOKEN = (builtins.readFile (self.outPath + "./secrets/.htb_env"));
      };
    };
  };
}
