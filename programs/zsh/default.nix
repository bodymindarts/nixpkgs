{ config }:
{
  enable = true;
  sessionVariables.EDITOR = "vim";
  sessionVariables.RPROMPT = "";
  sessionVariables.BASTION_USER = "justin_galoy_io";
  sessionVariables.CARGO_NET_GIT_FETCH_WITH_CLI = "true";

  initExtra =
    ''
    export XDG_CONFIG_HOME="/Users/''${USER}/.config"
    if [ -e "$HOME/.nix-defexpr/channels" ]; then
      export NIX_PATH="$HOME/.nix-defexpr/channels''${NIX_PATH:+:$NIX_PATH}"
    fi

    # Workaround till https://github.com/LnL7/nix-darwin/issues/158 is fixed
    export NIX_PATH="darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix:nixpkgs-overlays=$HOME/.config/nixpkgs/overlays:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}"

    function p() { cd $(find ~/projects -maxdepth 3 -type d | sk) }

    export PATH="''${PATH}:/Users/jcarter/.cargo/bin/"
    '';

  shellAliases = {
    ll = "ls -al";

    g = "git";
    gs = "git status";
    gb = "git branch";
    gl = "git log --oneline --graph --decorate --date=relative";

    tf = "terraform";
    k = "kubectl";

    ez = "vi ~/.config/nixpkgs/programs/zsh/default.nix";
    sz = "source ~/.zshrc";
    eh = "vi ~/.config/nixpkgs/darwin-home.nix";

    nix-update = "sudo -H nix-channel --update; source ~/.zshrc; nix-channel --update; darwin-rebuild switch; source ~/.zshrc";
    nix-update-linux = "sudo -H nix-channel --update; source ~/.zshrc; nix-channel --update; home-manager switch; source ~/.zshrc";
  };
}
