ppo_require'entity'

if PPO_DEF_PLAYER then
  ppo_require'pewpew_player'
end

if PPO_DEF_BULLET then
  ppo_require'pewpew_bullet'
end

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
entity_start_spawning = pewpew.customizable_entity_start_spawning
entity_start_exploding = pewpew.customizable_entity_start_exploding


local is = pewpew.increase_score_of_player
function increase_score(v)
  return is(0, v)
end

local gs = pewpew.get_score_of_player
function get_score()
  return gs(0)
end

local ch = pewpew.configure_player_hud
function configure_hud_string(str)
  return ch(0, {top_left_line = str})
end

local ps = pewpew.play_sound
local psa = pewpew.play_ambient_sound
function play_sound(path, v1, v2, v3)
  if v2 then
    ps(mpath(path), v3 or 0, v1, v2)
  else
    psa(mpath(path), v1 or 0)
  end
end

local ne = pewpew.new_customizable_entity
local es = pewpew.customizable_entity_set_position_interpolation
function new_entity(x, y, v)
  local id = ne(x, y)
  es(id, v or true)
  return id
end

local sm = pewpew.customizable_entity_set_mesh
local sa = pewpew.customizable_entity_set_flipping_meshes
function entity_set_mesh(id, path, i1, i2)
  return i2 and sa(id, mpath(path), i1, i2) or sm(id, mpath(path), i1 or 0)
end

local ss = pewpew.customizable_entity_set_mesh_xyz_scale
function entity_set_mesh_scale(id, x, y, z)
  return ss(id, x, y or x, z or y and 1fx or x)
end

local c = pewpew.configure_player
function set_joystick_color(c1, c2)
  return c(0, {move_joystick_color = c1, shoot_joystick_color = c2})
end

function set_camera_pos(x, y, z)
  return c(0, {camera_x_override = x, camera_y_override = y, camera_distance = z and z - 1000fx or 0fx})
end

function set_camera_z(z)
  return c(0, {camera_distance = z - 1000fx})
end


local gi = pewpew.get_player_inputs
inputs = {}
add_update_callback(function()
  inputs.ma, inputs.md, inputs.sa, inputs.sd = gi(0)
end)
