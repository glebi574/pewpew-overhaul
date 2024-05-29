local mesh_path = type_path .. 'mesh'
local hp = 10
local speed = 5fx

local t = {}
local proto = {}
t.proto = proto
proto[i_hp] = hp

t.wall_collision = true

function t.constructor(e, x, y)
  e:new(x, y)
  e:start_spawning()
  e:set_mesh(mesh_path)
end

function t.ai(e)
  e:change_pos(inputs.mdx * speed, inputs.mdy * speed)
end

return t