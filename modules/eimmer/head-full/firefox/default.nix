{
  lib,
  config,
  ...
}: {
  imports = [./search.nix];

  options.mein.eimmer.headFull.firefox.enable = lib.mkEnableOption "enable firefox" // {default = config.mein.eimmer.headFull.enable;};

  config = lib.mkIf config.mein.eimmer.headFull.firefox.enable {
    environment.sessionVariables = rec {
      BROWSER = lib.getExe config.home-manager.users.eimmer.programs.firefox.finalPackage;
      DEFAULT_BROWSER = BROWSER;
    };

    home-manager.users.eimmer = _: {
      programs.firefox = {
        enable = true;
        profiles = {
          normal = {
            isDefault = true;
            extraConfig = builtins.readFile ./user.perf;
            userChrome = builtins.readFile ./userChrome.css;
            userContent = builtins.readFile ./userContent.css;
          };
        };
        policies = {
          CaptivePortal = true;
          DisableMasterPasswordCreation = true;
          DisableFirefoxAccounts = false;
          DisplayMenuBar = false;
          DisableAppUpdate = true;
          DisableFirefoxStudies = true;
          DisableTelemetry = true;
          DisablePocket = true;
          DNSOverHTTPS.Enabled = false;
          NetworkPrediction = false;
          NewTabPage = false;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
          SearchSuggestEnabled = false;
          Extensions = let
            addons_url = "https://addons.mozilla.org/firefox/downloads/latest";
          in {
            Install = [
              "${addons_url}/decentraleyes/latest.xpi"
              "${addons_url}/ublock-origin/latest.xpi"
              "${addons_url}/privacy-badger17/latest.xpi"
              "${addons_url}/canvasblocker/latest.xpi"
              "${addons_url}/darkreader/lastest.xpi"
              "${addons_url}/bitwarden-password-manager/lastest.xpi"
              "${addons_url}/firefox-color/lastest.xpi"
              "${addons_url}/pay-by-privacy/latest.xpi"
              "${addons_url}/private-relay/latest.xpi"
              "https://www.zotero.org/download/connector/dl?browser=firefox"
            ];
          };
        };
      };
    };
  };
}
