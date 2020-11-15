local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.rust_analyzer = {
  default_config = {
    cmd = {"rust-analyzer"};
    filetypes = {"rust"};
    root_dir = util.root_pattern("Cargo.toml", "rust-project.json");
    settings = {
      ["rust-analyzer"] = {}
    }
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/rust-analyzer/rust-analyzer/master/editors/code/package.json";
    description = [[
https://github.com/rust-analyzer/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust

See [docs](https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user#settings) for extra settings.
    ]];
    default_config = {
      root_dir = [[root_pattern("Cargo.toml", "rust-project.json")]];
    };
  };
};
-- vim:et ts=2 sw=2
