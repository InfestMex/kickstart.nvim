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

  -- Get the full path of the current file.
  -- DO NOT use fnameescape here, because it adds Windows escapes (\) that break Bash.
  local git_bash_path = file_path_arg or vim.fn.expand '%:p'

  -- Create a new scratch buffer to display the log output.
  -- This buffer will not be saved and will have the 'log' filetype.
  local log_buf_id = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_option(log_buf_id, 'buflisted', false)
  vim.api.nvim_buf_set_option(log_buf_id, 'filetype', 'log')
  -- vim.api.nvim_buf_set_name(log_buf_id, '*run.log*')

  -- Split the window vertically and set the newly created log buffer.
  vim.cmd 'vsplit'
  vim.api.nvim_set_current_buf(log_buf_id)

  -- Insert a header into the log buffer to show what's happening.
  local header = string.format('--- Running %s ---\n', vim.fn.expand '%:t')
  -- vim.api.nvim_buf_set_lines(log_buf_id, 0, 0, false, { header })

  -- Helper function to sanitize lines and remove hidden carriage returns/newlines
  local function append_to_buffer(job_id, data)
    if data then
      local clean_lines = {}
      for _, line in ipairs(data) do
        -- Remove trailing \r (carriage returns) and split any unexpected literal internal newlines
        local clean_line = string.gsub(line, '\r$', '')

        -- If a line somehow still contains a newline character, split it into separate table items
        for split_line in string.gmatch(clean_line, '[^\n]+') do
          table.insert(clean_lines, split_line)
        end

        -- Handle edge case where a line was entirely empty
        if clean_line == '' then
          table.insert(clean_lines, '')
        end
      end

      -- Safely write to buffer only if we extracted valid lines
      if #clean_lines > 0 then
        vim.api.nvim_buf_set_lines(log_buf_id, -1, -1, false, clean_lines)
      end
    end
  end

  -- Asynchronously execute the shell command.
  running_job_id = vim.fn.jobstart({ 'C:\\Program Files\\Git\\bin\\bash.exe', git_bash_path }, {
    on_stdout = append_to_buffer,
    on_stderr = append_to_buffer,
    on_exit = function(job_id, code, event)
      -- Optional: uncomment the lines below if you actually want to see the window close.
      -- Right now, your code deletes it immediately, meaning you won't see the output logs.
      -- vim.api.nvim_buf_delete(log_buf_id, { force = true })
      running_job_id = nil
      print('Bash process finished with exit code: ' .. code)
    end,
  })

  if running_job_id ~= nil then
    print('Bash process start with job id:' .. running_job_id)
  end
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

-- Create the keymap for running the script.
-- We'll map <leader>sh to the function defined above.
vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgfp', -- The key sequence (e.g., \sh with default leader)
  function()
    local run_pos_file = vim.fn.stdpath 'config' .. '/custom/files/gk/FBA/POS_sandbox__7102.sh'
    run_sh_file_to_log_buffer(run_pos_file)
  end,
  { silent = true, desc = '[R]un [G]K [F]BA [P]os' }
)

vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgep', -- The key sequence (e.g., \sh with default leader)
  function()
    local run_pos_file = vim.fn.stdpath 'config' .. '/custom/files/gk/EXP/POS_sandbox__t128.sh'
    run_sh_file_to_log_buffer(run_pos_file)
  end,
  { silent = true, desc = '[R]un [G]K [E]XP [P]os' }
)

vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgpp', -- The key sequence (e.g., \sh with default leader)
  function()
    local run_pos_file = vim.fn.stdpath 'config' .. '/custom/files/gk/CMX/POS_sandbox__0037.sh'
    run_sh_file_to_log_buffer(run_pos_file)
  end,
  { silent = true, desc = '[R]un [G]K [P]PG [P]os' }
)

-- Create the new keymap for stopping the running job.
-- We'll map <leader>sk to the stop function.
vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgfk', -- The key sequence (e.g., \sh with default leader)
  function()
    stop_running_job()
  end,
  { silent = true, desc = '[R]un [G]K [F]BA [K]ill POS' }
)

vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgek', -- The key sequence (e.g., \sh with default leader)
  function()
    stop_running_job()
  end,
  { silent = true, desc = '[R]un [G]K [E]XP [K]ill POS' }
)

vim.keymap.set(
  'n', -- Normal mode
  '<leader>rgpk', -- The key sequence (e.g., \sh with default leader)
  function()
    stop_running_job()
  end,
  { silent = true, desc = '[R]un [G]K [P]PG [K]ill POS' }
)
