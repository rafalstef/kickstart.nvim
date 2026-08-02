-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Iterate over all Lua files in the plugins directory and load them
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir, { follow = true }) do
  if (type == 'file' or type == 'link') and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('custom.plugins.' .. module)
  end
end

-- Center screen when jumping
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    local line = mark[1]
    local ft = vim.bo.filetype
    if line > 0 and line <= lcount and vim.fn.index({ 'commit', 'gitrebase', 'xxd' }, ft) == -1 and not vim.o.diff then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.keymap.set('n', '<leader>pa', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
  print('file:', path)
end, { desc = 'Copy absolute path' })

vim.keymap.set('n', '<leader>pr', function()
  local path = vim.fn.expand '%:.'
  vim.fn.setreg('+', path)
  print('file:', path)
end, { desc = 'Copy relative path' })

do
  vim.pack.add { 'https://github.com/wansmer/treesj' }
  require('treesj').setup { use_default_keymaps = false, max_join_length = 180 }

  vim.keymap.set('n', '<leader>m', require('treesj').toggle, { desc = 'Split/Join block of code' })

  vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator' }

  vim.pack.add { 'https://github.com/mikavilpas/yazi.nvim' }
  vim.keymap.set('n', '<leader>-', function() require('yazi').yazi() end, {desc = 'Browse Files'})
  vim.g.loaded_netrwPlugin = 1
  vim.api.nvim_create_autocmd('UIEnter', { callback = function() require('yazi').setup { open_for_directories = true } end })

  vim.pack.add { 'https://github.com/kdheepak/lazygit.nvim' }
  vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })

  vim.pack.add { 'https://github.com/nvim-pack/nvim-spectre' }
  vim.keymap.set('n', '<leader>Sg', '<cmd>lua require("spectre").toggle()<CR>', { desc = 'Toggle Spectre' })
  vim.keymap.set('n', '<leader>Sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = 'Search current word' })
  vim.keymap.set('v', '<leader>Sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = 'Search current word' })
  vim.keymap.set('n', '<leader>Sf', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = 'Search on current file' })
end

do
  vim.pack.add { 'https://github.com/pmizio/typescript-tools.nvim' }
  require('typescript-tools').setup {
    expose_as_code_action = 'all',
    tsserver_plugins = { 'styled-components' },
    jsx_close_tag = {
      enable = true,
      filetypes = { 'javascriptreact', 'typescriptreact' },
    },
  }
end
