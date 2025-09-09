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

function OpenTerminalWithEnv(env_vars)
  return function()
    vim.notify('function start...' .. env_vars, vim.log.levels.WARN, { title = 'OpenTerminalWithEnv' })
    local original_values = {}

    -- Set new environment variables and save original values
    for key, value in pairs(env_vars) do
      original_values[key] = vim.env[key]
      vim.env[key] = value
    end

    vim.notify('env vars = ' .. env_vars, vim.log.levels.WARN, { title = 'OpenTerminalWithEnv' })

    -- Open a new terminal
    vim.cmd 'terminal'

    -- Create a one-shot autocommand to restore the environment on terminal close
    vim.api.nvim_create_autocmd('TermClose', {
      buffer = 0, -- 0 means the current buffer
      once = true,
      callback = function()
        for key, value in pairs(original_values) do
          vim.env[key] = value
        end
      end,
    })
  end
end

vim.keymap.set('n', '<Leader>rgfm', function()
  -- TODO: move this in to a lua logic

  -- Ensure bash terminal configuration
  vim.cmd 'setlocal shellcmdflag=-c'

  -- vertical split
  vim.cmd 'vsp'

  -- call the terminal with Vars
  OpenTerminalWithEnv {
    SHARED_HOME = '/c/DEV_HOME',

    NVIM_BIN = '/c/DEV_HOME/TOOLS/neovim/nvim-win64/bin',

    JAVA_HOME = '$SHARED_HOME/TOOLS/java/1.8.0_111',
    JAVA_1_6_HOME = '$JAVA_HOME',
    JAVA_1_8_HOME = '$JAVA_HOME',
    JAVA_1_11_HOME = '$JAVA_HOME',
    JAVA_11_HOME = '$JAVA_1_11_HOME',

    M2_HOME = '$SHARED_HOME/TOOLS/mvn/apache-maven-3.6.3',
    MAVEN_HOME = '$M2_HOME',
    MAVEN_OPTS = '-Xmx3g -XX:MaxPermSize=1g -Dmaven.multiModuleProjectDirectory',

    PATH = '$LOCAL_HOME/scripts:$SHARED_HOME/scripts:$M2_HOME/bin:$PATH',
  }

  vim.cmd 'terminal'
end, { desc = 'FBA - Start MVN Shell', noremap = true, silent = true })

vim.keymap.set('n', '<Leader>rgfss', function()
  local config_path = vim.fn.stdpath 'config'
  -- vim.notify('Config folder = ' .. config_path, vim.log.levels.WARN, { title = 'GK commands' })

  -- Construct the full path using the environment variable and correct backslashes for Lua
  local script_full_path = config_path .. '/custom/files/gk/FBA/fix_servers_war_sdc.bat'
  -- vim.notify('Full path = ' .. script_full_path, vim.log.levels.WARN, { title = 'GK commands' })

  local git_bash_path = vim.fn.fnameescape(script_full_path)
  -- vim.notify('Git-bash path = ' .. git_bash_path, vim.log.levels.WARN, { title = 'GK commands' })

  if vim.fn.filereadable(git_bash_path) ~= 1 then
    vim.notify('File do not exist path = ' .. git_bash_path, vim.log.levels.ERROR, { title = 'GK commands' })
  end

  -- Construct the command to be executed by bash
  local command_to_run = git_bash_path
  vim.notify('Command to run = ' .. command_to_run, vim.log.levels.WARN, { title = 'GK commands' })

  -- Ensure bash terminal configuration
  vim.cmd 'setlocal shellcmdflag=-c'

  -- vertical split
  vim.cmd 'vsp'

  -- Construct and execute the command
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd('terminal ' .. command_to_run)
end, { desc = 'FBA - Fix servers wars (SDC only)', noremap = true, silent = true })

vim.keymap.set('n', '<Leader>rggp', function()
  -- vertical split
  vim.cmd 'vsp'

  -- Ensure bash terminal configuration
  vim.cmd 'setlocal shellcmdflag=-c'
  -- vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd 'terminal "net start "postgresql-x64-16""'
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

vim.keymap.set('n', '<leader>rodum', function()
  local config_path = vim.fn.stdpath 'config'
  -- vim.notify('Config folder = ' .. config_path, vim.log.levels.WARN, { title = 'GK commands' })

  -- Construct the full path using the environment variable and correct backslashes for Lua
  local script_full_path = config_path .. '/custom/files/oracle/run_upgrade_mssql.sh'
  -- vim.notify('Full path = ' .. script_full_path, vim.log.levels.WARN, { title = 'GK commands' })

  local git_bash_path = vim.fn.fnameescape(script_full_path)
  -- vim.notify('Git-bash path = ' .. git_bash_path, vim.log.levels.WARN, { title = 'GK commands' })

  if vim.fn.filereadable(git_bash_path) ~= 1 then
    vim.notify('File do not exist path = ' .. git_bash_path, vim.log.levels.ERROR, { title = 'Oracle commands' })
  end

  -- Construct the command to be executed by bash
  local command_to_run = git_bash_path
  vim.notify('Command to run = ' .. command_to_run, vim.log.levels.WARN, { title = 'Oracle commands' })

  -- Ensure bash terminal configuration
  vim.cmd 'setlocal shellcmdflag=-c'

  -- vertical split
  vim.cmd 'vsp'

  -- Construct and execute the command
  -- vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd('terminal ' .. command_to_run)
end, {
  noremap = true,
  silent = true,
  desc = '[R]un [O]racle [D]ataBase [U]pgrade-script [M]ssql',
})

vim.keymap.set('n', '<leader>roduo', function()
  local config_path = vim.fn.stdpath 'config'
  -- vim.notify('Config folder = ' .. config_path, vim.log.levels.WARN, { title = 'GK commands' })

  -- Construct the full path using the environment variable and correct backslashes for Lua
  local script_full_path = config_path .. '/custom/files/oracle/run_upgrade_oracle.sh'
  -- vim.notify('Full path = ' .. script_full_path, vim.log.levels.WARN, { title = 'GK commands' })

  local git_bash_path = vim.fn.fnameescape(script_full_path)
  -- vim.notify('Git-bash path = ' .. git_bash_path, vim.log.levels.WARN, { title = 'GK commands' })

  if vim.fn.filereadable(git_bash_path) ~= 1 then
    vim.notify('File do not exist path = ' .. git_bash_path, vim.log.levels.ERROR, { title = 'Oracle commands' })
  end

  -- Construct the command to be executed by bash
  local command_to_run = git_bash_path
  vim.notify('Command to run = ' .. command_to_run, vim.log.levels.WARN, { title = 'Oracle commands' })

  -- Ensure bash terminal configuration
  vim.cmd 'setlocal shellcmdflag=-c'

  -- vertical split
  vim.cmd 'vsp'

  -- Construct and execute the command
  vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer
  vim.cmd('terminal ' .. command_to_run)
end, {
  noremap = true,
  silent = true,
  desc = '[R]un [O]racle [D]ataBase [U]pgrade-script [O]racle',
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

function get_test_runner(project_name, test_name, debug)
  if not test_name or test_name == '' then
    vim.notify('Test name is missing!', vim.log.levels.WARN, { title = 'Test Runner' })
    return nil -- or an empty string "", or a default command
  end

  -- TODO: Debug logic is missing

  -- Define the program and its arguments as a list (table)
  local executable = './gradlew'
  local args = {
    project_name .. ':test',
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
  local project_name = utils.get_java_project_name()
  local test_runner = get_test_runner(project_name, test_name, debug)
  if test_runner then
    -- vertical split
    vim.cmd 'vsp'

    -- Ensure bash terminal configuration
    vim.cmd ':setlocal shellcmdflag=-c'

    vim.cmd 'enew' -- Create a new empty buffer
    -- vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer

    vim.notify('Command to use: ' .. test_runner, vim.log.levels.WARN, { title = 'Java test' })

    vim.cmd(':terminal ' .. test_runner)
  end
end

function run_java_test_class(debug)
  local utils = require 'utils'
  local test_name = utils.get_java_full_class_name()
  local project_name = utils.get_java_project_name()
  local test_runner = get_test_runner(project_name, test_name, debug)
  if test_runner then
    -- vertical split
    vim.cmd 'vsp'

    -- Ensure bash terminal configuration
    vim.cmd ':setlocal shellcmdflag=-c'

    vim.cmd 'enew' -- Create a new empty buffer
    -- vim.cmd 'setlocal buftype=nofile bufhidden=wipe noswapfile' -- Make it a scratch buffer

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
