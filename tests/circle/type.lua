local mesh_path = type_path .. 'mesh'

local t = {}
local proto = {}
t.proto = proto

function t.constructor(e, x, y, r, c)
  e:new(x, y)
  e:start_spawning()
  e:set_mesh(mesh_path)
  e:set_mesh_color(c)
  e:set_mesh_scale(r)
end

return t