local update_callbacks = {}
local post_update_callbacks = {}
local tmp_update_callbacks = {}
pewpew.add_update_callback(function()
  for _, c in ipairs(update_callbacks) do
    c()
  end
  for _, c in ipairs(post_update_callbacks) do
    c()
  end
  for i = #tmp_update_callbacks, 1, -1 do
    tmp_update_callbacks[i]()
    table.remove(tmp_update_callbacks, i)
  end
end)

function add_update_callback(f)
  table.insert(update_callbacks, f)
end

function add_post_update_callback(f)
  table.insert(post_update_callbacks, 1, f)
end

function add_tmp_update_callback(f)
  table.insert(tmp_update_callbacks, f)
end

local __increase_score_of_player = pewpew.increase_score_of_player
function increase_score(v)
  return __increase_score_of_player(0, v)
end

stop_game = pewpew.stop_game

local __get_score_of_player = pewpew.get_score_of_player
function get_score()
  return __get_score_of_player(0)
end

local __configure_player_hud = pewpew.configure_player_hud
function set_hud_string(str)
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

create_explosion = pewpew.create_explosion

local __new_customizable_entity = pewpew.new_customizable_entity
local __customizable_entity_set_position_interpolation = pewpew.customizable_entity_set_position_interpolation
function new_entity(x, y, v)
  local id = __new_customizable_entity(x, y)
  __customizable_entity_set_position_interpolation(id, v == nil or v)
  return id
end

entity_get_pos = pewpew.entity_get_position
entity_get_is_alive = pewpew.entity_get_is_alive
entity_get_is_exploding = pewpew.entity_get_is_started_to_be_destroyed
entity_set_pos = pewpew.entity_set_position
entity_destroy = pewpew.entity_destroy

local __customizable_entity_set_mesh = pewpew.customizable_entity_set_mesh
local __customizable_entity_set_flipping_meshes = pewpew.customizable_entity_set_flipping_meshes
function entity_set_mesh(id, path, i1, i2)
  return i2 and __customizable_entity_set_flipping_meshes(id, mpath(path), i1, i2) or __customizable_entity_set_mesh(id, mpath(path), i1 or 0)
end

entity_set_mesh_color = pewpew.customizable_entity_set_mesh_color
entity_set_string = pewpew.customizable_entity_set_string
entity_set_mesh_xyz = pewpew.customizable_entity_set_mesh_xyz
entity_set_mesh_z = pewpew.customizable_entity_set_mesh_z

local __customizable_entity_set_mesh_xyz_scale = pewpew.customizable_entity_set_mesh_xyz_scale
function entity_set_mesh_scale(id, x, y, z)
  return __customizable_entity_set_mesh_xyz_scale(id, x, y or x, z or y and 1fx or x)
end

entity_set_mesh_angle = pewpew.customizable_entity_set_mesh_angle
entity_set_music_sync = pewpew.customizable_entity_configure_music_response
entity_add_mesh_angle = pewpew.customizable_entity_add_rotation_to_mesh
entity_set_render_radius = pewpew.customizable_entity_set_visibility_radius
entity_start_exploding = pewpew.customizable_entity_start_exploding

local __customizable_entity_start_spawning = pewpew.customizable_entity_start_spawning
function entity_start_spawning(id, t)
  return __customizable_entity_start_spawning(id, t or 0)
end



local __configure_player = pewpew.configure_player
function set_has_lost(v)
  return __configure_player(0, {has_lost = v})
end

function set_shield(v)
  return __configure_player(0, {shield = v})
end

function set_joystick_colors(c1, c2)
  return __configure_player(0, {move_joystick_color = c1, shoot_joystick_color = c2})
end

function set_camera_pos(x, y, z)
  return __configure_player(0, {camera_x_override = x, camera_y_override = y, camera_distance = z and z + 1000fx or nil})
end

function set_camera_z(z)
  return __configure_player(0, {camera_distance = z + 1000fx})
end

local __get_player_configuration = pewpew.get_player_configuration
function get_has_lost()
  return __get_player_configuration(0).has_lost
end

function get_shield()
  return __get_player_configuration(0).shield
end

function preload_sounds(folder, ...)
  local args = {...}
  add_tmp_update_callback(function()
    if #args == 1 or type(args[2]) == 'string' then
      for _, file in ipairs(args) do
        play_sound(string.format('%s/%s', folder, file), -10000fx, -10000fx)
      end
    else
      for i = 1, #args, 2 do
        for k = 0, args[i + 1] - 1 do
          play_sound(string.format('%s/%s', folder, args[i]), -10000fx, -10000fx, k)
        end
      end
    end
  end)
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
