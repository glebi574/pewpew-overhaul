local nb = pewpew.new_player_bullet

pewpew_bullet = {}

function pewpew_bullet.new(x, y, angle)
  return nb(x, y, angle, 0)
end