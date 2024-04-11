function debug_print_contents(arr) -- prints contents of table, sorted by first letter
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
