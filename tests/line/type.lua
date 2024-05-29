local mesh_path = type_path .. 'mesh'

local t = {}

function t.constructor(e, x1, y1, x2, y2)
  e:new(x1, y1)
  e:start_spawning()
  e:set_mesh(mesh_path)
  local dx, dy = x2 - x1, y2 - y1
  e:set_mesh_scale(fx_sqrt(dx * dx + dy * dy))
  e:set_mesh_angle(fx_atan2(dy, dx), 0fx, 0fx, 1fx)
end

return t