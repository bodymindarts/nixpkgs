{ config, pkgs, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> {};

in {
  imports = [ <home-manager/nix-darwin> ];

  home-manager = {
    useUserPackages = false;
    useGlobalPkgs = true;
    users.jcarter = {
      programs.home-manager.enable = true;
      home.username = "jcarter";
      home.homeDirectory = "/Users/jcarter";
      home.packages = [
        pkgs.neovim-nightly
        pkgs.nodejs
        pkgs.redis
        pkgs.yarn
        pkgs.nodePackages.npm
        pkgs.nodePackages.typescript-language-server
        pkgs.nodePackages.diagnostic-languageserver
        pkgs.nodePackages.eslint_d
        pkgs.nix-prefetch
        pkgs.bats
        pkgs.ag
        pkgs.cf
        pkgs.jq
        pkgs.ytt
        pkgs.ipcalc
        pkgs.openssh
        pkgs.watch
        pkgs.wget
        pkgs.tree
        pkgs.fly73

        pkgsUnstable.rustup
        pkgsUnstable.terraformer
        pkgsUnstable.terraform

        pkgs.minikube
        pkgs.kubectl
        pkgs.kubernetes-helm

        pkgs.google-cloud-sdk

        pkgs.kapp
        pkgs.safe
      ];
      programs.git = {
        enable = true;
        userName  = "bodymindarts";
        userEmail = "justin@galoy.io";
        extraConfig = {
          core = { editor = "vim"; };
          "url \"ssh://git@github.com/\"" = { insteadOf = "https://github.com/"; };
          credential = { helper = "osxkeychain"; };
          alias = {
            ci = "commit";
            dc = "diff --cached";
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
        matchBlocks = {
          "control-plane" = {
            hostname = "35.198.79.44";
            user = "justin_misthos_io";
          };
        };
      };
      programs.starship = import ./programs/starship/default.nix { };
      programs.skim = {
        enable = true;
        enableZshIntegration = true;
      };
      programs.zsh = import ./programs/zsh/default.nix { config = config; };
      programs.tmux = import ./programs/tmux/default.nix { pkgs = pkgs; };
      programs.neovim = import ./programs/neovim/default.nix { pkgs = pkgs; };
      home.stateVersion = "21.03";
    };
  };
}
