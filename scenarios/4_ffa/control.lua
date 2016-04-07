
require "defines"

f_pvp = {}

f_pvp.factions = {
  blue = {
    color = {r = 0, g = 0, b = 1, a = 0.9},
    starting_position = { x = -200 , y = -5000},
    chest = "blue_chest",
  },
  red = {
    color = {r = 1, g = 0, b = 0, a = 0.5},
    starting_position = {x = 50 , y = 5500},
    chest = "red_chest",
  },
  purple = {
    color = {r = 0.5, g = 0.1, b = 1, a = 0.8},
    starting_position = {x = -3490 , y = 160},
    chest = "purple_chest",
  },
  yellow = {
    color = {r = 189/255, g = 183/255, b = 107/255, a = 0.5},
    starting_position = {x = 4900 , y = 0},
    chest = "yellow_chest",
  }
}

f_pvp.init_faction = {}

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
    f_pvp.init_faction[faction.name] = faction
  end

end

function f_pvp.on_init()

  game.disable_tips_and_tricks()

  for name, faction in pairs(f_pvp.factions) do
    faction.name = name
    faction.chest = game.get_entity_by_tag(faction.chest)
    faction.force = game.create_force(name)
    faction.start_ready = false
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
      for name, faction in pairs(f_pvp.factions) do
        if entity == faction.chest then
          f_pvp.assign_faction(player, faction)
        end
      end
    end
  end
  for name, faction in pairs(f_pvp.init_faction) do
    local sandbox_distance= 1000
    local location = faction.starting_position
    local box = {
      {location.x - sandbox_distance, location.y - sandbox_distance},
      {location.x + sandbox_distance, location.y + sandbox_distance}
    }
    local gremlins = game.surfaces["nauvis"].find_entities_filtered({area = box, force= "enemy"})
    for key, gremlin in pairs(gremlins) do
      gremlin.destroy()
    end
    if game.tick > faction.clear_until then
        f_pvp.generate_resources(faction)
        faction.start_ready = true
        f_pvp.init_faction[name] = nil
    end
  end
end

script.on_init(f_pvp.on_init)
script.on_event(defines.events.on_player_created, f_pvp.on_player_created)
script.on_event(defines.events.on_tick, f_pvp.on_tick)
