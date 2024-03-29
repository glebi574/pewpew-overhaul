local c = pewpew.configure_player
local gc = pewpew.get_player_configuration
local np = pewpew.new_player_ship
local d = pewpew.add_damage_to_player_ship
local mt = pewpew.make_player_ship_transparent

pewpew_player = {

  new = function(x, y)
    return np(x, y, 0)
  end,
  
  set_is_lost = function(v)
    return c(0, {has_lost = v})
  end,
  
  set_shield = function(v)
    return c(0, {shield = v})
  end,
  
  get_is_lost = function()
    return gc(0).has_lost
  end,
  
  get_shield = function()
    return gc(0).shield
  end,
  
  damage = function(id, v)
    return d(id, v)
  end,
  
  make_transparent = function(id, v)
    return mt(id, v)
  end,
  
  set_speed = function(id, v)
    
  end,
  
}