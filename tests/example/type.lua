local mesh_path = type_path .. 'mesh'
local hp = 10

local type = {}
local proto = {}
type.proto = proto
proto[i_hp] = hp

function type.constructor(e, x, y)
  e:new(x, y)
  e:set_mesh(mesh_path)
end

function type.ai(e)
  e:change_pos(fx_random(-1fx, 1fx), fx_random(-1fx, 1fx))
end

return type