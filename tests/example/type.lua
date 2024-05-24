local mesh_path = type_path .. 'mesh'
local hp = 10
local speed = 5fx

local type = {}
local proto = {}
type.proto = proto
proto[i_hp] = hp

type.wall_collision = true

function type.constructor(e, x, y)
  e:new(x, y)
  e:start_spawning()
  e:set_mesh(mesh_path)
end

function type.ai(e)
  e:change_pos(inputs.mdx * speed, inputs.mdy * speed)
end

return type