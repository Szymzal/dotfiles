local cfg = {
    bind = true,
    doc_lines = 10,
    max_height = 12,
    max_width = 80,
    wrap = true,
    floating_window = true,
    floating_window_above_cur_line = true,
    floating_window_off_x = 1,
    floating_window_off_y = 0,
    close_timeout = 4000,
    fix_pos = false,
    hint_enable = false,
    handler_opts = {
        border = "none"
    },
    always_trigger = false,
    auto_close_after = nil,
    zindex = 200,
    padding = '',
    transparency = nil
}

require("lsp_signature").setup(cfg)
