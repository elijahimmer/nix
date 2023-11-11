{pkgs, ...}: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira-code
      fira-code-symbols
      terminus_font
      powerline-fonts
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      source-code-pro
      ttf_bitstream_vera
      terminus_font_ttf
    ];
    fontDir.enable = true;
  };
}
