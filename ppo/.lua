emoji_error    = '\u{1f6d1}'
emoji_warning  = '\u{26a0}'
emoji_nice     = '\u{2705}'

PPO_VERSION = '0.0.0'

function mpath(path)
  return string.format('%s%s%s', '/dynamic/', path ,'.lua')
end

local __require = require
function require(path)
  return __require(mpath(path))
end

function ppo_require(...)
  for _, path in ipairs{...} do
    require(string.format('%s/%s', 'ppo', path))
  end
end

function ppo_grequire(path)
  return require(string.format('%s/%s', 'ppo', path))
end

function rm(a)
  for k, v in pairs(a) do
    if type(v) == 'table' then
      rm(v)
    end
    a[k] = nil
  end
end

function rmn(...)
  for _, name in ipairs{...} do
    local a = _ENV[name]
    if a then
      rm(a)
      _ENV[name] = nil
    end
  end
end

if not PPO_NDEBUG then
  ppo_require'debug'
end

if not math then
  ppo_require('base', 'fmath', 'pewpew', 'entity', 'wall')
  entity.def_keys('i_type', 'i_name', 'i_pid', 'i_id', 'i_x', 'i_y', 'i_radius', 'i_hp')
elseif PPO_SOUND then
  ppo_require('base', 'sound')
else
  add_memory_print, add_memory_warning = nil, nil
  ppo_require('base', 'fmath', 'mesh')
end

rmn('pewpew', 'fmath', 'fmath_old', 'pewpewinternal')

rm = nil
rmn = nil
