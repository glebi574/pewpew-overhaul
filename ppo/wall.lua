local FX_PI2 = FX_PI / 2fx
local FX_PI3_4 = FX_PI + FX_PI2
local p = 0.64fx -- precision error
local np = -p
local n = p * 2fx -- repulsion off the wall to prevent getting stuck in it
local Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, Qx, Qy, Rx, Ry
local ABk, ABb, CDk, CDb
local ABmin_x, ABmin_y, ABmax_x, ABmax_y, CDmin_x, CDmin_y, CDmax_x, CDmax_y
local ABdx, ABdy, AQdx, AQdy, QBdx, QBdy, QNdx, QNdy, QFdx, QFdy, AQl, QBl, QFl, ABa, QNa, QFa

local __p1 = 64fx
local __p2 = 4096fx

wall = {}

local walls_line = {}
local walls_circle = {}

wall.entities = {} -- entity info for collision processing. Positions are buffered here

local wall_id = 0 -- id counter for walls

local function calculate_line(x1, y1, x2, y2)
  local dx, dy = x2 - x1, y2 - y1
  local a = fx_atan2(dy, dx)
  local k, b = false, false
  if x1 ~= x2 then
    k = dy / dx
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
  return k, b, min_x, min_y, max_x, max_y, dx, dy, a
end

local function check_wall_line_collision(wid)
  Cx, Cy, Dx, Dy, CDk, CDb, CDa, CDmin_x, CDmin_y, CDmax_x, CDmax_y = table.unpack(walls_line[wid])
  if ABk == CDk then -- movement is parallel, skip
    return
  end
  if not ABk then
    Qx = Ax
    Qy = CDk * Qx + CDb
  elseif not CDk then
    Qx = Cx
    Qy = ABk * Qx + ABb
  else
    Qx = (CDb - ABb) / (ABk - CDk)
    Qy = (__p2 * ABb * CDk - __p2 * CDb * ABk) / (CDk - ABk) / __p2
  end
  
  if Qx < ABmin_x or Qx > ABmax_x or
     Qx < CDmin_x or Qx > CDmax_x or
     Qy < ABmin_y or Qy > ABmax_y or
     Qy < CDmin_y or Qy > CDmax_y then -- point doesn't belong to both lines, skip
    return
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

local function check_wall_circle_collision(wid)
  local Ox, Oy, OQl, OQl2 = table.unpack(walls_circle[wid]) -- OQl is radius
  local Ax, Ay, Bx, By = Ax - Ox, Ay - Oy, Bx - Ox, By - Oy
  local ABk, ABb, ABmin_x, ABmin_y, ABmax_x, ABmax_y, ABdx, ABdy, ABa = calculate_line(Ax, Ay, Bx, By)
  local ABl_p1 = fx_sqrt(__p2 * ABdx * ABdx + __p2 * ABdy * ABdy)
  if __p1 * fx_abs(Ax * By - Bx * Ay) / ABl_p1 >= OQl then -- movement line intersects circle 0 or 1 times
    return
  end
  
  local Qx1, Qy1, Qx2, Qy2 -- calculate intersections between movement line and circular wall
  if not ABk then
    local tv = OQl2 - Ax * Ax
    if tv < 0fx then
      return
    end
    local v = fx_sqrt(tv)
    Qx1, Qy1, Qx2, Qy2 = Ax, v, Ax, -v
  elseif ABk == 0fx then
    local tv = OQl2 - Ay * Ay
    if tv < 0fx then
      return
    end
    local v = fx_sqrt(tv)
    Qx1, Qy1, Qx2, Qy2 = v, Ay, -v, Ay
  elseif ABb == 0fx then
    local v = __p1 * OQl / fx_sqrt(__p2 * ABk * ABk + __p2)
    Qx1, Qy1, Qx2, Qy2 = v, ABk * v, -v, -ABk * v
  else
    local v1 = ABk * ABk + 1fx
    local tv1 = OQl2 * v1 - ABb * ABb
    if tv1 < 0fx then
      return
    end
    local v2 = fx_sqrt(tv1)
    local v3 = -ABk * ABb
    Qx1, Qx2 = (v3 + v2) / v1, (v3 - v2) / v1
    Qy1, Qy2 = ABk * Qx1 + ABb, ABk * Qx2 + ABb
  end
  
  local not_Qx1 = false
  if Qx1 < ABmin_x or Qx1 > ABmax_x or
     Qy1 < ABmin_y or Qy1 > ABmax_y then -- point doesn't belong to AB, check second point
    not_Qx1 = true
  end
  if not_Qx1 then
    if Qx2 < ABmin_x or Qx2 > ABmax_x or
       Qy2 < ABmin_y or Qy2 > ABmax_y then -- point doesn't belong to AB, skip
      return
    end
    Qx, Qy = Qx2, Qy2
  else
    Qx, Qy = Qx1, Qy1
  end
  if Ax * Ax + Ay * Ay > OQl2 then
    QNa = fx_atan2(Qy, Qx)
  else
    QNa = fx_atan2(-Qy, -Qx)
  end
  local QFaa = fx_sin(QNa + FX_PI - ABa) * ABl_p1 / OQl / __p1
  if fx_abs(fx_abs(ABa - QNa - FX_PI2) - FX_PI) < FX_PI2 then
    QFa = QNa - FX_PI2 - QFaa
  else
    QFa = QNa + FX_PI2 - QFaa
  end
  Qx, Qy = Qx + Ox, Qy + Oy
  return Qx, Qy, QNa, QFa
end

local function check_wall_collision(wid)
  if walls_line[wid] then
    return check_wall_line_collision(wid)
  else
    return check_wall_circle_collision(wid)
  end
end

local function get_wall_collisions()
  local collisions = {}
  for wid, wall in pairs(walls_line) do
    if check_wall_collision(wid) then
      table.insert(collisions, {Qx, Qy, QNa, QFa})
    end
  end
  for wid, wall in pairs(walls_circle) do
    if check_wall_collision(wid) then
      table.insert(collisions, {Qx, Qy, QNa, QFa})
    end
  end
  return collisions
end

local function get_closest_wall_collision(collisions)
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
  return collisions[min_i]
end

local function get_wall_point()
  AQdx, AQdy = Qx - Ax, Qy - Ay
  AQl = fx_sqrt(__p2 * AQdx * AQdx + __p2 * AQdy * AQdy) / __p1 - n
  AQdy, AQdx = fx_sincos(ABa)
  return Ax + AQdx * AQl, Ay + AQdy * AQl
end

local max_collisions = 5
local function check_wall_collisions()
  local i = 0
  local tAx, tAy = Ax, Ay
  while i < max_collisions do
    local collisions = get_wall_collisions()
    if #collisions == 0 then
      return
    elseif #collisions == 1 then
      Qx, Qy, QNa, QFa = collisions[1][1], collisions[1][2], collisions[1][3], collisions[1][4]
    else
      local collision = get_closest_wall_collision(collisions)
      Qx, Qy, QNa, QFa = collision[1], collision[2], collision[3], collision[4]
      local is_corner = false
      for i = 1, #collisions do
        if collisions[i] ~= collision and collisions[i][1] == Qx and collisions[i][2] == Qy then
          is_corner = true
          break
        end
      end
      if is_corner then
        Bx, By = get_wall_point()
        return
      end
    end
    
    if i == 0 then
      QNdy, QNdx = fx_sincos(QNa)
      QBdx, QBdy = Bx - Qx, By - Qy
      QBl = fx_sqrt(QBdx * QBdx + QBdy * QBdy)
      QBl = fx_abs(QBl * fx_cos(ABa - QNa - FX_PI2))
      QFdy, QFdx = fx_sincos(QFa)
      Bx = Qx + QNdx * n + QFdx * QBl
      By = Qy + QNdy * n + QFdy * QBl
      Ax, Ay = get_wall_point()
    else
      Bx, By = get_wall_point()
    end
    
    if Ax == Bx and Ay == By then
      return
    end
    
    ABk, ABb, ABmin_x, ABmin_y, ABmax_x, ABmax_y, ABdx, ABdy, ABa = calculate_line(Ax, Ay, Bx, By)
    
    i = i + 1
  end
  if i == max_collisions then
    Bx, By = tAx, tAy
  end
end

function wall.add_line(x1, y1, x2, y2)
  local k, b, min_x, min_y, max_x, max_y = calculate_line(x1, y1, x2, y2)
  wall_id = wall_id + 1
  walls_line[wall_id] = {x1, y1, x2, y2, k, b, fx_atan2(y2 - y1, x2 - x1) % FX_PI, min_x, min_y, max_x, max_y}
  return wall_id
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
  wall_id = wall_id + 1
  walls_circle[wall_id] = {x, y, r, r * r}
  return wall_id
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
      goto __wmce
    end
    ABk, ABb, ABmin_x, ABmin_y, ABmax_x, ABmax_y, ABdx, ABdy, ABa = calculate_line(Ax, Ay, Bx, By)
    --local callback = e[i_type].wall_collision ~= true and e[i_type].wall_collision or nil
    
    check_wall_collisions()
    
    e[i_x], e[i_y] = Bx, By
    wall.entities[pid][1] = Bx
    wall.entities[pid][2] = By
    ::__wmce::
  end
end
