local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.cmake = {
  default_config = {
    cmd = {"cmake-language-server"};
    filetypes = {"cmake"};
    root_dir = util.root_pattern(".git", "compile_commands.json", "build");
    init_options = {
      buildDirectory = "build",
    }
  };
  docs = {
    description = [[
https://github.com/regen100/cmake-language-server

CMake LSP Implementation
]];
    default_config = {
      root_dir = [[root_pattern(".git", "compile_commands.json", "build")]];
    };
  };
};

-- vim:et ts=2 sw=2
