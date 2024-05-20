entities = {}

entity_groups = {}

entity = {}

entity.types = {}

entity.amount = 0 -- entity counter

local tmp_path = 0 -- stores latest path to folder with types
local ppo_id = 1 -- ppo id counter, they're used instead of pewpew ids to store ppo entities. pewpew features are still accessed through pewpew ids
local key_id = 1 -- key id counter, they're used to automatically index created key, so they don't overlap in case you want to use entities with custom keys, created by other creators

local entity_proto = ppo_grequire'entity_proto' -- prototype for every entity
local entity_proto_mt = {__index = entity_proto}
local proto_mt = {} -- metatables for prototypes

local function create_entity(type, ...) -- creates entity
  local pid = ppo_id
  ppo_id = ppo_id + 1
  entity.amount = entity.amount + 1
  local e = {}
  e[i_pid] = pid
  e[i_type] = type
  if type.proto then
    setmetatable(e, proto_mt[type[i_name]])
  else
    setmetatable(e, entity_proto_mt)
  end
  if type.constructor then
    type.constructor(e, ...)
  end
  
  entities[pid] = e
  if type.groups then
    for _, group_name in ipairs(type.groups) do
      entity_groups[group_name][pid] = e
    end
  end
  return e
end

local function maintain_type(type_name) -- defines type, maintains other things depending on type contents
  type_path = string.format('%s/%s/', tmp_path, type_name) -- global name with path to folder with type, that exists while it's being loaded
  local type = require(string.format('%stype', type_path)) -- /dynamic/path/type_name/type.lua
  type[i_name] = type_name
  entity.types[type_name] = type
  
  if type.proto then
    setmetatable(type.proto, entity_proto_mt)
    proto_mt[type_name] = {__index = type.proto}
  end
  
  local gtype = {} -- global type with new() and variables, specified by type
  function gtype.new(...)
    return create_entity(type, ...)
  end
  if type.extern then
    for key, value in pairs(type.extern) do
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
    entity.types[type_name] = nil
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

function entity.main() -- maintains ai of all entities
  for _, e in pairs(entities) do
    if e[i_type].ai then
      e[i_type].ai(e)
    end
    if e[i_id] then
      entity_set_pos(e[i_id], e[i_x], e[i_y])
    end
  end
end
