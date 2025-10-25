local api = vim.api

local M = {}

local function normalize_cmd(cmd)
  if cmd == nil then
    error('Command must not be nil')
  end
  if type(cmd) == 'string' or type(cmd) == 'table' then
    return cmd
  end
  error('Command must be a string or list')
end

local function resolve_cmd(cmd)
  if type(cmd) == 'function' then
    cmd = cmd()
  end
  return normalize_cmd(cmd)
end

local function create_float(opts)
  opts = opts or {}

  local columns = vim.o.columns
  local lines = vim.o.lines - vim.o.cmdheight

  local width = opts.width or math.max(20, math.floor(columns * (opts.width_ratio or 0.8)))
  local height = opts.height or math.max(10, math.floor(lines * (opts.height_ratio or 0.6)))

  local row = math.floor((lines - height) / 2)
  local col = math.floor((columns - width) / 2)

  local buf = api.nvim_create_buf(false, true)
  local win = api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = opts.border or 'rounded',
    title = opts.title,
  })

  vim.bo[buf].bufhidden = 'wipe'
  return buf, win
end

local function set_close_keys(buf, win, keys)
  for _, key in ipairs(keys or { 'q', '<Esc>' }) do
    vim.keymap.set('n', key, function()
      if api.nvim_win_is_valid(win) then
        api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true, silent = true })
  end
end

function M.open_command_output(cmd, opts)
  opts = opts or {}
  cmd = resolve_cmd(cmd)

  local ok, output = pcall(vim.fn.systemlist, cmd)
  if not ok then
    output = { 'Failed to run command' }
  end

  if vim.v.shell_error ~= 0 then
    table.insert(output, 1, ('Exit code: %d'):format(vim.v.shell_error))
  end

  if #output == 0 then
    output = { '<no output>' }
  end

  table.insert(output, '')
  table.insert(output, 'Process exited. Press <Enter> to close.')

  local buf, win = create_float(opts)
  api.nvim_buf_set_lines(buf, 0, -1, false, output)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = opts.filetype or 'sh'

  local close_keys = opts.close_keys or { 'q', '<Esc>', '<CR>' }
  set_close_keys(buf, win, close_keys)
  return buf, win
end

function M.open_terminal(cmd, opts)
  opts = opts or {}
  cmd = resolve_cmd(cmd or vim.o.shell)

  local buf, win = create_float(opts)
  local term_opts = {
    cwd = opts.cwd,
    env = opts.env,
    on_exit = function(_, code)
      if opts.on_exit then
        pcall(opts.on_exit, code)
      end
      if opts.close_on_exit == true and api.nvim_win_is_valid(win) then
        api.nvim_win_close(win, true)
      end
    end,
  }

  vim.fn.termopen(cmd, term_opts)
  set_close_keys(buf, win, opts.close_keys)

  if opts.start_insert ~= false then
    vim.cmd.startinsert()
  end

  return buf, win
end

function M.command_runner(cmd, opts)
  return function()
    M.open_command_output(cmd, opts)
  end
end

function M.terminal_runner(cmd, opts)
  return function()
    M.open_terminal(cmd, opts)
  end
end

return M
