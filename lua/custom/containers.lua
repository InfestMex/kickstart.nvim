local function container_picker()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local output = vim.fn.system 'podman ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" --filter status=running'
  if vim.v.shell_error ~= 0 then
    vim.notify('Error running podman ps', vim.log.levels.ERROR)
    return
  end

  local lines = vim.split(output, '\n')
  local containers = {}
  local header = lines[1] -- Skip header if present
  for i = 2, #lines do
    local line = lines[i]:gsub('^%s+', ''):gsub('%s+$', '') -- Trim
    if line ~= '' then
      local id, name, image, status = line:match '^(%S+)%s+(%S+)%s+(.+)%s+(.+)$'
      if id and name then
        table.insert(containers, {
          id = id,
          name = name,
          image = image or 'N/A',
          status = status or 'N/A',
          display = string.format('%s (%s) - %s - %s', id:sub(1, 12), name, image, status),
        })
      end
    end
  end

  if #containers == 0 then
    vim.notify('No running containers found', vim.log.levels.WARN)
    return
  end

  pickers
    .new({}, {
      prompt_title = 'Select running Podman container',
      finder = finders.new_table {
        results = containers,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.name .. ' ' .. entry.id,
            filename = entry.id,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end

          local container_name = selection.value.name
          vim.notify('Will start container name: ' .. container_name, vim.log.levels.INFO)
          local container_name = selection.value.name
          local sh = string.format([[podman unshare bash -lc 'MOUNT="$(podman mount %q)" && cd "$MOUNT" && exec nvim']], container_name)
          vim.fn.jobstart({ 'kitty', 'bash', '-lc', sh }, { detach = true })
        end)
        return true
      end,
    })
    :find()
end

local function open_scratch_vsplit(title, content)
  vim.cmd 'vsp'
  local buf = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
  vim.api.nvim_set_current_buf(buf)

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.bo[buf].readonly = false

  vim.api.nvim_buf_set_name(buf, title)

  local lines = vim.split(content or '', '\n', { plain = true })
  if #lines > 0 and lines[#lines] == '' then
    table.remove(lines, #lines)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].filetype = 'json'
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
end

local function volume_picker()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local output = vim.fn.system 'podman volume ls --format "table {{.Name}}\t{{.Driver}}\t{{.Mountpoint}}"'
  if vim.v.shell_error ~= 0 then
    vim.notify('Error running podman volume ls', vim.log.levels.ERROR)
    return
  end

  local lines = vim.split(output, '\n')
  local volumes = {}
  local header = lines[1] -- Skip header if present
  for i = 2, #lines do
    local line = lines[i]:gsub('^%s+', ''):gsub('%s+$', '') -- Trim
    if line ~= '' then
      local name, driver, mountpoint = line:match '^(%S+)%s+(%S+)%s+(.+)$'
      if name then
        table.insert(volumes, {
          name = name,
          driver = driver or 'N/A',
          mountpoint = mountpoint or 'N/A',
          display = string.format('%s - %s - %s', name, driver or 'N/A', mountpoint or 'N/A'),
        })
      end
    end
  end

  if #volumes == 0 then
    vim.notify('No volumes found', vim.log.levels.WARN)
    return
  end

  pickers
    .new({}, {
      prompt_title = 'Select Podman volume (inspect in vsplit)',
      finder = finders.new_table {
        results = volumes,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.name .. ' ' .. (entry.driver or '') .. ' ' .. (entry.mountpoint or ''),
            filename = entry.name,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end

          local name = selection.value.name
          local inspect = vim.fn.system(string.format('podman volume inspect %q', name))
          if vim.v.shell_error ~= 0 then
            vim.notify('Error running podman volume inspect for: ' .. name, vim.log.levels.ERROR)
            return
          end

          open_scratch_vsplit('podman-volume://' .. name, inspect)
        end)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', '<leader>cn', container_picker, { desc = '[C]ontainer running + [N]eovim' })
vim.keymap.set('n', '<leader>cv', volume_picker, { desc = '[C]ontainer + [V]olumes (inspect in vsplit)' })
