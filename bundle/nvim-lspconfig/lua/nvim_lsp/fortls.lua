local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.fortls = {
  default_config = {
    cmd = {"fortls"};
    filetypes = {"fortran"};
    root_dir = util.root_pattern(".fortls");
    settings = {
      nthreads = 1,
    };
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/hansec/vscode-fortran-ls/master/package.json";
    description = [[
https://github.com/hansec/fortran-language-server

Fortran Language Server for the Language Server Protocol
    ]];
    default_config = {
      root_dir = [[root_pattern(".fortls")]];
    };
  };
};
-- vim:et ts=2 sw=2
