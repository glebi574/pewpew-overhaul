local _pewpew = pewpew
pewpew = {}

pewpew.CANNON_SINGLE          = _pewpew.CannonType.SINGLE
pewpew.CANNON_TIC_TOC         = _pewpew.CannonType.TIC_TOC
pewpew.CANNON_DOUBLE          = _pewpew.CannonType.DOUBLE
pewpew.CANNON_TRIPLE          = _pewpew.CannonType.TRIPLE
pewpew.CANNON_FOUR_DIRECTIONS = _pewpew.CannonType.FOUR_DIRECTIONS
pewpew.CANNON_DOUBLE_SWIPE    = _pewpew.CannonType.DOUBLE_SWIPE
pewpew.CANNON_HEMISPHERE      = _pewpew.CannonType.HEMISPHERE
  
pewpew.CANNON_FREQUENCY_30  = _pewpew.CannonFrequency.FREQ_30
pewpew.CANNON_FREQUENCY_15  = _pewpew.CannonFrequency.FREQ_15
pewpew.CANNON_FREQUENCY_10  = _pewpew.CannonFrequency.FREQ_10
pewpew.CANNON_FREQUENCY_7_5 = _pewpew.CannonFrequency.FREQ_7_5
pewpew.CANNON_FREQUENCY_6   = _pewpew.CannonFrequency.FREQ_6
pewpew.CANNON_FREQUENCY_5   = _pewpew.CannonFrequency.FREQ_5
pewpew.CANNON_FREQUENCY_3   = _pewpew.CannonFrequency.FREQ_3
pewpew.CANNON_FREQUENCY_2   = _pewpew.CannonFrequency.FREQ_2
pewpew.CANNON_FREQUENCY_1   = _pewpew.CannonFrequency.FREQ_1

pewpew.print_debug_info = _pewpew.print_debug_info
pewpew.set_level_size = _pewpew.set_level_size
pewpew.configure_player = _pewpew.configure_player
pewpew.get_player_configuration = _pewpew.get_player_configuration


function pewpew.set_shield_amount(amount)
  pewpew.configure_player(0, {shield = amount})
end

function pewpew.get_shield_amount()
  return pewpew.get_player_configuration(0).shield
end

function pewpew.set_is_lost(is_lost)
  pewpew.configure_player(0, {has_lost = is_lost})
end

function pewpew.get_is_lost()
  return pewpew.get_player_configuration(0).has_lost
end


add_update_callback = _pewpew.add_update_callback
stop_game = _pewpew.stop_game
get_inputs = _pewpew.get_player_inputs

local _get_score = _pewpew.get_score_of_player
function get_score()
  return _get_score(0)
end

local _increase_score = _pewpew.increase_score_of_player
function increase_score(a)
  _increase_score(0, a)
end

function set_joystick_color(c1, c2)
  configure_player(0, {move_joystick_color = c1, shoot_joystick_color = c2})
end

local _configure_hud = _pewpew.configure_player_hud
function set_hud_string(str)
  _configure_hud(0, {top_left_line = str})
end

