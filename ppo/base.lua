local __tostring = tostring
function tostring(v)
  if type(v) ~= 'number' then
    return __tostring(v)
  end
  if v == 0fx or v / v == 1 then
    return string.format(v)
  else
    return (v < 0fx and '-' or '') .. fx_abs(v)
  end
end

local __print = print
function print(...) -- adds ability to use fx numbers with print and fixes their output
  local arg_amount = select('#', ...)
  local output = {select(1, ...)}
  for i = 1, arg_amount do
    if output[i] == nil then
      output[i] = 'nil'
    else
      output[i] = tostring(output[i])
    end
  end
  __print(table.unpack(output))
end

if PPO_SOUND then
  return
end

function make_color(r, g, b, a)
	return ((r * 256 + g) * 256 + b) * 256 + a
end

function change_alpha(c, a)
  return c - c % 256 + a
end

function color_to_string(c)
  local str0 = {}
  local cstr = string.format('%x', c)
  local l = cstr:len()
  if l == 8 then
    return string.format('#%s', cstr)
  else
    for i = l + 1, 8 do
      table.insert(str0, '0')
    end
    return string.format('#%s%s', table.concat(str0), cstr)
  end
end