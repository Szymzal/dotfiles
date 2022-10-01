local M = {};

local lsp = require('lspconfig')
local opts = { buffer=true, noremap=true, silent=true }
local keymap = vim.keymap.set

M.on_attach = function()
    keymap('n', 'K', vim.lsp.buf.hover, opts)
    keymap('n', 'fw', vim.diagnostic.open_float, opts)
    keymap('n', 'gd', vim.lsp.buf.definition, opts) -- <c-t> to return back
    keymap('n', 'gT', vim.lsp.buf.type_definition, opts)
    keymap('n', 'gi', vim.lsp.buf.implementation, opts)
    keymap('n', 'cd', vim.lsp.buf.code_action, opts)
    keymap('n', 'Td', "<cmd>Telescope diagnostics<CR>", opts)
    keymap('n', '<leader>r', vim.lsp.buf.rename, opts)
    -- to check diagnostics use Enter key
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.tsserver.setup {
    on_attach = M.on_attach,
    capabilities = capabilities
}

lsp.sumneko_lua.setup {
    on_attach = M.on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

lsp.html.setup {
    on_attach = M.on_attach,
    capabilities = capabilities,
    filetypes = { "html", "css", "vue" },
    embedded_languages = {
        css = true
    },
    proviteFormatter = false
}

lsp.bashls.setup {
    on_attach = M.on_attach,
    capabilities = capabilities,
}

local fn = vim.fn

fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
fn.sign_define("DiagnosticSignInformation", { text = " ", texthl = "DiagnosticSignInformation" })
fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
    underline = true,
    signs = true
})

return M
