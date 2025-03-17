{
  self,
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.firefox.enable {
    programs.firefox.enable = true;

    # https://mozilla.github.io/policy-templates/
    programs.firefox.policies = {
      DisableTelemetry = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      Homepage.StartPage = "previous-session";
      ExtensionSettings = {
        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4205543/darkreader-4.9.73.xpi";
        };
        "foxyproxy@eric.h.jung" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4207660/foxyproxy_standard-8.6.xpi";
        };
        "wappalyzer@crunchlabz.com" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4189626/wappalyzer-6.10.67.xpi";
        };
        "keepassxc-browser@keepassxc.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4376326/keepassxc_browser-1.9.4.xpi";
        };
      };
      DisplayBookmarksToolbar = "always";
      ManagedBookmarks = [
        { toplevel_name = "RedTeam"; }
        {
          name = "Guides";
          children = [
            {
              name = "TheHackerRecipes";
              url = "https://www.thehacker.recipes/";
            }
            {
              name = "TheHackerRecipes Tools";
              url = "https://tools.thehacker.recipes/";
            }
            {
              name = "HackTricks";
              url = "https://book.hacktricks.xyz/welcome/readme";
            }
            {
              name = "Red Team Notes";
              url = "https://www.ired.team/";
            }
            {
              name = "OCD Mindmaps";
              url = "https://orange-cyberdefense.github.io/ocd-mindmaps/";
            }
            {
              name = "PayloadsAllTheThings";
              url = "https://github.com/swisskyrepo/PayloadsAllTheThings";
            }
            {
              name = "Portswigger XSS Cheatsheet";
              url = "https://portswigger.net/web-security/cross-site-scripting/cheat-sheet";
            }
          ];
        }
        {
          name = "Tools";
          children = [
            {
              name = "Cyberchef";
              url = "file:///run/current-system/sw/share/cyberchef/index.html";
            }
            {
              name = "Revshell";
              url = "https://www.revshells.com/";
            }
            {
              name = "BloodHound-CE";
              url = "http://127.0.0.1:1030/ui/login";
            }
          ];
        }
        {
          name = "Lolol.farm";
          children = [
            {
              name = "Lolol.farm";
              url = "https://lolol.farm/";
            }
            {
              name = "Living off the False Positive";
              url = "https://br0k3nlab/LoFP/";
            }
            {
              name = "Living Off The Land Drivers";
              url = "https://loldrivers.io";
            }
            {
              name = "GTFOBins";
              url = "https://gtfobins.github.io";
            }
          ];
        }
      ];

      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
      };
    };
  };
}
