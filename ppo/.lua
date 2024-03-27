emoji_error    = '\u{1f6d1}'
emoji_warning  = '\u{26a0}'
emoji_nice     = '\u{2705}'

local sf = string.format
function mpath(path)
  return sf('%s%s%s', '/dynamic/', path ,'.lua')
end

local _r = require
function require(path)
  return _r(mpath(path))
end

function ppo_require(...)
  for _, path in ipairs{...} do
    require(sf('%s%s', 'ppo/', path))
  end
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
  ppo_require('debug', 'tests')
end

ppo_require('base', 'fmath', 'pewpew')

rmn('pewpew', 'fmath', 'fmath_old', 'pewpewinternal')

rm = nil
rmn = nil