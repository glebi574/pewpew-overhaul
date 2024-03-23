require'ppo/pewpew_player'
require'ppo/pewpew_bullet'

add_update_callback = pewpew.add_update_callback
stop_game = pewpew.stop_game
get_inputs = pewpew.get_player_inputs
create_explosion = pewpew.create_explosion
entity_set_pos = pewpew.entity_set_posisiton
entity_is_alive = pewpew.entity_get_is_alive
entity_is_exploding = pewpew.entity_get_is_started_to_be_destroyed
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


local inc_scr = pewpew.increase_score_of_player
function increase_score(v)
  return inc_scr(0, v)
end

local get_scr = pewpew.get_score_of_player
function get_score()
  return get_scr(0)
end

local cfg_hud = pewpew.configure_player_hud
function configure_hud_string(str)
  return cfg_hud(0, {top_left_line = str})
end

local _play_sound = pewpew.play_sound
local _play_soundA = pewpew.play_ambient_sound
function play_sound(path, v1, v2, v3)
  return v2 and _play_soundA(mpath(path), v1, v2, v3 or 0) or _play_sound(mpath(path), v1 or 0)
end

local _new_entity = pewpew.new_customizable_entity
local _entity_smooth = pewpew.customizable_entity_set_position_interpolation
function new_entity(x, y)
  local id = _new_entity(x, y)
  _entity_smooth(id, true)
  return id
end

local _set_mesh = pewpew.customizable_entity_set_mesh
local _set_anim = pewpew.entity_set_flipping_meshes
function entity_set_mesh(id, path, i1, i2)
  return i2 and _set_anim(id, mpath(path), i1, i2) or _set_mesh(id, mpath(path), i1 or 0)
end

local _set_scale = pewpew.customizable_entity_set_mesh_xyz_scale
function entity_set_mesh_scale(id, x, y, z)
  return _set_scale(id, x, y or x, z or y and 1fx or x)
end

local _conf = pewpew.configure_player
function set_joystick_color(c1, c2)
  return _conf(0, {move_joystick_color = c1, shoot_joystick_color = c2})
end

function set_camera_pos(x, y, z)
  return _conf(0, {camera_x_override = x, camera_y_override = y, camera_distance = z and z - 1000fx or 0fx})
end

function set_camera_z(z)
  return _conf(0, {camera_distance = z - 1000fx})
end

function set_camera_angle(x)
  return _conf(0, {camera_rotation_x_axis = x})
end

pewpew = nil