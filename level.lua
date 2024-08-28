--PPO_NDEBUG = true
PPO_DEF_PLAYER = true
PPO_DEF_BULLET = true
require'/dynamic/ppo/.lua'

set_camera_z(-500fx)

--add_memory_print()
entity.load_types('tests', 'example', 'line', 'circle')
local e = example.new(-170fx, -120fx)

local function add_wall(x1, y1, x2, y2)
  wall.add_line(x1, y1, x2, y2)
  line.new(x1, y1, x2, y2, 0x00ff00ff)
end


-- add_wall(-80fx, 80fx, 80fx, 80fx)
-- add_wall(82fx, -80fx, 82fx, 100fx)
-- add_wall(80fx, -80fx, 80fx, 100fx)

-- add_wall(-60fx, 20fx, 0fx, -20fx)
-- add_wall(-60fx, -20fx, 0fx, 20fx)

-- add_wall(-300fx, 20fx, -100fx, -20fx)
-- add_wall(-300fx, -20fx, -100fx, 20fx)

-- add_wall(-100fx, -80fx, -80fx, -180fx)
-- add_wall(-80fx, -80fx, -100fx, -180fx)

-- add_wall(-40fx, -80fx, 40fx, -160fx)
-- add_wall(40fx, -80fx, -40fx, -160fx)

-- add_wall(-160fx, -100fx, -180fx, -80fx)
-- add_wall(-180fx, -80fx, -210fx, -140fx)
-- add_wall(-210fx, -140fx, -170fx, -120fx)
-- add_wall(-170fx, -120fx, -160fx, -100fx)

-- add_wall(-20fx, 100fx, -40fx, 160fx)
-- add_wall(-40fx, 100fx, -20fx, 160fx)
-- add_wall(0fx, 130fx, -60fx, 130fx)


local function add_wall_circle(x, y, r)
  wall.add_circle(x, y, r)
  circle.new(x, y, r, 0x00ff00ff)
end

-- __l1 = line.new(0fx, 0fx, 0fx, 0fx, 0xa0ff00ff)
-- __l2 = line.new(0fx, 0fx, 0fx, 0fx, 0xffa000ff)


add_wall_circle(40fx, 0fx, 80fx)
add_wall_circle(20fx, 40fx, 60fx)

add_wall_circle(30fx, 30fx, 10fx)

add_wall_circle(-180fx, 10fx, 40fx)

add_wall_circle(-180fx, -80fx, 40fx)
add_wall_circle(-170fx, -100fx, 40fx)
add_wall_circle(-190fx, -130fx, 40fx)

add_wall_circle(20fx, -190fx, 100fx)

add_wall(-120fx, -230fx, 120fx, -150fx)

add_wall(-20fx, 40fx, -10fx, -20fx)
add_wall(-20fx, 40fx, 20fx, 30fx)

add_wall(50fx, 50fx, 100fx, 120fx)
add_wall(100fx, 120fx, 30fx, -20fx)


add_update_callback(function()
  set_camera_pos(e:get_pos())
end)