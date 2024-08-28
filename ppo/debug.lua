function debug_print_contents(arr) -- prints contents of table, sorted by first letter
  if type(arr) ~= 'table' then
    error('Provided argument isn\'t a table.')
  end
  local contents = {}
  for key, value in pairs(arr) do
    table.insert(contents, {tostring(key), tostring(value)})
  end
  table.sort(contents, function(a, b) return b[1]:sub(1, 1) > a[1]:sub(1, 1) end)
  for _, line in ipairs(contents) do
    print(line[1] .. ' - ' .. line[2])
  end
  print((emoji_nice or '\u{2705}') .. ' ' .. #contents .. ' entries')
end

function get_memory_usage() -- returns memory usage in KB and B
  local a = collectgarbage'count'
  return string.format('%i%s %i%s', a // 1, 'KB', a % 1 * 1024, 'B')
end

if math then
  return
end

function add_memory_print() -- forces garbage collection cycle and prints amount of used memory every tick
  _ENV[pewpew and 'pewpew' or '_G'].add_update_callback(function()
    collectgarbage'collect'
    print(get_memory_usage())
  end)
end

function add_memory_warning() -- checks if you're close to memory limit and automatically collects garbage
  _ENV[pewpew and 'pewpew' or '_G'].add_update_callback(function()
    local memory_usage = get_memory_usage()
    if collectgarbage'count' > 450 then
      collectgarbage'collect'
      print(string.format('%s Using too much memory: %s -> %s', emoji_warning, memory_usage, get_memory_usage()))
    end
  end)
end

local __create_explosion = create_explosion
function create_explosion(x, y, color, scale, particle_amount)
  if particle_amount < 1 then
    return error('Error, creating explosion. Particle amount can\'t be lower, than 1.')
  end
  __create_explosion(x, y, color, scale, particle_amount)
end

local __play_sound = play_sound
function play_sound(path, v1, v2, v3)
  if not loadfile(mpath(path)) then
    return error('Error, playing sound. Incorrect path was specified.')
  end
  return __play_sound(path, v1, v2, v3)
end

local __entity_set_mesh = entity_set_mesh
function entity_set_mesh(id, path, i1, i2)
  if not loadfile(mpath(path)) then
    return error('Error, loading mesh. Incorrect path was specified.')
  end
  return __entity_set_mesh(id, path, i1, i2)
end
