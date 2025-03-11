#!/bin/bash

# install and configure nix
su ${username} -c "curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm"
su ${username} -c "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && NIXPKGS_ALLOW_UNFREE=1 nix profile install --impure nixpkgs#git nixpkgs#go nixpkgs#pnpm_9 nixpkgs#python3 nixpkgs#nodejs nixpkgs#opentofu nixpkgs#google-cloud-sdk nixpkgs#tailscale nixpkgs#git-credential-oauth"
# so you can push to git repos without having to add a ssh key or use a PAT
su ${username} -c "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && git credential-oauth configure"


# so many benefits to being open source!
# one is we don't have to worry about having to authenticate to pull down the code :) 
su ${username} -c "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && git clone https://github.com/e2b-dev/infra /home/${username}/infra"
su ${username} -c "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh && git clone https://github.com/e2b-dev/E2B /home/${username}/E2B"
# su e2b -c "git clone https://github.com/e2b-dev/devnenv"
