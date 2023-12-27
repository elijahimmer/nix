search_results=nix search --json nixpkgs $@

jq 

match='    ### INSERT PACKAGES HERE'
file='/flakes/nix/modules/env/packages.nix'

sed -i "s/$match/$match\n$@/" $file
