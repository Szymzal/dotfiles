local lsp = require('lspconfig')
local opts = { buffer=true, noremap=true, silent=true }
local keymap = vim.keymap.set

local function on_attach()
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

lsp.rust_analyzer.setup {
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importEnforceGranularity = true,
                importGranularity = "module",
                importPrefix = "crate"
            },
            cargo = {
                allFeatures = true
            },
            checkOnSave = {
                command = "clippy"
            },
            inlayHints = {
                lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true
                },
            },
            procMacro = {
                enable = true
            }
        }
    },
    capabilities = capabilities
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
