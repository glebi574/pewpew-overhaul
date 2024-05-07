local c = pewpew.configure_player
local gc = pewpew.get_player_configuration
local np = pewpew.new_player_ship
local d = pewpew.add_damage_to_player_ship
local mt = pewpew.make_player_ship_transparent

pewpew_player = {}

function pewpew_player.new(x, y)
  return np(x, y, 0)
end

function pewpew_player.set_is_lost(v)
  return c(0, {has_lost = v})
end

function pewpew_player.set_shield(v)
  return c(0, {shield = v})
end

function pewpew_player.get_is_lost()
  return gc(0).has_lost
end

function pewpew_player.get_shield()
  return gc(0).shield
end

function pewpew_player.damage(id, v)
  return d(id, v)
end

function pewpew_player.make_transparent(id, v)
  return mt(id, v)
end

function pewpew_player.set_speed(id, v)
  
end
