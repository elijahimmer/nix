{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))
    tree-sitter-grammars.tree-sitter-typst
    typst-lsp
  ];

  home-manager.users.eimmer = {pkgs, inputs, lib, ...}: {
    home.packages = with pkgs; [
      (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))
      tree-sitter-grammars.tree-sitter-typst
      typst-lsp
    ];
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      extraConfig = ''
        (use-package evil)
        (evil-mode 1)

        (use-package vterm)

        ;; modes
        (load-library "${inputs.typst-ts-mode}/typst-ts-embedding-lang-settings")
        (load-library "${inputs.typst-ts-mode}/typst-ts-mode")
        (use-package nix-mode)
        (use-package zig-mode)
        (use-package rust-mode)
        (use-package toml-mode)
        (use-package sass-mode)
        (use-package just-mode)
        (use-package justl)

        ;; theme
        (load-library "${inputs.rose-pine-emacs}/rose-pine-theme")
        ;;(require 'rose-pine-theme)
        (load-theme 'rose-pine)
      '';
      extraPackages = epkgs: (with epkgs; [
        use-package
        evil
        autothemer
        vterm
        nix-mode
        zig-mode
        rust-mode
        toml-mode
        sass-mode
        justl
        just-mode
      ]) ++ (with pkgs; [
        tree-sitter-grammars.tree-sitter-typst
        typst-lsp
      ]);
    };

    services.emacs = {
      enable = true;
      defaultEditor = true;
      client.enable = true;
    };
  };
}
