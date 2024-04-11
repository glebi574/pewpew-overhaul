entities = {}

entity_groups = {}

entity = {}

entity.types = {},

function entity.load_types(path, ...)
  for _, entity_type_name in ipairs{...} do
    entity_type_path = path .. type_name
    local type = require(entity_type_path)
    entity.types[type.name] = type
  end
  entity_type_path = nil
end
