local configs = require 'nvim_lsp/configs'

configs.pyls = {
  default_config = {
    cmd = {"pyls"};
    filetypes = {"python"};
    root_dir = function(fname)
      return vim.fn.getcwd()
    end;
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/palantir/python-language-server/develop/vscode-client/package.json";
    description = [[
https://github.com/palantir/python-language-server

`python-language-server`, a language server for Python.
    ]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};
-- vim:et ts=2 sw=2
