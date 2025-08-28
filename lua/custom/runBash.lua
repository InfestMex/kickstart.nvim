-- Global variable to store the job ID. It's prefixed with `_G` to denote it as
-- a global variable within this file's scope.
local running_job_id = nil

-- Define a function to run the current file as a shell script.
-- It will capture the output and open it in a new buffer.
local function run_sh_file_to_log_buffer(file_path_arg)
  -- Check if a job is already running to prevent starting multiple jobs.
  if running_job_id ~= nil then
    print 'A shell script is already running. Press <leader>sk to stop it.'
    return
  end

  -- Get the full path of the current file and escape it for the shell.
  local file_path = file_path_arg or vim.fn.expand '%:p'
  local git_bash_path = vim.fn.fnameescape(run_pos_file)

  -- Create a new scratch buffer to display the log output.
  -- This buffer will not be saved and will have the 'log' filetype.
  local log_buf_id = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_option(log_buf_id, 'buflisted', false)
  vim.api.nvim_buf_set_option(log_buf_id, 'filetype', 'log')
  vim.api.nvim_buf_set_name(log_buf_id, 'run.log')

  -- Split the window vertically and set the newly created log buffer.
  vim.cmd 'vsplit'
  vim.api.nvim_set_current_buf(log_buf_id)

  -- Insert a header into the log buffer to show what's happening.
  local header = string.format('--- Running %s ---\n', vim.fn.expand '%:t')
  -- vim.api.nvim_buf_set_lines(log_buf_id, 0, 0, false, { header })

  -- Asynchronously execute the shell command.
  -- We capture the job ID and store it in our global variable.
  running_job_id = vim.fn.jobstart({ 'bash', git_bash_path }, {
    on_stdout = function(job_id, data, event)
      -- Append the output lines to the log buffer.
      -- The job returns an array of lines, so we can directly use it.
      vim.api.nvim_buf_set_lines(log_buf_id, -1, -1, false, data)
      vim.cmd 'normal! G' -- Scroll to the bottom of the log file
    end,
    on_stderr = function(job_id, data, event)
      -- Append the stderr lines to the log buffer.
      vim.api.nvim_buf_set_lines(log_buf_id, -1, -1, false, data)
      vim.cmd 'normal! G' -- Scroll to the bottom
    end,
    on_exit = function(job_id, code, event)
      -- Append a footer to the log buffer when the job is done.
      local footer = string.format('\n--- Finished with exit code %s ---', code)
      vim.api.nvim_buf_set_lines(log_buf_id, -1, -1, false, { footer })
      vim.cmd 'normal! G' -- Scroll to the bottom
      -- Clear the global job ID variable when the job is complete.
      running_job_id = nil
    end,
  })
end

-- Define a new function to stop the running job.
local function stop_running_job()
  if running_job_id ~= nil then
    -- vim.fn.jobstop sends a SIGINT signal, which is equivalent to Ctrl+C.
    vim.fn.jobstop(running_job_id)
    print 'Sent exit signal to the running script.'
  else
    print 'No script is currently running.'
  end
end

local run_pos_file = vim.fn.stdpath 'config' .. '/custom/files/gk/FBA/POS_sandbox__7102.sh'

-- Create the keymap for running the script.
-- We'll map <leader>sh to the function defined above.
vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgfs', -- The key sequence (e.g., \sh with default leader)
  function()
    run_sh_file_to_log_buffer(run_pos_file)
  end,
  { silent = true, desc = 'Run .sh file and display output in a log buffer' }
)

-- Create the new keymap for stopping the running job.
-- We'll map <leader>sk to the stop function.
vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgfk', -- The key sequence (e.g., \sh with default leader)
  function()
    stop_running_job()
  end,
  { silent = true, desc = 'Stop the currently running shell script' }
)

-- Create the keymap.
-- We'll map <leader>sh to the function defined above.
-- The `silent = true` option prevents the command from being echoed.
-- The `desc` provides a description that can be seen in `:Telescope keymaps`.
vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgfs', -- The key sequence (e.g., \sh with default leader)
  -- Run_sh_file_to_log_buffer(run_pos_file), -- The function to execute

  function()
    local git_bash_path = vim.fn.fnameescape(run_pos_file)

    -- Get the full path of the current file and escape it for the shell.
    -- local escaped_path = vim.fn.shellescape(git_bash_path)

    -- Create a new scratch buffer to display the log output.
    -- This buffer will not be saved and will have the 'log' filetype.
    local log_buf_id = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_option(log_buf_id, 'buflisted', false)
    vim.api.nvim_buf_set_option(log_buf_id, 'filetype', 'log')
    vim.api.nvim_buf_set_name(log_buf_id, 'run.log')

    -- Split the window vertically and set the newly created log buffer.
    vim.cmd 'vsplit'
    vim.api.nvim_set_current_buf(log_buf_id)

    -- Insert a header into the log buffer to show what's happening.
    local header = string.format('--- Running %s ---\n', vim.fn.expand '%:t')

    --ensure log_buf_id and header is not null
    if log_buf_id == nil or header == nil then
      return
    end
    -- vim.api.nvim_buf_set_lines(log_buf_id, 0, 0, false, { header })

    -- Asynchronously execute the shell command.
    -- The output (stdout and stderr) is piped back into a callback function.
    vim.fn.jobstart({ 'bash', git_bash_path }, {
      on_stdout = function(job_id, data, event)
        -- Append the output lines to the log buffer.
        -- The job returns an array of lines, so we can directly use it.
        vim.api.nvim_buf_set_lines(log_buf_id, -1, -1, false, data)
        vim.cmd 'normal! G' -- Scroll to the bottom of the log file
      end,
      on_stderr = function(job_id, data, event)
        -- Append the stderr lines to the log buffer.
        vim.api.nvim_buf_set_lines(log_buf_id, -1, -1, false, data)
        vim.cmd 'normal! G' -- Scroll to the bottom
      end,
      on_exit = function(job_id, code, event)
        -- Append a footer to the log buffer when the job is done.
        local footer = string.format('\n--- Finished with exit code %s ---', code)
        vim.api.nvim_buf_set_lines(log_buf_id, -1, -1, false, { footer })
        vim.cmd 'normal! G' -- Scroll to the bottom
      end,
    })
  end,
  { noremap = true, silent = true, desc = 'Run .sh file and display output in a log buffer' }
)
