{
  pkgs,
  lib,
  hostName,
  stateVersion,
  ...
}: {
  imports = [
    ./packages.nix
    ./nixvim.nix
    ./ssh.nix
  ];
  # needed to get flakes to work
  environment.systemPackages = with pkgs; [git];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";
  location.provider = "geoclue2";

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  networking = {inherit hostName;};
  system = {inherit stateVersion;};

  security.sudo.execWheelOnly = true;

  environment.shellAliases = let
    eza = lib.getExe pkgs.eza;
  in {
    l = "${eza} -al";
    ls = eza;
    la = "${eza} -a";
    rm = ''echo "do you really wanna rm? use cnc! (or use \rm)"'';
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
