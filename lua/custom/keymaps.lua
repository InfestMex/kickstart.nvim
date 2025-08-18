local wk = require 'which-key'
vim.defer_fn(function()
  -- Define menu groups
  wk.add {
    { '<leader>p', group = '[P]roject' },
    { '<leader>po', group = '[P]roject [O]racle' },
    { '<leader>pv', group = '[P]roject [V]ictor' },
    { '<leader>pg', group = '[P]roject [G]k' },
    { '<leader>r', group = '[R]un' },
    { '<leader>ro', group = '[R]un [O]racle' },
    { '<leader>rod', group = '[R]un [O]racle [D]ata base' },
    { '<leader>rox', group = '[R]un [O]racle [X]store' },
    { '<leader>rg', group = '[R]un [G]K' },
    { '<leader>rgf', group = '[R]un [G]K [F]BA' },
    { '<leader>rgg', group = '[R]un [G]K [G]eneral' },
    { '<leader>rgp', group = '[R]un [G]K [P]PG' },
  }
end, 0)

-- My custom keymaps
-- Move row up/down
-- NOTE: K mapping overlap with show method definition
-- vim.keymap.set('n', 'K', ':m .-2<CR>==', { noremap = true, silent = true, desc = 'Move line up and reindent' })
-- vim.keymap.set('n', 'J', ':m .+1<CR>==', { noremap = true, silent = true, desc = 'Move line down and reindent' })

-- Go to project X
vim.keymap.set('n', '<leader>pvc', ':cd D:/Containers<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [V]ictor [C]ontainers',
})
vim.keymap.set('n', '<leader>pvw', ':cd ~/AppData/Local/nvim<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [V]ictor [W]indows Neovim',
})
vim.keymap.set('n', '<leader>pvl', ':cd ~/.config/nvim<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [V]ictor [L]inux Neovim',
})
vim.keymap.set('n', '<leader>poc', ':cd /home/viaguila/dev/current/git/xstore<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [O]racle [C]urrent Xstore',
})
vim.keymap.set('n', '<leader>poq', ':cd /home/viaguila/dev/25.0/git/xstore<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [O]racle [q]v25 Xstore',
})
vim.keymap.set('n', '<leader>pow', ':cd /home/viaguila/dev/24.0/git/xstore<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [O]racle [w]v24 Xstore',
})
vim.keymap.set('n', '<leader>poe', ':cd /home/viaguila/dev/23.0<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [O]racle [e]v23 Xstore',
})
vim.keymap.set('n', '<leader>por', ':cd /home/viaguila/dev/22.0<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [O]racle [r]v22 Xstore',
})
vim.keymap.set('n', '<leader>pgfp', ':cd C:\\DEV_HOME\\FBA\\ws-pos\\git<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [G]K [F]BA [P]OS',
})
vim.keymap.set('n', '<leader>pgfc', ':cd C:\\DEV_HOME\\FBA\\ws-cen\\git<CR>', {
  noremap = true,
  silent = true,
  desc = '[P]roject [G]K [F]BA [C]entral',
})

-- Run GK
vim.keymap.set('n', '<Leader>rgfm', function()
  -- Get the SHARED_HOME environment variable
  local shared_home = os.getenv 'SHARED_HOME'

  -- Construct the full path using the environment variable and correct backslashes for Lua
  local script_full_path = shared_home .. '/FBA/start.sh'

  local git_bash_path = string.gsub(script_full_path, 'C:', '/c')

  -- Construct the command to be executed by bash
  local command_to_run = 'source ' .. git_bash_path .. '; exec bash'

  -- Ensure bash terminal configuration
  vim.cmd ':setlocal shellcmdflag=-c'

  -- vertical split
  vim.cmd 'vsp'

  -- Construct and execute the command
  -- terminal "source /c/DEV_HOME/FBA/start.sh; exec bash"
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd(':terminal "' .. command_to_run .. '"')
end, { desc = 'FBA - Start MVN Shell', noremap = true, silent = true })
vim.keymap.set('n', '<Leader>rgfp', function()
  -- Get the SHARED_HOME environment variable
  local shared_home = os.getenv 'SHARED_HOME'

  -- Construct the full path using the environment variable and correct backslashes for Lua
  local script_full_path = shared_home .. '/FBA/POS_sandbox__7102.sh'

  local git_bash_path = string.gsub(script_full_path, 'C:', '/c')

  -- Construct the command to be executed by bash
  local command_to_run = git_bash_path

  -- Ensure bash terminal configuration
  vim.cmd ':setlocal shellcmdflag=-c'

  -- Construct and execute the command
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd(':terminal "' .. command_to_run .. '"')
end, { desc = 'FBA - Run GK POS', noremap = true, silent = true })

vim.keymap.set('n', '<Leader>rggp', function()
  -- Ensure bash terminal configuration
  vim.cmd ':setlocal shellcmdflag=-c'
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd ':terminal "net start "postgresql-x64-16""'
end, { desc = '[R]un [G]K [G]eneral Start [P]ostgresql service', noremap = true, silent = true })

vim.keymap.set('n', '<leader>rodo', function()
  vim.cmd 'enew' -- Create a new empty buffer
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd 'term /home/viaguila/dev/current/git/xstore/gradlew -i --project-dir /home/viaguila/dev/current/git/xstore :xst_pos:oraclePdbBuildLab' -- Run the command in a terminal
end, {
  noremap = true,
  silent = true,
  desc = '[R]un [O]racle [D]ataBase [O]racle PDB',
})
vim.keymap.set('n', '<leader>rods', function()
  vim.cmd 'enew' -- Create a new empty buffer
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd 'term /home/viaguila/dev/current/git/xstore/gradlew -i --project-dir /home/viaguila/dev/current/git/xstore :xst_pos:mssqlBuildLab' -- Run the command in a terminal
end, {
  noremap = true,
  silent = true,
  desc = '[R]un [O]racle [D]ataBase [M]ssql',
})

vim.keymap.set('n', '<leader>roxc', function()
  vim.cmd 'enew' -- Create a new empty buffer
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd 'term /home/viaguila/dev/current/git/xstore/gradlew -i --project-dir /home/viaguila/dev/current/git/xstore :xstore-client:ojetServe' -- Run the command in a terminal
end, {
  noremap = true,
  silent = true,
  desc = '[R]un [O]racle [X]store [C]lient',
})

vim.keymap.set('n', '<leader>roxbc', function()
  vim.cmd 'enew' -- Create a new empty buffer
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd 'term /home/viaguila/dev/current/git/xstore/gradlew -i --project-dir /home/viaguila/dev/current/git/xstore :countrypack:build' -- Run the command in a terminal
end, {
  noremap = true,
  silent = true,
  desc = '[R]un [O]racle [X]store [B]uild [C]ountrypack',
})

vim.keymap.set('n', '<leader>yf', ':let @+=expand("%:t")<CR>', { noremap = true, silent = true, desc = 'Copy current file name' })
vim.keymap.set('n', '<Leader>rgpm', function()
  -- Get the SHARED_HOME environment variable
  local shared_home = os.getenv 'SHARED_HOME'

  -- Construct the full path using the environment variable and correct backslashes for Lua
  local script_full_path = shared_home .. '\\CMX\\start.bat'

  -- Escape the path for the shell using vim.fn.fnameescape()
  local escaped_path = vim.fn.fnameescape(script_full_path)

  -- Construct and execute the command
  vim.cmd(':terminal "' .. escaped_path .. '"')
end, { desc = 'CMX - Start MVN Shell', noremap = true, silent = true })
vim.keymap.set('n', '<Leader>rgpp', function()
  -- Get the SHARED_HOME environment variable
  local shared_home = os.getenv 'SHARED_HOME'

  -- Construct the full path using the environment variable and correct backslashes for Lua
  local script_full_path = shared_home .. '\\CMX\\POS_sandbox__0037.bat'

  -- Escape the path for the shell using vim.fn.fnameescape()
  local escaped_path = vim.fn.fnameescape(script_full_path)

  -- Construct and execute the command
  vim.cmd('silent !start cmd /k "' .. escaped_path .. '"')
end, { desc = 'CMX - Run GK POS', noremap = true, silent = true })

-- Java specific keymaps

function get_test_runner(test_name, debug)
  if not test_name or test_name == '' then
    vim.notify('Test name is missing!', vim.log.levels.WARN, { title = 'Test Runner' })
    return nil -- or an empty string "", or a default command
  end

  -- TODO: Debug logic is missing

  -- Define the program and its arguments as a list (table)
  local executable = './gradlew'
  local args = {
    'test',
    '--info',
    '--tests',
    test_name,
  }

  -- Let Neovim escape each part correctly for the current shell
  local escaped_executable = vim.fn.fnameescape(executable)
  local escaped_args = {}
  for _, arg in ipairs(args) do
    table.insert(escaped_args, vim.fn.shellescape(arg))
  end

  -- Join them into a final command string
  local command = table.concat(vim.list_extend({ escaped_executable }, escaped_args), ' ')

  return command
end

function run_java_test_method(debug)
  local utils = require 'utils'
  local test_name = utils.get_java_full_method_name '.'
  local test_runner = get_test_runner(test_name, debug)
  if test_runner then
    -- Ensure bash terminal configuration
    vim.cmd ':setlocal shellcmdflag=-c'

    vim.cmd 'enew' -- Create a new empty buffer
    vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer

    vim.notify('Command to use: ' .. test_runner, vim.log.levels.WARN, { title = 'Java test' })

    vim.cmd(':terminal ' .. test_runner)
  end
end

function run_java_test_class(debug)
  local utils = require 'utils'
  local test_name = utils.get_java_full_class_name()
  local test_runner = get_test_runner(test_name, debug)
  if test_runner then
    -- Ensure bash terminal configuration
    vim.cmd ':setlocal shellcmdflag=-c'

    vim.cmd 'enew' -- Create a new empty buffer
    vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer

    vim.notify('Command to use: ' .. test_runner, vim.log.levels.WARN, { title = 'Java test' })

    vim.cmd(':terminal ' .. test_runner)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    -- Keymap to run the current JUnit test class
    vim.keymap.set('n', '<leader>jtc', function()
      run_java_test_class(false)
    end, { desc = '[J]ava Run [T]est [C]lass', buffer = true })

    -- Keymap to run the current JUnit test method
    -- TODO: not working
    vim.keymap.set('n', '<leader>jtm', function()
      run_java_test_method(false)
    end, { desc = '[J]ava Run [T]est [M]ethod', buffer = true })

    -- Keymap to debug the current JUnit test method
    -- TODO: not working
    vim.keymap.set('n', '<leader>jdm', function()
      run_java_test_method(true) -- Pass 'true' for debug mode
    end, { desc = '[J]ava [D]ebug Test [M]ethod', buffer = true })
  end,
})
