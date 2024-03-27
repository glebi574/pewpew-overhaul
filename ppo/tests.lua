function test_print() -- tests modified version of print
  print(4, nil, 3.1024fx, var, true, false, emoji_nice, table, pcall)
end

function add_memory_print() -- forces garbage collection cycle and prints amount of used memory every tick
  _ENV[pewpew and 'pewpew' or '_G'].add_update_callback(function()
    collectgarbage'collect'
    print(collectgarbage'count')
  end)
end