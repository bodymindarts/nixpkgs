{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  programs.home-manager.enable = true;
  experimental-features = nix-command;
  home.username = "justin_galoy_io";
  home.homeDirectory = "/home/justin_galoy_io";
  home.packages = [
        pkgs.nix-prefetch
        pkgs.bats
        pkgs.ag
        pkgs.jq
        pkgs.ipcalc
        pkgs.openssh
        pkgs.watch
        pkgs.wget
        pkgs.tree

        pkgs.pkgconfig
        pkgsUnstable.terraformer
        pkgsUnstable.terraform
        pkgs.vault
        pkgs.kubectl
        pkgs.kubernetes-helm
        pkgs.google-cloud-sdk
        pkgs.kapp
        pkgs.safe
      ];
      programs.git = {
        enable = true;
        userName  = "bodymindarts";
        userEmail = "justin@misthos.io";
        extraConfig = {
          core = { editor = "vim"; };
          "url \"ssh://git@github.com/\"" = { insteadOf = "https://github.com/"; };
          alias = {
            ci = "commit";
            amend = "commit --amend";
          };
        };
        ignores = [ "*~" ];
        lfs.enable = true;
      };
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv = {
          enable = true;
        };
      };
      programs.ssh = {
        enable = true;
        compression = true;
        forwardAgent = false;
      };
      programs.skim = {
        enable = true;
        enableZshIntegration = true;
      };
      programs.starship = import ./programs/starship/remote.nix { };
      programs.zsh = import ./programs/zsh/remote.nix { config = config; };
      programs.neovim = import ./programs/neovim/remote.nix { pkgs = pkgs; };
      programs.tmux = import ./programs/tmux/default.nix { pkgs = pkgs; };

  home.stateVersion = "21.05";
}
