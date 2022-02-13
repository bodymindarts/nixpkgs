{ pkgs }:

let
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
      rev = "6149088454abb0e3e4a49c76a4f3fac7f0154e5a";
      sha256 = "sha256-Hm7nHn803ahgthxjLNi+5ra/vyDiM7ZPi2CifIfmaUM=";
    };
  };
in {
  enable = true;
  viAlias = true;
  vimAlias = true;
  plugins = with pkgs.vimPlugins; [
    copilot
    { plugin = ale;
      config = "
        let g:ale_linters = {'javascript': [], 'typescript': ['tsserver', 'eslint'], 'typescript.tsx': ['tsserver', 'eslint'], 'rust': ['rls'] }
        let g:ale_fixers = {'javascript': [], 'typescript': ['prettier'], 'typescript.tsx': ['prettier'], 'rust': ['rustfmt'] }
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
      config = "let g:ackprg = 'ag --nogroup --nocolor --column'";
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
      config = "let g:tsuquyomi_disable_quickfix = 1";
    }
    {
      plugin = rust-vim;
      config = "let g:rustfmt_autosave = 1";
    }
    {
      plugin = jellybeans-vim;
      config = "let g:jellybeans_overrides = { 'Special': { 'guifg': 'de5577' }, }";
    }
  ];
  extraConfig = (builtins.readFile ./extra.vim);
}
