{pkgs, inputs, ...}: {
  nixpkgs.overlays = [ (import inputs.self.inputs.emacs-overlay) ];
  environment.systemPackages = with pkgs; [
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science es]))
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-gtk;
      config = ./config.el;

      extraEmacsPackages = ep: with ep; [
        use-package
      ];
    };
    defaultEditor = true;
    startWithGraphical = true;
  };
}
