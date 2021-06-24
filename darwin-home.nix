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
        pkgs.ipcalc
        pkgs.openssh
        pkgs.watch
        pkgs.wget
        pkgs.tree
        pkgs.fly72

        pkgsUnstable.rustup
        pkgs.pkgconfig
        pkgs.postgresql
        pkgsUnstable.terraformer
        pkgsUnstable.terraform
        pkgs.vault

        pkgs.minikube
        pkgs.kubectl
        pkgs.kubernetes-helm

        pkgs.google-cloud-sdk

        pkgs.kapp
        pkgs.safe
        pkgs.eden
        pkgs.genesis
        pkgs.bosh
        pkgs.credhub
        pkgs.spruce
      ];
      programs.git = {
        enable = true;
        userName  = "bodymindarts";
        userEmail = "justin@misthos.io";
        extraConfig = {
          core = { editor = "vim"; };
          "url \"ssh://git@github.com/\"" = { insteadOf = "https://github.com/"; };
          credential = { helper = "osxkeychain"; };
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
        matchBlocks = {
          "control-plane" = {
            hostname = "35.198.79.44";
            user = "justin_misthos_io";
          };
        };
      };
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          scan_timeout = 10;
          format = "$directory$git_branch$line_break$status$character";
          character = {
            success_symbol = "[\\$](bold #00e600)";
            error_symbol = "[\\$](bold #d33682)";
          };
          directory = {
            truncation_length = "3";
            style	 = "bold #268bd2";
          };
          status = {
            disabled = false;
            format = "[\\($status\\) ](bold #839496)";
          };
          git_branch = {
            format = "[$branch*]($style) ";
            style = "#839496";
          };
        };
      };
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
