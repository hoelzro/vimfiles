local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local server_name = "efm"
local bin_name = "efm-langserver"


configs[server_name] = {
  default_config = {
    cmd = {bin_name};
    root_dir = util.root_pattern(".git");
  };

  docs = {
    description = [[
https://github.com/mattn/efm-langserver

General purpose Language Server that can use specified error message format generated from specified command.
]];
    default_config = {
      root_dir = [[root_pattern(".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
