local FX_PI2 = FX_PI / 2fx
local FX_PI3_4 = FX_PI + FX_PI2
local p = 0.64fx -- precision error, due to fx being inprecise on this level
local np = -p
local n = p * 2fx -- repulsion to not get stuck in wall
local Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, Qx, Qy, Hx, Hy
local ABk, ABb, CDk, CDb, AHk, AHb
local ABmin_x, ABmin_y, ABmax_x, ABmax_y, CDmin_x, CDmin_y, CDmax_x, CDmax_y
local ABdx, ABdy, QBdx, QBdy, QFdx, QFdy, AHdx, AHdy, ABl, QBl, QFl, AHl, ABa, QNa, QFa

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
    Qy = ABk * Qx + ABb
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
  QNdy, QNdx = fx_sincos(QNa)
  Ax, Ay = Qx + QNdx * n, Qy + QNdy * n
  
  if fx_abs(fx_abs(da) - FX_PI) < FX_PI2 then
    QFa = CDa + FX_PI
  else
    QFa = CDa
  end
  QBdx, QBdy = Bx - Qx, By - Qy
  QBl = fx_sqrt(QBdx * QBdx + QBdy * QBdy)
  QFl = fx_abs(QBl * fx_cos(da))
  QFdy, QFdx = fx_sincos(QFa)
  
  Bx = Ax + QFdx * QFl
  By = Ay + QFdy * QFl
  ABk, ABb, ABmin_x, ABmin_y, ABmax_x, ABmax_y = calculate_line(Ax, Ay, Bx, By)
  ABdx, ABdy = Bx - Ax, By - Ay
  ABa = fx_atan2(ABdy, ABdx)
  return true
end

local function check_wall_collisions()
  local tmp_walls = {}
  for wid, w in pairs(walls_line) do
    Cx, Cy, Dx, Dy, CDk, CDb, CDa, CDmin_x, CDmin_y, CDmax_x, CDmax_y = table.unpack(w)
    if not CDk then
      AHk = 0fx
      AHb = Ay
      Hx = Cx
      Hy = Ay
    elseif CDk == 0fx then
      AHk = false
      AHb = false
      Hx = Ax
      Hy = Cy
    else
      AHk = -1fx / CDk
      AHb = Ay - AHk * Ax
      Hx = (AHb - CDb) / (CDk - AHk)
      Hy = AHk * Hx + AHb
    end
    AHdx, AHdy = Hx - Ax, Hy - Ay
    AHl = fx_sqrt(AHdx * AHdx + AHdy * AHdy)
    if AHl <= ABl then
      table.insert(tmp_walls, {wid, AHl})
    end
  end
  if #tmp_walls == 0 then
    return true
  elseif #tmp_walls > 1 then
    table.sort(tmp_walls, function(a, b) return a[2] < b[2] end)
  end
  local has_collided = false
  for i, tmp_wall in ipairs(tmp_walls) do
    if check_wall_collision(tmp_wall[1]) then
      has_collided = true
      table.remove(tmp_walls, i)
      break
    end
  end
  if not has_collided or #tmp_walls == 0 then
    return true
  end
  for i, tmp_wall in ipairs(tmp_walls) do
    if check_wall_collision(tmp_wall[1]) then
      return nil
    end
  end
  return true
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
    ABl = fx_sqrt(ABdx * ABdx + ABdy * ABdy)
    local callback = e[i_type].wall_collision ~= true and e[i_type].wall_collision or nil
    
    if check_wall_collisions() then
      Ax, Ay = Bx, By
    end
    
    e[i_x], e[i_y] = Ax, Ay
    wall.entities[pid][1] = Ax
    wall.entities[pid][2] = Ay
    ::wmce:: -- wall main continue end
  end
end
