wall = {}

walls_line = {}
walls_circle = {}

local wall_id = 1 -- id counter for walls

function wall.add_line(x1, y1, x2, y2)
  walls_line[wall_id] = {x1, y1, x2, y2}
  wall_id = wall_id + 1
end

function wall.add_circle(x, y, r)
  walls_circle[wall_id] = {x, y, r}
  wall_id = wall_id + 1
end
