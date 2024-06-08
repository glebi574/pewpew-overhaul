--PPO_NDEBUG = true
PPO_DEF_PLAYER = true
PPO_DEF_BULLET = true
require'/dynamic/ppo/.lua'

set_camera_z(-500fx)

--add_memory_print()
entity.load_types('tests', 'example', 'line')
local e = example.new(70fx, 70fx)

local function add_wall(x1, y1, x2, y2)
  wall.add_line(x1, y1, x2, y2)
  line.new(x1, y1, x2, y2, 0x00ff00ff)
end

add_wall(-80fx, 80fx, 80fx, 80fx)
add_wall(82fx, -80fx, 82fx, 100fx)
add_wall(80fx, -80fx, 80fx, 100fx)

add_wall(-120fx, 40fx, 40fx, -40fx)
add_wall(-120fx, -40fx, 40fx, 40fx)

add_wall(-40fx, -80fx, 40fx, -160fx)
add_wall(40fx, -80fx, -40fx, -160fx)

add_update_callback(function()
  set_camera_pos(e:get_pos())
end)