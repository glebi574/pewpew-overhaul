function test_print() -- tests modified version of print
  print(4, nil, 3.1024fx, var, true, false, emoji_nice, table, pcall)
end

function get_memory_usage()
  local a = collectgarbage'count'
  return string.format('%i%s %i%s', a // 1, 'KB', a % 1 * 1024, 'B')
end

function add_memory_print() -- forces garbage collection cycle and prints amount of used memory every tick
  _ENV[pewpew and 'pewpew' or '_G'].add_update_callback(function()
    collectgarbage'collect'
    print(get_memory_usage())
  end)
end