{
  headfull,
  pkgs,
  ...
}: {
  imports = [./packages.nix];

  environment = {
    shellAliases = {
      l = "eza -al";
      ls = "eza";
      la = "eza -a";
      rm = ''echo "do you really wanna rm? use cnc! (or use \rm)"'';
    };
  };

  programs.skim = {
    fuzzyCompletion = true;
    keybindings = true;
  };

  environment.variables = rec {
    EDITOR = "nvim";
    GIT_PAGER = EDITOR;
    PAGER = "page";
    VISUAL = PAGER;
  };

  programs.nixvim = {
    enable = true;
    clipboard.register =
      if headfull
      then "unnamedplus"
      else "";
    # Make Neovim's Yank and Paste use the system clipboard
    # I think I should work on this at some point, always
    #    using the clipboard is annoying.

    colorschemes.rose-pine = {
      enable = true;
      transparentBackground = true;
      disableItalics = true;
    };

    options = {
      browsedir = "buffer";
      mouse = "";
      number = true;
      relativenumber = true;
      smartindent = true;
      tabstop = 2;
      shiftwidth = 2;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      continuation_prompt = "$character";
      # I know there is a better way to write this,
      # I cannot find a way for some reason though.
      format =
        "$directory$git_branch$git_state$nix_shell$cmd_duration\n"
        + "$username$hostname $status$character ";
      directory.format = "[$path ]($style)";
      git_branch.format = "[$branch(:$remote_branch) ]($style)";
      git_state.format = ''\($state \($progress_current/$progress_total\)\)]($style) '';
      nix_shell.format = ''[$state \($name\)]($style) '';
      username.format = "[$user]($style)";
      hostname.format = "[@$hostname]($style)";
      cmd_duration = {
        #format = "[$duration]($style) ";
        show_notifications = true;
      };
    };
  };
}
