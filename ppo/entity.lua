entities = {}

entity_groups = {}

entity = {}

entity.amount = 0 -- entity counter

local tmp_path = 0 -- stores latest path to folder with types
local ppo_id = 1 -- ppo id counter, they're used instead of pewpew ids to store ppo entities. pewpew features are still accessed through pewpew ids
local key_id = 1 -- key id counter, they're used to automatically index created key, so they don't overlap in case you want to use entities with custom keys, created by other creators

local entity_proto = ppo_grequire'entity_proto' -- prototype for every entity
local entity_proto_mt = {__index = entity_proto}
local proto_mt = {} -- metatables for prototypes

local function create_entity(t, ...) -- creates entity
  local pid = ppo_id
  ppo_id = ppo_id + 1
  entity.amount = entity.amount + 1
  local e = {}
  e[i_pid] = pid
  e[i_type] = t
  if t.proto then
    setmetatable(e, proto_mt[t[i_name]])
  else
    setmetatable(e, entity_proto_mt)
  end
  if t.constructor then
    t.constructor(e, ...)
  end
  if t.wall_collision == true then
    wall.entities[pid] = {e[i_x], e[i_y]}
  end
  
  entities[pid] = e
  if t.groups then
    for _, group_name in ipairs(t.groups) do
      entity_groups[group_name][pid] = e
    end
  end
  return e
end

local function maintain_type(type_name) -- defines type, maintains other things depending on type contents
  type_path = string.format('%s/%s/', tmp_path, type_name) -- global name with path to folder with type, that exists while it's being loaded
  local t = require(string.format('%stype', type_path)) -- /dynamic/path/type_name/type.lua
  t[i_name] = type_name
  
  if t.proto then
    setmetatable(t.proto, entity_proto_mt)
    proto_mt[type_name] = {__index = t.proto}
  end
  
  local gtype = {} -- global type with new() and variables, specified by type
  gtype.type = t
  function gtype.new(...)
    return create_entity(t, ...)
  end
  if t.extern then
    for key, value in pairs(t.extern) do
      gtype[key] = value
    end
  end
  _ENV[type_name] = gtype
end

function entity.load_types(path, ...)
  tmp_path = path
  for _, type_name in ipairs{...} do
    maintain_type(type_name)
  end
  type_path = nil
end

function entity.unload_types(...) -- unloads resources, allocated for specified types
  for _, type_name in ipairs{...} do
    _ENV[type_name] = nil
  end
end

function entity.def_keys(...) -- defines key indexes
  for _, name in ipairs{...} do
    if _ENV[name] == nil then
      _ENV[name] = key_id
      key_id = key_id + 1
    end
  end
end

function entity.add_groups(...)
  for _, group_name in ipairs{...} do
    entity_groups[group_name] = {}
  end
end

function entity.main() -- maintains ai of all entities
  -- call ai
  for _, e in pairs(entities) do
    if e[i_type].ai then
      e[i_type].ai(e)
    end
  end
  -- process wall collisions
  wall.main()
  -- update positions
  for _, e in pairs(entities) do
    if e[i_id] then
      entity_set_pos(e[i_id], e[i_x], e[i_y])
    end
  end
  
end
