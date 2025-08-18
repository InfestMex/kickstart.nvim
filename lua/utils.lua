--[[
Implements 4 methods:
  get_current_method_name() - return a method name.
  get_current_class_name() - return a class name where the cursor is
  get_current_package_name() - return a package name of the current file
  get_current_full_class_name() - return a full class name (package + class name)
  get_current_full_method_name(delimiter) - return a full method name (package + class + [delimiter] + method name)
  get_java_class_name() - return a class name where the cursor is (java file)
  get_java_method_name() - return a method name (java file)
  get_java_package_name() - return a package name of the current file (java file)
  get_java_full_class_name() - return a full class name (package + class name) (java file)
  get_java_full_method_name(delimiter) - return a full method name (package + class + [delimiter] + method name) (java file)
--]]

local M = {}

---Get current method name
---@return string|nil
function M.get_current_method_name()
  -- Implementation for other file types
  return nil
end

---Get current class name
---@return string|nil
function M.get_current_class_name()
  -- Implementation for other file types
  return nil
end

---Get current package name
---@return string|nil
function M.get_current_package_name()
  -- Implementation for other file types
  return nil
end

---Get current full class name
---@return string|nil
function M.get_current_full_class_name()
  -- Implementation for other file types
  return nil
end

---Get current full method name
---@param delimiter string
---@return string|nil
function M.get_current_full_method_name(delimiter)
  -- Implementation for other file types
  return nil
end

---Get java method name
---@return string|nil
function M.get_java_method_name()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  local current_line = vim.api.nvim_get_current_line()

  -- Check if the current file is a Java file
  if vim.bo.filetype ~= 'java' then
    return nil
  end

  -- Regex to find method declaration (e.g., public void myMethod() {)
  local method_match = string.match(current_line, 'public')
  if method_match then
    local method_name = method_match
    return method_name
  end

  return nil
end

---Get java class name
---@return string|nil
function M.get_java_class_name()
  -- Check if the current file is a Java file
  if vim.bo.filetype ~= 'java' then
    vim.notify('Current file is not a java file' .. class_name, vim.log.levels.WARN, { title = 'Custom Utils' })
    return nil
  end

  -- Get the content of the current buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, '\n')

  if content == nil then
    vim.notify('Not able to obtain buffer content', vim.log.levels.WARN, { title = 'Custom Utils' })
  end

  -- Regex to find class declaration (e.g., public class MyClass {)
  local class_match = string.match(content, 'class%s+([%w_]+)')
  if class_match then
    local class_name = class_match
    return class_name
  end

  vim.notify('Not able to obtain the class name', vim.log.levels.WARN, { title = 'Custom Utils' })
  return nil
end

---Get java package name
---@return string|nil
function M.get_java_package_name()
  -- Check if the current file is a Java file
  if vim.bo.filetype ~= 'java' then
    return nil
  end

  -- Get the content of the current buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, '\n')

  -- Regex to find package declaration (e.g., package com.example;)
  local package_match = string.match(content, 'package%s+([%w%.]+)')
  if package_match then
    local package_name = package_match
    return package_name
  end

  return nil
end

---Get java full class name
---@return string|nil
function M.get_java_full_class_name()
  local package_name = M.get_java_package_name()
  vim.notify('Debug:package_name=' .. package_name, vim.log.levels.WARN, { title = 'Custom Utils' })
  local class_name = M.get_java_class_name()
  vim.notify('Debug:class_name=' .. class_name, vim.log.levels.WARN, { title = 'Custom Utils' })

  if package_name ~= nil and class_name ~= nil then
    return package_name .. '.' .. class_name
  end

  return nil
end

---Get java full class name
---@return string|nil
function M.get_java_project_name()
  -- Check if the current file is a Java file
  if vim.bo.filetype ~= 'java' then
    return nil
  end

  local file_path = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()

  -- Ensure both paths use / as separator
  file_path = file_path:gsub('\\', '/')
  cwd = cwd:gsub('\\', '/')

  -- Remove cwd prefix from file path
  local rel_path = file_path:match('^' .. vim.pesc(cwd) .. '/(.*)')
  if not rel_path then
    vim.notify('File is not in current working directory', vim.log.levels.WARN, { title = 'Custom Utils' })
    return nil
  end

  local project_name = rel_path:match '([^/\\]+)'
  if not project_name then
    vim.notify('Unable to determine project name', vim.log.levels.WARN, { title = 'Custom Utils' })
    return nil
  end

  return project_name
end

---Get java full method name
---@param delimiter string
---@return string|nil
function M.get_java_full_method_name(delimiter)
  local full_class_name = M.get_java_full_class_name()
  local method_name = M.get_java_method_name()

  if full_class_name ~= nil and method_name ~= nil then
    return full_class_name .. delimiter .. method_name
  end

  return nil
end

return M
