ppo_load'pewpew_player'
ppo_load'pewpew_bullet'

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

local _play_soundA = pewpew.play_ambient_sound
function play_ambient_sound(path, index)
  return _play_soundA(mpath(path), index or 0)
end

local _play_sound = pewpew.play_sound
function play_sound(path, x, y, index)
  return _play_sound(mpath(path), index or 0, x, y)
end

local _new_entity = pewpew.new_customizable_entity
local _entity_smooth = pewpew.entity_set_posisiton_interpolation
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

pewpew = nil