local _t = type
for key, value in pairs(math) do
  _ENV[key] = value
end
mtype = type
type = _t
_t = nil

PI = pi
TAU = pi * 2
INT_HUGE = huge
INT_MIN = mininteger
INT_MAX = maxinteger

function round(a)
  return (a + 0.5) // 1
end

pi, huge, maxinteger, mininteger = nil, nil, nil, nil
rmn'math'


local mesh_proto = {}
local mesh_proto_mt = {__index = mesh_proto}

function def_mesh(v, s, c)
  local mesh = {vertexes = v or {}, segments = s or {}, colors = c or {}}
  setmetatable(mesh, mesh_proto_mt)
  return mesh
end

function def_meshes(n)
  meshes = {}
  n = n or 0
  for i = 1, n do
    table.insert(meshes, def_mesh())
  end
end

function get_vsc(v)
  local t = type(v)
  if t == 'number' then
    return meshes[v].vertexes, meshes[v].segments, meshes[v].colors
  elseif t == 'table' then
    return v.vertexes, v.segments, v.colors
  else
    return {}, {}, {}
  end
end

function rotate_vector(x, y, z, rx, ry, rz)
  local l, angle
  
  l = math.sqrt(y ^ 2 + z ^ 2)
  angle = math.atan(z, y) + rx
  y = l * cos(angle)
  z = l * sin(angle)
  
  l = math.sqrt(x ^ 2 + z ^ 2)
  angle = math.atan(z, x) + ry
  x = l * cos(angle)
  z = l * sin(angle)
  
  l = math.sqrt(x ^ 2 + y ^ 2)
  angle = math.atan(y, x) + rz
  x = l * cos(angle)
  y = l * sin(angle)
  
  return x, y, z
end

function rotate_mesh(mesh, rx, ry, rz)
  for i, vertex in ipairs(mesh.vertexes) do
    mesh.vertexes[i] = {rotate_vector(vertex[1], vertex[2], vertex[3] or 0, rx, ry, rz)}
  end
end

function add_colors(mesh, c, n)
  local t = type(c)
  if t == 'number' then
    for i = 1, n do
      table.insert(mesh.colors, c)
    end
  elseif t == 'table' then
    for i = 1, n do
      table.insert(mesh.colors, c[i])
    end
  elseif t == 'function' then
    for i = 1, n do
      table.insert(mesh.colors, c(i))
    end
  end
end

function add_lines(mesh, c, ...)
  local args = {...}
  local index = #mesh.vertexes
  for i = 1, #args, 2 do
    table.insert(mesh.vertexes, args[i])
    table.insert(mesh.vertexes, args[i + 1])
    table.insert(mesh.segments, {index + i - 1, index + i})
  end
  add_colors(mesh, c, #args)
end

function add_polygon(mesh, c, ...)
  local args = {...}
  local s = {}
  local index = #mesh.vertexes
  for i = index, index + #args - 1 do
    table.insert(s, i)
  end
  table.insert(s, index)
  table.insert(mesh.segments, s)
  for _, vertex in ipairs(args) do
    table.insert(mesh.vertexes, vertex)
  end
  
  add_colors(mesh, c, #args)
end

function add_curve(mesh, c, ...)
  add_polygon(mesh, c, ...)
  table.remove(mesh.segments[#mesh.segments], #mesh.segments[#mesh.segments])
end

function add_circle(mesh, c, offset, r, precision, rx, ry, rz)
  rx, ry, rz = rx or 0, ry or 0, rz or 0
  local x, y, z
  if offset then
    x, y, z = offset[1] or 0, offset[2] or 0, offset[3] or 0
  else
    x, y, z = 0, 0, 0
  end
  local da = TAU / precision
  local v = {}
  for i = 0, precision - 1 do
    local a = da * i
    local vertex = {rotate_vector(cos(a) * r, sin(a) * r, 0, rx, ry, rz)}
    vertex[1], vertex[2], vertex[3] = vertex[1] + x, vertex[2] + y, vertex[3] + z
    table.insert(v, vertex)
  end
  add_polygon(mesh, c, table.unpack(v))
end

function copy_vertexes(v, mod)
  local nv = {}
  if mod then
    for i, vertex in ipairs(v) do
      table.insert(nv, mod(i, vertex))
    end
  else
    for i, vertex in ipairs(v) do
      table.insert(nv, vertex)
    end
  end
  return nv
end

function copy_segments(s)
  local ns = {}
  for i = 1, #s do
    local segment = {}
    for n = 1, #s[i] do
      table.insert(segment, s[i][n])
    end
    table.insert(ns, segment)
  end
  return ns
end

function copy_colors(c)
  local nc = {}
  for i, color in ipairs(c) do
    table.insert(nc, color)
  end
  return nc
end

function insert_vertexes(fv, tv, mod)
  if mod then
    for i, vertex in ipairs(fv) do
      table.insert(tv, mod(i, vertex))
    end
  else
    for i, vertex in ipairs(fv) do
      table.insert(tv, vertex)
    end
  end
end

function insert_segments(fs, ts, index_offset)
  index_offset = index_offset or 0
  for i = 1, #fs do
    local segment = {}
    for n = 1, #fs[i] do
      table.insert(segment, fs[i][n] + index_offset)
    end
    table.insert(ts, segment)
  end
end

function insert_colors(fc, tc)
  for i, color in ipairs(fc) do
    table.insert(tc, color)
  end
end

function copy_mesh(mesh, modv)
  return def_mesh(copy_vertexes(mesh.vertexes, modv), copy_segments(mesh.segments), copy_colors(mesh.colors))
end

function insert_mesh(fmesh, tmesh, modv)
  local fv, fs, fc = get_vsc(fmesh)
  local tv, ts, tc = get_vsc(tmesh)
  local index_offset = #tv
  insert_vertexes(fv, tv, modv)
  insert_segments(fs, ts, index_offset)
  insert_colors(fc, tc)
end


function mesh_proto:get_vsc()
  return get_vsc(self)
end

function mesh_proto:rotate(rx, ry, rz)
  return rotate_mesh(self, rx, ry, rz)
end

function mesh_proto:add_colors(c, n)
  return add_colors(self, c, n)
end

function mesh_proto:add_lines(c, ...)
  return add_lines(self, c, ...)
end

function mesh_proto:add_polygon(c, ...)
  return add_polygon(self, c, ...)
end

function mesh_proto:add_curve(c, ...)
  return add_curve(self, c, ...)
end

function mesh_proto:add_circle(c, offset, r, precision, rx, ry, rz)
  return add_circle(self, c, offset, r, precision, rx, ry, rz)
end

function mesh_proto:copy_vertexes(mod)
  return copy_vertexes(self.vertexes, mod)
end

function mesh_proto:copy_segments()
  return copy_segments(self.segments)
end

function mesh_proto:copy_colors()
  return copy_colors(self.colors)
end

function mesh_proto:insert_vertexes(fv, mod)
  return insert_vertexes(fv, self.vertexes, mod)
end

function mesh_proto:insert_segments(fs, index_offset)
  return insert_segments(fs, self.segments, index_offset)
end

function mesh_proto:insert_colors(fc)
  return insert_colors(fc, self.colors)
end

function mesh_proto:copy(modv)
  return copy_mesh(self, modv)
end

function mesh_proto:insert(fmesh, modv)
  return insert_mesh(fmesh, self, modv)
end
