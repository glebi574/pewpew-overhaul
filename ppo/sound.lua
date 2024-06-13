rmn'math'

sounds = {}

function add_sound(str)
  local t = load('return {' .. str:sub(str:find('%%2C%%22attack') + 3, #str - 3):gsub('%%3A%%22', '="'):gsub('%%22%%2C', '",'):gsub('%%22', ''):gsub('%%3A', '='):gsub('%%2C', ',') .. '}')()
  t.amplification = t.amplification / 100
  t.interpolateNoise = nil
  t.squareDuty = nil
  t.squareDutySweep = nil
  t.bitCrush = nil
  t.bitCrushSweep = nil
  t.lowPassCutoff = nil
  t.lowPassCutoffSweep = nil
  t.highPassCutoff = nil
  t.highPassCutoffSweep = nil
  t.compression = nil
  t.normalization = nil
  table.insert(sounds, t)
end