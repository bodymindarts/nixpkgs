{ pkgs }:

let
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
    {
      plugin = rust-vim;
      config = "let g:rustfmt_autosave = 1";
    }
    {
      plugin = nvim-lspconfig;
      config = (builtins.readFile ./lspconfig.vim);
    }
    {
      plugin = LanguageClient-neovim;
      config = "
      let g:LanguageClient_autoStart = 1

      set completefunc=LanguageClient#complete

      nnoremap <silent> gd :call LanguageClient_textDocument_definition()<enter>

      let g:LanguageClient_serverCommands = {
      \\ 'rust': ['rustup', 'run', 'stable', 'rls'],
      \\ }
      ";
    }
    {
      plugin = jellybeans-vim;
      config = "let g:jellybeans_overrides = { 'Special': { 'guifg': 'de5577' }, }";
    }
  ];
  extraConfig = (builtins.readFile ./extra.vim);
}
