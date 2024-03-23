local _conf = pewpew.configure_player
local _gconf = pewpew.get_player_configuration
local new_player = pewpew.new_player_ship

pewpew_player = {
  new = function(x, y)
    return new_player(x, y, 0)
  end,
  
}