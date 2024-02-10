{headFull, ...}: {
  programs.nixvim.config = {
    enable = true;

    # Make Neovim's Yank and Paste use the system clipboard
    # I think I should work on this at some point, always
    #    using the clipboard is annoying.
#    clipboard.providers.wl-copy.enable = true;
    clipboard.register =
      if headFull
      then "unnamedplus"
      else "";
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
}
