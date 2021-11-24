-- Setup language servers
local nvim_lsp = require('lspconfig')

local on_attach = function(bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Enable completion by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local options = { noremap=true, silent=true }

	-- :help vim.lsp.* <- for help
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', options)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', options)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)
	buf_set_keymap('n', '<C-y>', '<cmd>lua vim.lsp.buf.rename()<CR>', options)
end

-- Setup the sumneko lua language server
local sumneko_root_path = ""
local sumneko_binary = ""
USER = vim.fn.expand('$USER')

sumneko_root_path = "/home/" .. USER .. "/.config/nvim/lua-language-server"
sumneko_binary = "/home/" .. USER .. "/.config/nvim/lua-language-server/bin/Linux/lua-language-server"

-- C++ and C language server
nvim_lsp.ccls.setup {
	on_attach = on_attach,
	filetypes = { "cpp", "h", "hpp", "c" },
	root_dir = nvim_lsp.util.root_pattern('.ccls', 'compile_flags.txt', 'compile_commands.json'),
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

-- Haskell language server which is not working
nvim_lsp.hls.setup {}

-- Lua language server
nvim_lsp.sumneko_lua.setup {
    on_attach = on_attach,
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                globals = { 'vim' }
            },
            workspace = {
                library = { [vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true }
            }
        }
    }
}

-- Java language server
function _G.setup()
local root_markers = {'gradlew', 'pom.xml'}
local root_dir = require('jdtls.setup').find_root(root_markers)
local home = os.getenv('HOME')

local capabilities = {
    workspace = {
        configuration = true
    },
    textDocument = {
        completion = {
            completionItem = {
                snippetSupport = true
            }
        }
    }
}

local workspace_dir = home .. "/.workspace/" .. vim.fn.fnamemodify(root_dir, ':p:h:t')
local config = {
    cmd = {
        'java',
        '-noverify',
        '-Xms1G',
        '-XX:+UseG1GC',
        '-XX:+UseStringDeduplication',
        '--enable-preview',
        '-javaagent:/usr/share/java/lombok/lombok.jar',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', '/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
        '-configuration', '/usr/share/java/jdtls/config_linux',
        '-data', workspace_dir
    },

    flags = {
        allow_incremental_sync = true,
    },

    --capabilities = capabilities,
    on_attach = on_attach,

    root_dir = root_dir,

    settings = {
        configuration = {
            runtimes = {
            }
        }
    }
}

config.on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = config.settings })
end

require('jdtls').start_or_attach(config)

-- Telescope code action list for java
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local action_state = require('telescope.actions.state')

require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
    local opts = {}
    pickers.new(opts, {
        prompt_title = prompt,
        finder = finders.new_table {
            results = items,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = label_fn(entry),
                    ordinal = label_fn(entry),
                }
            end,
        },
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)
                cb(selection.value)
            end)

            return true
        end,
    }):find()
end

end

vim.api.nvim_command('augroup jdtls_lsp')
vim.api.nvim_command('autocmd!')
vim.api.nvim_command('autocmd FileType java lua setup()')
vim.api.nvim_command('augroup END')

-- diagnostics settings
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
	update_in_insert = false,
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true;
})

local popup_opts = { border = 'rounded', max_width = 80 }
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, popup_opts)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, popup_opts)

-- colors of types of diagnostic
require('lsp-colors').setup({
	Error = "#db4b4b",
	Warning = "#e0af68",
	Information = "#0db9d7",
	Hint = "#00000"
})

