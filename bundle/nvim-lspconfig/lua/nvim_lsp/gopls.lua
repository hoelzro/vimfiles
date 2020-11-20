local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local function find_root_dir(...)
  local root_dir = util.root_pattern('go.mod', '.git')(...)
  if not root_dir then
    local filename = ...
    local final_slash = string.find(string.reverse(filename), '/')
    if final_slash then
      final_slash = #filename - final_slash
      local dirname = string.sub(filename, 1, final_slash + 1)
      return dirname
    else
      return './'
    end
  end
  return root_dir
end

configs.gopls = {
  default_config = {
    cmd = {"gopls"};
    filetypes = {"go", "gomod"};
    root_dir = find_root_dir;
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]];
    default_config = {
      root_dir = [[root_pattern("go.mod", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
