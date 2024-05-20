--PPO_NDEBUG = true
PPO_DEF_PLAYER = true
PPO_DEF_BULLET = true
require'/dynamic/ppo/.lua'

--add_memory_print()
entity.load_types('tests', 'example')
example.new(0fx, 0fx)

add_update_callback(function()
  entity.main()
end)