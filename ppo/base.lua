local _print = print
function print(...) -- adds ability to use fx numbers with print ; doesn't fix negative fx numbers being printed incorrectly
  local arg_amount = select('#', ...)
  local output = {select(1, ...)}
  for i = 1, arg_amount do
    if type(output[i]) == 'number' then
      output[i] = string.format(output[i])
    elseif output[i] == nil then
      output[i] = 'nil'
    end
  end
  _print(table.unpack(output))
end