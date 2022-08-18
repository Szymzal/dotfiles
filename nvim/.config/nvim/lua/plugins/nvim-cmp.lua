vim.opt.completeopt = { "menu", "noselect" }

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<C-p>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Esc>'] = cmp.mapping.close(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4)
    }),
    window = {
        border = {'┌', '─', '┐', '│', '┘', '─', '└', '│'},
        completion = {
            winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder'
        }
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'nvim_lua' },
        { name = 'buffer' },
        { name = 'nvim_lsp_signature_help' }
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
                nvim_lsp = "[LSP]",
                ultisnips = "[Snip]",
                nvim_lua = "[Lua]",
                buffer = "[Buffer]"
            })
        })
    }
})

vim.cmd [[ hi Pmenu ctermbg=10 ctermfg=15 guibg=#2D2D30 guifg=#BBBBBB ]]
vim.cmd [[ hi CmpPmenu ctermbg=10 ctermfg=15 guibg=#2D2D30 guifg=#BBBBBB ]]
vim.cmd [[ hi link CmpItemMenu CmpPmenu ]]
vim.cmd [[ hi CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080 ]]
vim.cmd [[ hi CmpItemAbbrMatch guibg=NONE guifg=#569CD6 ]]
vim.cmd [[ hi CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6 ]]
vim.cmd [[ hi CmpItemKindVariable guibg=NONE guifg=#9CDCFE ]]
vim.cmd [[ hi CmpItemKindInterface guibg=NONE guifg=#9CDCFE ]]
vim.cmd [[ hi CmpItemKindText guibg=NONE guifg=#9CDCFE ]]
vim.cmd [[ hi CmpItemKindFunction guibg=NONE guifg=#C586C0 ]]
vim.cmd [[ hi CmpItemKindMethod guibg=NONE guifg=#C586C0 ]]
vim.cmd [[ hi CmpItemKindKeyword guibg=NONE guifg=#D4D4D4 ]]
vim.cmd [[ hi CmpItemKindProperty guibg=NONE guifg=#D4D4D4 ]]
vim.cmd [[ hi CmpItemKindUnit guibg=NONE guifg=#D4D4D4 ]]
vim.cmd [[ hi CmpItemAbbrDefault ctermbg=10 ctermfg=15 guibg=#2D2D30 guifg=#BBBBBB ]]
vim.cmd [[ hi CmpItemMenuDefault ctermbg=10 ctermfg=15 guibg=#2D2D30 guifg=#BBBBBB ]]
