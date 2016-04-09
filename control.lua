
require "defines"

f_pvp = {}

function f_pvp.generate_resource(name, location, dx, dy)
  local surface = game.surfaces["nauvis"]
  for y=-2,2 do
    for x=-2,2 do
      surface.create_entity({name=name,
          amount=5000,
          position={location.x+x+dx, location.y+y+dy}
        })
    end
  end
end

function f_pvp.generate_resources(faction)
  f_pvp.generate_resource("stone", faction.starting_position, 20, 0)
  f_pvp.generate_resource("iron-ore", faction.starting_position, -20, 0)
  f_pvp.generate_resource("copper-ore", faction.starting_position, 0, -20)
  f_pvp.generate_resource("coal", faction.starting_position, 0, 20)
end

function f_pvp.assign_faction(player, faction)

  player.color = faction.color
  player.force = faction.force
  player.teleport(faction.starting_position)
  if not faction.start_ready then
    faction.clear_until = game.tick + 60 * 10
    faction.init_period = true
  end

end

function f_pvp.on_init()

  game.disable_tips_and_tricks()

  local tiles = {}
  for x=-20,20,1 do
    for y=-20,20,1 do
      table.insert(tiles, {
        name = "deepwater",
        position = { x, y}
      })
    end
  end
  for x=-12,12,1 do
    for y=-12,12,1 do
      table.insert(tiles, {
        name = "water",
        position = { x, y}
      })
    end
  end
  for x=-10,10,1 do
    for y=-10,10,1 do
      table.insert(tiles, {
        name = "grass",
        position = { x, y}
      })
    end
  end
  for x=-7,7,1 do
    for y=-7,7,1 do
      table.insert(tiles, {
        name = "concrete",
        position = { x, y}
      })
    end
  end

 local surface = game.get_surface("nauvis")
 surface.set_tiles(tiles)

 surface.create_entity({
   name = "stone-wall",
   position = { x = 6,  y = 6},
   force=game.forces.neutral
 })
 surface.create_entity({
   name = "stone-wall",
   position = { x = -6,  y = 6},
   force=game.forces.neutral
 })
 surface.create_entity({
   name = "stone-wall",
   position = { x = 6,  y = -6},
   force=game.forces.neutral
 })
 surface.create_entity({
   name = "stone-wall",
   position = { x = -6,  y = -6},
   force=game.forces.neutral
 })

  global.factions = {
    blue = {
      color = {r = 0, g = 0, b = 1, a = 0.9},
      starting_position = { x = 0 , y = -800},
      chest =  surface.create_entity({
            name = "logistic-chest-requester",
            position = { x = 0, y = -4 },
            force=game.forces.neutral
          })
    },
    red = {
      color = {r = 0.3, g = 1.0, b = 0.2, a = 0.5},
      starting_position = {x = 0 , y = 800},
      chest =  surface.create_entity({
            name = "logistic-chest-passive-provider",
            position = { x = 0, y = 4 },
            force=game.forces.neutral
          })
    },
    purple = {
      color = {r = 0.5, g = 0.1, b = 1, a = 0.8},
      starting_position = {x = -800 , y = 0},
      chest =  surface.create_entity({
            name = "logistic-chest-active-provider",
            position = { x = -4, y = 0 },
            force=game.forces.neutral
          })
    },
    yellow = {
      color = {r = 0.74, g = 0.71, b = 0.42, a = 0.5},
      starting_position = {x = 800 , y = 0},
      chest =  surface.create_entity({
            name = "logistic-chest-storage",
            position = { x = 4, y = 0 },
            force=game.forces.neutral
          })
    }
  }

  for name, faction in pairs(global.factions) do

    faction.name = name
    faction.force = game.create_force(name)
    faction.start_ready = faction.start_ready or false
    faction.init_period = faction.init_period or false
  end

end

function f_pvp.on_load()

end

function f_pvp.on_player_created(event)

end

function f_pvp.on_tick(event)
  for i,player in ipairs(game.players) do
    local entity = player.opened
    if entity then
      for name, faction in pairs(global.factions) do
        if entity == faction.chest then
          f_pvp.assign_faction(player, faction)
        end
      end
    end
  end
  for name, faction in pairs(global.factions) do
    if (faction.init_period) then
      local sandbox_distance= 1000
      local location = faction.starting_position
      local box = {
        {location.x - sandbox_distance, location.y - sandbox_distance},
        {location.x + sandbox_distance, location.y + sandbox_distance}
      }
      local gremlins = game.get_surface("nauvis").find_entities_filtered({area = box, force= "enemy"})
      for key, gremlin in pairs(gremlins) do
        gremlin.destroy()
      end
      if game.tick > faction.clear_until then
          f_pvp.generate_resources(faction)
          faction.start_ready = true
          faction.init_period = nil
      end
    end
  end
end

script.on_init(f_pvp.on_init)
script.on_load(f_pvp.on_load)
script.on_event(defines.events.on_player_created, f_pvp.on_player_created)
script.on_event(defines.events.on_tick, f_pvp.on_tick)
