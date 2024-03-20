emoji_error    = '\u{1f6d1}'
emoji_warning  = '\u{26a0}'
emoji_nice     = '\u{2705}'

fmath_old = nil
pewpewinternal = nil

local _require = require
function require(path)
  return _require('/dynamic/' .. path .. '.lua')
end

local function ppo_load(path)
  return require('ppo/' .. path)
end

ppo_load'base'
ppo_load'fmath'
ppo_load'pewpew'
ppo_load'debug'
ppo_load'tests'

--debug_print_contents(fmath)