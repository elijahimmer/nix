{...}: {
  stylix = {
    image = ./background.png;
    base16Scheme = ./rose-pine-base16.yaml;
    polarity = "dark";
    opacity.terminal = 0.9;
    fonts = {
      serif = {
        name = "fira-go";
        package = pkgs.fira-go;
      };
      sansSerif = {
        name = "fira-go";
        package = pkgs.fira-go;
      };
      monospace = {
        name = "nerdfont";
        package = pkgs.nerdfonts;
      };
    };
  };
}
