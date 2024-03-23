emoji_error    = '\u{1f6d1}'
emoji_warning  = '\u{26a0}'
emoji_nice     = '\u{2705}'

fmath_old = nil
pewpewinternal = nil

function mpath(path)
  return '/dynamic/' .. path .. '.lua'
end

local _require = require
function require(path)
  return _require(mpath(path))
end


require'ppo/base'
require'ppo/fmath'
require'ppo/pewpew'

if not PPO_NDEBUG then
  require'ppo/debug'
  require'ppo/tests'
end

--debug_print_contents(fmath)