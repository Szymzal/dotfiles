local lspconfig = require("plugins/lspconfig")

local opts = {
  tools = {
    executor = require("rust-tools/executors").termopen,
    on_initialized = nil,
    reload_workspace_from_cargo_toml = true,
    inlay_hints = {
      auto = true,
      only_current_line = false,
      show_parameter_hints = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
      max_len_align = false,
      max_len_align_padding = 1,
      right_align = false,
      right_align_padding = 7,
      highlight = "Comment"
    },
    hover_actions = {
      border = {
        {}
      },
      auto_focus = false
    },
  },
  server = {
    standalone = true,
    on_attach = lspconfig.on_attach
  }
}

require('rust-tools').setup(opts)
