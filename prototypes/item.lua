data:extend(
  {
    {
      type = "item",
      name = "wood-stick",
      icon = "__flsw_factions__/graphics/icons/wood-stick.png",
      flags = {"goes-to-main-inventory"},
      subgroup = "intermediate-product",
      fuel_value = "1MJ",
      order = "a[sticks]-a[wood-stick]",
      stack_size = 100
    },
    {
      type = "mining-tool",
      name = "stone-axe",
      icon = "__flsw_factions__/graphics/icons/stone-axe.png",
      flags = { "goes-to-main-inventory" },
      {
        type="direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            type = "damage",
            damage = { amount = 1 , type = "physical"}
          }
        }
      },
      durability = 1500,
      subgroup = "tool",
      order = "a[mining]-a[stone-axe]",
      speed = 1.5,
      stack_size = 20
    },
    {
      type = "mining-tool",
      name = "copper-axe",
      icon = "__flsw_factions__/graphics/icons/copper-axe.png",
      flags = { "goes-to-main-inventory" },
      {
        type="direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            type = "damage",
            damage = { amount = 2 , type = "physical"}
          }
        }
      },
      durability = 600,
      subgroup = "tool",
      order = "a[mining]-b[copper-axe]",
      speed = 2,
      stack_size = 20
    },
  }
)
