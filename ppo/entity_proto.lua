local p = {}

function p:set_pos(x, y)
  self[i_x] = x
  self[i_y] = y
end

function p:get_pos()
  return self[i_x], self[i_y]
end

function p:change_pos(x, y)
  self[i_x] = self[i_x] + x
  self[i_y] = self[i_y] + y
end

function p:get_is_alive()
  return entity_get_is_alive(self[i_id])
end

function p:get_is_exploding()
  return entity_get_is_exploding(self[i_id])
end

function p:destroy()
  return entity_destroy(self[i_id])
end

function p:set_mesh_color(c)
  return entity_set_mesh_color(self[i_id], c)
end

function p:set_string(s)
  return entity_set_string(self[i_id], s)
end

function p:set_mesh_xyz(x, y, z)
  return entity_set_mesh_xyz(self[i_id], x, y, z)
end

function p:set_mesh_angle(r, rx, ry, rz)
  return entity_set_mesh_angle(self[i_id], r, rx, ry, rz)
end

function p:set_music_sync(conf)
  return entity_set_music_sync(self[i_id], conf)
end

function p:add_mesh_angle(r, rx, ry, rz)
  return entity_add_mesh_angle(self[i_id], r, rx, ry, rz)
end

function p:set_render_radius(r)
  return entity_set_render_radius(self[i_id], r)
end

function p:start_spawning(t)
  return entity_start_spawning(self[i_id], t)
end

function p:start_exploding(t)
  return entity_start_exploding(self[i_id], t)
end

function p:set_mesh(...)
  return entity_set_mesh(self[i_id], ...)
end

function p:set_mesh_scale(...)
  return entity_set_mesh_scale(self[i_id], ...)
end

function p:new(x, y, v)
  self[i_x] = x
  self[i_y] = y
  self[i_id] = new_entity(x, y, v)
  return self[i_id]
end

function p:remove()
  local pid = self[i_pid]
  entities[pid] = nil
  wall.entities[pid] = nil
  if self[i_type].groups then
    for _, group_name in ipairs(self[i_type].groups) do
      entity_groups[group_name][pid] = nil
    end
  end
  entity.amount = entity.amount - 1
end

return p