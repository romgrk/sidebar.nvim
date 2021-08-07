local utils = require("sidebar-nvim.utils")


local M = {}

-- list of sections rendered
-- { { lines = lines..., section = <table> }, { lines =  lines..., section = <table> } }
M.sections_data = {}

local function get_builtin_section(name)
  local ret, section = pcall(require, "sidebar-nvim.builtin."..name)
  if not ret then
    utils.echo_warning("invalid builtin section: "..name)
    return nil
  end

  return section
end

local function resolve_section(name, section)
  if type(section) == "string" then
    return get_builtin_section(section)
  elseif type(section) == "table" then
    return section
  elseif type(section) == "function" then
    return { title = name, draw = section }
  end

  utils.echo_warning("invalid SidebarNvim section at: " .. name .. " " .. section)
  return nil
end

function M.setup()
  if vim.g.sidebar_nvim_sections == nil then return end
end

function M.update()
  if vim.v.exiting ~= vim.NIL then return end

  M.sections_data = {}

  for name, section_data in pairs(vim.g.sidebar_nvim_sections) do
    local section = resolve_section(name, section_data)

    if section ~= nil then
      local data = { lines = section.draw(), section = section }
      table.insert(M.sections_data, data)
    end
  end

end

return M

