local _p = print
function print(...) -- adds ability to use fx numbers with print and fixes their output
  local arg_amount = select('#', ...)
  local output = {select(1, ...)}
  for i = 1, arg_amount do
    if type(output[i]) == 'number' then
      if output[i] == 0fx or output[i] / output[i] == 1 then
        output[i] = string.format(output[i])
      else
        output[i] = (output[i] < 0fx and '-' or '') .. fx_abs(output[i])
      end
    elseif output[i] == nil then
      output[i] = 'nil'
    end
  end
  _p(table.unpack(output))
end