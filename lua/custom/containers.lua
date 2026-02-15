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

vim.keymap.set('n', '<leader>cu', container_picker, { desc = '[C]ontainer [U]nshare + Neovim' })
