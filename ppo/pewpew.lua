add_update_callback = pewpew.add_update_callback
stop_game = pewpew.stop_game
create_explosion = pewpew.create_explosion
entity_set_pos = pewpew.entity_set_position
entity_get_is_alive = pewpew.entity_get_is_alive
entity_get_is_exploding = pewpew.entity_get_is_started_to_be_destroyed
entity_destroy = pewpew.entity_destroy
entity_set_mesh_color = pewpew.customizable_entity_set_mesh_color
entity_set_string = pewpew.customizable_entity_set_string
entity_set_mesh_xyz = pewpew.customizable_entity_set_mesh_xyz
entity_set_mesh_angle = pewpew.customizable_entity_set_mesh_angle
entity_set_music_sync = pewpew.customizable_entity_configure_music_response
entity_add_mesh_angle = pewpew.customizable_entity_add_rotation_to_mesh
entity_set_render_radius = pewpew.customizable_entity_set_visibility_radius
entity_start_exploding = pewpew.customizable_entity_start_exploding


local __increase_score_of_player = pewpew.increase_score_of_player
function increase_score(v)
  return __increase_score_of_player(0, v)
end

local __get_score_of_player = pewpew.get_score_of_player
function get_score()
  return __get_score_of_player(0)
end

local __configure_player_hud = pewpew.configure_player_hud
function configure_hud_string(str)
  return __configure_player_hud(0, {top_left_line = str})
end

local __play_sound = pewpew.play_sound
local __play_ambient_sound = pewpew.play_ambient_sound
function play_sound(path, v1, v2, v3)
  if v2 then
    __play_sound(mpath(path), v3 or 0, v1, v2)
  else
    __play_ambient_sound(mpath(path), v1 or 0)
  end
end

local __new_customizable_entity = pewpew.new_customizable_entity
local __customizable_entity_set_position_interpolation = pewpew.customizable_entity_set_position_interpolation
function new_entity(x, y, v)
  local id = __new_customizable_entity(x, y)
  __customizable_entity_set_position_interpolation(id, v or true)
  return id
end

local __customizable_entity_set_mesh = pewpew.customizable_entity_set_mesh
local __customizable_entity_set_flipping_meshes = pewpew.customizable_entity_set_flipping_meshes
function entity_set_mesh(id, path, i1, i2)
  return i2 and __customizable_entity_set_flipping_meshes(id, mpath(path), i1, i2) or __customizable_entity_set_mesh(id, mpath(path), i1 or 0)
end

local __customizable_entity_set_mesh_xyz_scale = pewpew.customizable_entity_set_mesh_xyz_scale
function entity_set_mesh_scale(id, x, y, z)
  return __customizable_entity_set_mesh_xyz_scale(id, x, y or x, z or y and 1fx or x)
end

local __customizable_entity_start_spawning = pewpew.customizable_entity_start_spawning
function entity_start_spawning(id, t)
  return __customizable_entity_start_spawning(id, t or 0)
end

local __configure_player = pewpew.configure_player
function set_joystick_color(c1, c2)
  return __configure_player(0, {move_joystick_color = c1, shoot_joystick_color = c2})
end

function set_camera_pos(x, y, z)
  return __configure_player(0, {camera_x_override = x, camera_y_override = y, camera_distance = z and z + 1000fx or nil})
end

function set_camera_z(z)
  return __configure_player(0, {camera_distance = z + 1000fx})
end


local __get_player_inputs = pewpew.get_player_inputs
inputs = {}
add_update_callback(function()
  inputs.ma, inputs.md, inputs.sa, inputs.sd = __get_player_inputs(0)
  inputs.mdy, inputs.mdx = fx_sincos(inputs.ma)
  inputs.mdy, inputs.mdx = inputs.mdy * inputs.md, inputs.mdx * inputs.md
  inputs.sdy, inputs.sdx = fx_sincos(inputs.sa)
  inputs.sdy, inputs.sdx = inputs.sdy * inputs.sd, inputs.sdx * inputs.sd
end)
