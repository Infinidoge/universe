{
  programs.nixvim.lsp.servers.nil_ls = {
    enable = true;
    config = {
      settings.nil.formatting.command = [ "nixfmt" ];
    };
  };
}
