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