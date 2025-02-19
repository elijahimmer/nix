Moved to codeberg https://codeberg.org/Elijah-Immer/nix

# My NixOS configs.

Just my own personal repo for my systems.

## Theme
I imported the rose-pine color scheme into stylix,

All the non-stylix themes are from `https://github.com/rose-pine`
(some have slight modifications I point out in comments)

Firefox Theme: https://github.com/rose-pine/firefox
Alacritty Theme: https://github.com/rose-pine/alacritty

## Make Portable ISO

```sh
nix build .#nixosConfigurations.portable.config.system.build.isoImage
```

## Hooks

You should be using the following `pre-commit` hook to update the date correctly.

```bash
date +"%s" > ./updated_last
git add ./updated_last
```

