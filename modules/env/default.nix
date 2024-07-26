{
  pkgs,
  lib,
  config,
  flakeAbsoluteDir,
  ...
}: let
  cfg = config.mein.env;
in
  with lib; {
    imports = [./packages.nix];

    options.mein.env = {
      enable = mkEnableOption "default environment config" // {default = true;};
      withPkgs = mkEnableOption "include all default packages" // {default = true;};
      withCodingPkgs = mkEnableOption "include coding packages";
    };

    config = mkIf cfg.enable {
      environment = {
        shellAliases = let
          eza = getExe pkgs.eza;
        in {
          l = eza + " -al";
          ls = eza;
          la = eza + " -a";
          rm = ''echo "do you really wanna rm? use cnc! (or use \rm)"'';
        };

        variables.EDITOR = "nvim";
        variables.FLAKE = flakeAbsoluteDir;
      };

      programs = {
        skim = {
          fuzzyCompletion = true;
          keybindings = true;
        };

        tmux = {
          enable = true;
          shortcut = "a";
          newSession = true;
          keyMode = "vi";
          baseIndex = 1;
          clock24 = true;
          terminal = "alacritty";
        };

        starship = {
          enable = true;
          settings = {
            continuation_prompt = " $character";
            # I know there is a better way to write this,
            # I cannot find a way for some reason though.
            format =
              "$directory$git_branch$git_state$nix_shell$cmd_duration\n"
              + "$username$hostname $status$character ";
            directory.format = "[$path ]($style)";
            git_branch.format = "[$branch(:$remote_branch) ]($style)";
            git_state.format = ''[\($state \($progress_current/$progress_total\)\)]($style) '';
            nix_shell.format = ''[$state \($name\)]($style) '';
            username.format = "[$user]($style)";
            hostname.format = "[@$hostname]($style)";
            cmd_duration.show_notifications = true;
          };
        };
      };
    };
  }
