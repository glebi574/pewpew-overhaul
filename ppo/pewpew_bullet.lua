local nb = pewpew.new_player_bullet

pewpew_bullet = {

  new = function(x, y, angle)
    return nb(x, y, angle, 0)
  end

}
