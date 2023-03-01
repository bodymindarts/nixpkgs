{ pkgs }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
  ale = pkgs.vimUtils.buildVimPlugin {
    name = "vim-ale";
    src = pkgs.fetchFromGitHub {
      owner = "dense-analysis";
      repo = "ale";
      rev = "388cf3374312b05122151bc68691bf09a69ff840";
      sha256 = "sha256-d3Ce2V90dn5ce2NCqaH3ZqXdgmKBrkKTSHmMwd1q7ss=";
    };
  };
  copilot = pkgs.vimUtils.buildVimPlugin {
    name = "vim-copilot";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = "copilot.vim";
      rev = "c2e75a3a7519c126c6fdb35984976df9ae13f564";
      sha256 = "sha256-V13La54aIb3hQNDE7BmOIIZWy7In5cG6kE0fti/wxVQ=";
    };
  };
in {
  enable = true;
  viAlias = true;
  vimAlias = true;
  # package = pkgsUnstable.neovim;
  plugins = with pkgs.vimPlugins; [
    copilot
    { plugin = ale;
      config = "
        let g:ale_completion_enabled = 1
        let g:ale_completion_autoimport = 1
        let g:ale_linters = {'javascript': [], 'typescript': ['tsserver', 'eslint'], 'typescript.tsx': ['tsserver', 'eslint'], 'rust': ['analyzer'] }
        let g:ale_fixers = {'javascript': [], 'typescript': ['eslint'], 'typescript.tsx': ['eslint'], 'rust': ['rustfmt'] }
        let g:ale_lint_on_text_changed = 'normal'
        let g:ale_lint_on_insert_leave = 1
        let g:ale_lint_delay = 0
        let g:ale_set_quickfix = 0
        let g:ale_set_loclist = 0
        let g:ale_javascript_eslint_executable = 'eslint --cache'

        nnoremap <silent> gd :ALEGoToDefinition<enter>
      ";
    }
    {
      plugin = ctrlp-vim;
      config = "
        let g:ctrlp_user_command = 'ag %s -l -f --nocolor -g \"\"'
        let g:ctrlp_show_hidden = 0
        let g:ctrlp_use_caching = 0
        let g:ctrlp_switch_buffer = 'e'
        let g:ctrlp_root_markers = ['tags', '.tags']
      ";
    }
    {
      plugin = ack-vim;
      config = "
        let g:ackprg = 'ag --nogroup --nocolor --column'
      ";
    }
    vim-commentary
    vim-surround
    vim-repeat
    vim-fugitive
    vim-unimpaired
    vim-terraform
    vim-nix
    vim-go
    vim-graphql
    typescript-vim
    vim-cool
    vim-jsx-pretty
    {
      plugin = tsuquyomi;
      config = "
        let g:tsuquyomi_disable_quickfix = 1
      ";
    }
    {
      plugin = rust-vim;
      config = "
        let g:rustfmt_autosave = 1
      ";
    }
    {
      plugin = pgsql-vim;
      config = "
        let g:sql_type_default = 'pgsql'
      ";
    }
    {
      plugin = jellybeans-vim;
      config = "
        let g:jellybeans_overrides = { 'Special': { 'guifg': 'de5577' }, }
      ";
    }
  ];
  extraConfig = (builtins.readFile ./extra.vim);
}
