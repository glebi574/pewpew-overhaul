local mesh_path = type_path .. 'mesh'

local function update(e, x1, y1, x2, y2)
  local dx, dy = x2 - x1, y2 - y1
  e:set_pos(x1, y1)
  e:set_mesh_scale(fx_sqrt(dx * dx + dy * dy))
  e:set_mesh_angle(fx_atan2(dy, dx), 0fx, 0fx, 1fx)
end

local t = {}
local proto = {}
t.proto = proto
function proto:update(x1, y1, x2, y2)
  return update(self, x1, y1, x2, y2)
end

function t.constructor(e, x1, y1, x2, y2, c)
  e:new(x1, y1)
  e:start_spawning()
  e:set_mesh(mesh_path)
  e:set_mesh_color(c)
  update(e, x1, y1, x2, y2)
end

return t