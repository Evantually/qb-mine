Config = {}

Config.Peds = {
    [1] = {
        {
            model = 's_m_y_construct_02', 
            coords = vector4(2832.1, 2797.67, 57.47, 107.5),
            minusOne = true, 
            freeze = true, 
            invincible = true, 
            blockevents = true,
            spawnNow = true,
            target = { 
                options = {
                    {
                        type = "client",
                        event = "qb-shops:marketshop",
                        icon = "fas fa-shopping-basket",
                        label = "Shop",
                    },
                },
                distance = 3.0,
            },
            currentpednumber = 456,
        },
    }
}

Config.MiningItems = {
    [1] = {
        name = "raw_ore",
        threshold = 80,
        max = 2,
        remove = nil,
    },
    [2] = {
        name = "sulfur",
        threshold = 10,
        max = 1,
        remove = nil,
    },
    [3] = {
        name = "charcoal",
        threshold = 10,
        max = 1,
        remove = nil,
    },
}

Config.WashingItems = {
    [1] = {
        name = "unrefined_ore",
        threshold = 100,
        max = 1,
        remove = "raw_ore",
    },
}

Config.SmeltingItems = {
    [1] = {
        name = "steel",
        threshold = 80,
        max = 5,
        remove = "unrefined_ore",
    },
    [2] = {
        name = "iron",
        threshold = 90,
        max = 5,
        remove = "unrefined_ore",
    },
    [3] = {
        name = "aluminum",
        threshold = 100,
        max = 5,
        remove = "unrefined_ore",
    },
    [4] = {
        name = "copper",
        threshold = 75,
        max = 5,
        remove = "unrefined_ore",
    },
    [5] = {
        name = "metalscrap",
        threshold = 50,
        max = 5,
        remove = "unrefined_ore",
    },
}

Config.Blips = {
    {
        blippoint = vector3(-596.69, 2091.14, 131.41),
        blipsprite = 618,
        blipscale = 0.65,
        blipcolour = 46,
        label = "Mining"
    },
    {
        blippoint = vector3(2995.55, 2755.57, 43.13),
        blipsprite = 618,
        blipscale = 0.65,
        blipcolour = 46,
        label = "Mining"
    },
    {
        blippoint = vector3(1878.93, 280.84, 164.27),
        blipsprite = 651,
        blipscale = 0.65,
        blipcolour = 29,
        label = "Washing"
    },
    {
        blippoint = vector3(1061.71, -1978.43, 31.24),
        blipsprite = 436,
        blipscale = 0.65,
        blipcolour = 47,
        label = "Smelting"
    },
}

Config.Mining = {
    {
        zones = { 
            vector2(-597.28, 2086.87),
            vector2(-588.52, 2045.77),
            vector2(-586.15, 2057.61),
            vector2(-593.4, 2088.1),
        },
        minz = 129.0,
        maxz = 133.0,
    },
    {
        zones = { 
            vector2(2999.2, 2788.98),
            vector2(2999.34, 2770.62),
            vector2(2992.09, 2758.36),
            vector2(2973.34, 2746.92),
            vector2(2974.53, 2737.47),
            vector2(2998.57, 2750.98),
            vector2(3009.2, 2761.61),
            vector2(3004.96, 2782.89),
            vector2(3004.48, 2788.89),
            vector2(2971.42, 2847.16),
            vector2(2950.34, 2854.85),
            vector2(2935.12, 2848.06),
            vector2(2936.81, 2844.47),
            vector2(2960.0, 2848.13),
        },
        minz = 42.0,
        maxz = 50.0,
    },
    {
        zones = {
            vector2(2958.09, 2729.37),
            vector2(2944.26, 2742.69),
            vector2(2913.93, 2790.51),
            vector2(2924.39, 2815.57),
            vector2(2920.55, 2820.08),
            vector2(2903.94, 2784.89),
            vector2(2931.71, 2753.24),
            vector2(2948.64, 2722.04),
        },
        minz = 42.0,
        maxz = 50.0,
    }
}

Config.Washing = {
    {
        zones = {
            vector2(1924.82, 184.32),
            vector2(1941.13, 437.75),
            vector2(1809.62, 438.01),
            vector2(1834.92, 232.85),
        },
        minz = 160.0,
        maxz = 164.0,
    },
}

Config.Smelting = {
    {
        zones = {
            vector2(1086.54, -1998.91),
            vector2(1081.77, -2004.63),
            vector2(1086.33, -2008.35),
            vector2(1091.17, -2003.12),
        },
        minz = 30.0,
        maxz = 32.0,
    },
    {
        coords = vector3(1062.88, -1970.36, 31.01),
        zones = {
            vector2(1107.44, -2009.56),
            vector2(1111.94, -2012.89),
            vector2(1114.98, -2008.12),
            vector2(1109.89, -2005.25),
        },
        minz = 30.0,
        maxz = 32.0,
    },
}