{ pkgs }:
{
  enable = true;
  viAlias = true;
  vimAlias = true;
  plugins = with pkgs.vimPlugins; [
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
    nvim-lspconfig
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
