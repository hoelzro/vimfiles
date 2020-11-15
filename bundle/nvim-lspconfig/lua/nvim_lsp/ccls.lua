local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.ccls = {
  default_config = {
    cmd = {"ccls"};
    filetypes = {"c", "cpp", "objc", "objcpp"};
    root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git");
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/MaskRay/vscode-ccls/master/package.json";
    description = [[
https://github.com/MaskRay/ccls/wiki

ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.
For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html).
]];
    default_config = {
      root_dir = [[root_pattern("compile_commands.json", "compile_flags.txt", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
