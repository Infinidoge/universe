{
  programs.nixvim.lsp.servers.nixd = {
    enable = true;
    config = {
      settings.nixd.formatting.command = [ "nixfmt" ];
    };
  };
}
