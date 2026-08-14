vim.notify 'custom.log_files loaded'

vim.opt.autoread = true

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*.log',
  command = 'checktime',
})
