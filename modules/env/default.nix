{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./packages.nix
    ./ssh.nix
    ./coding.nix
    ./autoupgrade.nix
  ];
  # needed to get flakes to work
  environment = {
    systemPackages = with pkgs; [git];
    shellAliases = let
      eza = lib.getExe pkgs.eza;
    in {
      l = "${eza} -al";
      ls = eza;
      la = "${eza} -a";
      rm = ''echo "do you really wanna rm? use cnc! (or use \rm)"'';
    };

    variables = rec {
      EDITOR = "nvim";
      PAGER = lib.getExe pkgs.nvimpager;
      VISUAL = PAGER;
    };
  };

  programs = { 
    skim = {
      fuzzyCompletion = true;
      keybindings = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withNodeJs = false;
      withRuby = false;
      withPython3 = false;

      configure = {
        customRC = ''
          lua << EOF
            ${builtins.readFile ./init.lua}
          EOF
        '';
  
        packages.mein = with pkgs.vimPlugins; {
          start = [
            vim-just
            vim-nix
            statix

            # theme
            rose-pine
          ];
        };
      };
    };
  };


  programs.starship = {
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
}
