local FX_PI2 = FX_PI / 2fx
local FX_PI3_4 = FX_PI + FX_PI2
local p = 0.64fx -- precision error, due to fx being inprecise on this level
local np = -p
local n = p * 2fx -- repulsion to not get stuck in wall
local Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, Qx, Qy, Rx, Ry
local ABk, ABb, CDk, CDb
local ABmin_x, ABmin_y, ABmax_x, ABmax_y, CDmin_x, CDmin_y, CDmax_x, CDmax_y
local ABdx, ABdy, QBdx, QBdy, QNdx, QNdy, QFdx, QFdy, QBl, QFl, ABa, QNa, QFa

wall = {}

local walls_line = {}
local walls_circle = {}

wall.entities = {} -- entity info for collision processing. Positions are buffered here

local wall_id = 1 -- id counter for walls

local function calculate_line(x1, y1, x2, y2)
  local k, b = false, false
  if x1 ~= x2 then
    k = (y2 - y1) / (x2 - x1)
    b = y1 - x1 * k
  end
  local min_x, min_y, max_x, max_y = x1, y1, x1, y1
  if x1 < x2 then
    max_x = x2
  else
    min_x = x2
  end
  if y1 < y2 then
    max_y = y2
  else
    min_y = y2
  end
  return k, b, min_x, min_y, max_x, max_y
end

local function check_wall_collision(wid)
  Cx, Cy, Dx, Dy, CDk, CDb, CDa, CDmin_x, CDmin_y, CDmax_x, CDmax_y = table.unpack(walls_line[wid])
  if ABk == CDk then -- movement is parallel, skip
    return nil
  end
  if not ABk then
    Qx = Ax
    Qy = CDk * Qx + CDb
  elseif not CDk then
    Qx = Cx
    Qy = ABk * Qx + ABb
  else
    Qx = (CDb - ABb) / (ABk - CDk)
    Qy = (ABb * CDk - CDb * ABk) / (CDk - ABk)
  end
  
  if Qx < ABmin_x + np or Qx > ABmax_x + p or
     Qx < CDmin_x + np or Qx > CDmax_x + p or
     Qy < ABmin_y + np or Qy > ABmax_y + p or
     Qy < CDmin_y + np or Qy > CDmax_y + p then -- point doesn't belong to both lines, skip
    return nil
  end
  
  local da = ABa - CDa
  if da > 0fx and da < FX_PI then -- normal angle with correct direction
    QNa = CDa + FX_PI3_4
  else
    QNa = CDa + FX_PI2
  end
  if fx_abs(fx_abs(da) - FX_PI) < FX_PI2 then
    QFa = CDa + FX_PI
  else
    QFa = CDa
  end
  return Qx, Qy, QNa, QFa
end

local function check_wall_collisions()
  local collisions = {}
  for wid, wall in pairs(walls_line) do
    if check_wall_collision(wid) then
      table.insert(collisions, {Qx, Qy, QNa, QFa})
    end
  end
  if #collisions == 0 then
    Rx, Ry = Bx, By
    return nil
  elseif #collisions == 1 then
    Qx, Qy, QNa, QFa = table.unpack(collisions[1])
  else
    local min_i = 1
    local min_dx, min_dy = collisions[1][1] - Ax, collisions[1][2] - Ay
    local min_ls = min_dx * min_dx + min_dy * min_dy
    for i = 2, #collisions do
      local dx, dy = collisions[i][1] - Ax, collisions[i][2] - Ay
      local ls = dx * dx + dy * dy
      if ls < min_ls then
        min_i = i
        min_dx, min_dy = dx, dy
        min_ls = ls
      end
    end
    
    local is_corner = true
    for i = 1, #collisions do
      if fx_abs(collisions[i][1] - collisions[min_i][1]) > p or fx_abs(collisions[i][2] - collisions[min_i][2]) > p then
        is_corner = false
        break
      end
    end
    if is_corner then
      local _QNdx, _QNdy = 0fx, 0fx
      for i = 1, #collisions do
        local QNdy, QNdx = fx_sincos(collisions[i][3])
        _QNdx, _QNdy = _QNdx + QNdx * n, _QNdy + QNdy * n
      end
      Rx, Ry = collisions[min_i][1] + _QNdx, collisions[min_i][2] + _QNdy
      return nil
    else
      Qx, Qy, QNa, QFa = table.unpack(collisions[min_i])
    end
  end
  
  QNdy, QNdx = fx_sincos(QNa)
  QBdx, QBdy = Bx - Qx, By - Qy
  QBl = fx_sqrt(QBdx * QBdx + QBdy * QBdy)
  QBl = fx_abs(QBl * fx_cos(ABa - QNa - FX_PI2))
  QFdy, QFdx = fx_sincos(QFa)
  Bx = Qx + QNdx * n + QFdx * QBl
  By = Qy + QNdy * n + QFdy * QBl
  ABk, ABb, ABmin_x, ABmin_y, ABmax_x, ABmax_y = calculate_line(Ax, Ay, Bx, By)
  ABdx, ABdy = Bx - Ax, By - Ay
  ABa = fx_atan2(ABdy, ABdx)
  for wid, wall in pairs(walls_line) do
    if check_wall_collision(wid) then
      local AQdx, AQdy = Qx - Ax, Qy - Ay
      local AQl = fx_sqrt(AQdx * AQdx + AQdy * AQdy) - n
      AQdy, AQdx = fx_sincos(ABa)
      Rx, Ry = Ax + AQdx * AQl, Ay + AQdy * AQl
      return nil
    end
  end
  Rx, Ry = Bx, By
end

function wall.add_line(x1, y1, x2, y2)
  local k, b, min_x, min_y, max_x, max_y = calculate_line(x1, y1, x2, y2)
  walls_line[wall_id] = {x1, y1, x2, y2, k, b, fx_atan2(y2 - y1, x2 - x1) % FX_PI, min_x, min_y, max_x, max_y}
  wall_id = wall_id + 1
  return wall_id - 1
end

function wall.add_polygon(...) -- more compact input for line walls
  local args = {...}
  for i = 4, #args, 2 do
    wall.add_line(args[i - 3], args[i - 2], args[i - 1], args[i])
  end
  wall.add_line(args[#args - 1], args[#args], args[1], args[2])
  return wall_id - #args / 2 - 1
end

function wall.add_circle(x, y, r) -- circle walls are calculated differently and are more optimized than bunch of walls in a circle
  walls_circle[wall_id] = {x, y, r}
  wall_id = wall_id + 1
  return wall_id - 1
end

function wall.remove(i1, i2) -- removes wall at index i1 or walls in range [i1; i2]
  for i = i1, i2 or i1 do
    walls_line[i] = nil
    walls_circle[i] = nil
  end
end

function wall.main() -- checks wall collisions and calls collision callbacks if they're specified
  for pid, p1 in pairs(wall.entities) do
    local e = entities[pid]
    Ax, Ay = p1[1], p1[2] -- previous position
    Bx, By = e[i_x], e[i_y] -- new required position
    if Ax == Bx and Ay == By then -- entity hasn't moved, skip
      goto wmce
    end
    ABk, ABb, ABmin_x, ABmin_y, ABmax_x, ABmax_y = calculate_line(Ax, Ay, Bx, By)
    ABdx, ABdy = Bx - Ax, By - Ay
    ABa = fx_atan2(ABdy, ABdx)
    --local callback = e[i_type].wall_collision ~= true and e[i_type].wall_collision or nil
    
    check_wall_collisions()
    
    e[i_x], e[i_y] = Rx, Ry
    wall.entities[pid][1] = Rx
    wall.entities[pid][2] = Ry
    ::wmce:: -- wall main continue end
  end
end
