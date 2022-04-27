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
        pkgs.vault
        pkgs.nodejs-16_x
        pkgs.redis
        (pkgs.yarn.override {
          nodejs = pkgs.nodejs-16_x;
        })

        pkgs.gh
        pkgs.nix-prefetch
        pkgs.grpcurl
        pkgs.bats
        pkgs.silver-searcher
        pkgs.jq
        pkgs.yq
        pkgs.ytt
        pkgs.vendir
        pkgs.ipcalc
        pkgs.htop
        pkgs.openssh
        pkgs.watch
        pkgs.watchman
        pkgs.wget
        pkgs.tree
        pkgs.fly77
        pkgs.mongodb-tools
        pkgs.postgresql
        pkgs.gnugrep
        pkgs.uutils-coreutils
        pkgs.bitcoin
        pkgsUnstable.lnd
        pkgs.jupyter

        pkgs.nodePackages.typescript-language-server
        pkgs.nodePackages.diagnostic-languageserver
        pkgs.nodePackages.lerna
        pkgs.nodePackages.eslint_d

        pkgsUnstable.rustup
        pkgsUnstable.sqlx-cli
        pkgs.flatbuffers
        pkgsUnstable.rust-analyzer
        pkgsUnstable.terraform
        pkgs.envsubst

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
          init = { defaultBranch = "main"; };
          core = { editor = "vim"; };
          "url \"ssh://git@github.com:\"" = { insteadOf = "https://github.com"; };
          credential = { helper = "osxkeychain"; };
          alias = {
            ci = "commit";
            dc = "diff --cached";
            b = "branch";
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
