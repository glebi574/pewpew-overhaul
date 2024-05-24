--PPO_NDEBUG = true
PPO_DEF_PLAYER = true
PPO_DEF_BULLET = true
require'/dynamic/ppo/.lua'

set_camera_z(1500fx)

--add_memory_print()
entity.load_types('tests', 'example', 'line')
example.new(0fx, 0fx)

local function add_wall(x1, y1, x2, y2)
  wall.add_line(x1, y1, x2, y2)
  line.new(x1, y1, x2, y2)
end

add_wall(-80fx, 80fx, 80fx, 80fx)
add_wall(80fx, -80fx, 80fx, 80fx)
add_wall(-120fx, 40fx, 40fx, -40fx)
add_wall(-120fx, -40fx, 40fx, 40fx)

add_update_callback(function()
  entity.main()
end)