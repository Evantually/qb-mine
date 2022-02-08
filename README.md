# qb-mine
Major refactor of qb-mine from https://github.com/izMystic

Mining for QB-Core ⛏️

Original verison from https://github.com/ALONE-OP/qb-mine


**Add to qb-shops/config.lua**

*Add into Config.Products*
```
    ["mining"] = {
        [1] = {
            name = 'pickaxe',
            price = 150,
            amount = 200,
            info = {},
            type = 'item',
            slot = 1,
        },
        [2] = {
            name = 'sifter',
            price = 150,
            amount = 200,
            info = {},
            type = 'item',
            slot = 2,
        },
    },
```
*Add into Config.Locations*
```
    ["miningshop"] = {
        ["label"] = "Mining Supplies",
        ["type"] = "mining",
        ["coords"] = {
            [1] = vector3(2832.1, 2797.67, 57.47),
        },
        ["products"] = Config.Products["mining"],
        ["showblip"] = true,
    },
```

**Add to qb-core/shared.lua**

*Add into QBShared.Items*
```
    ["charcoal"]					= {["name"] = "charcoal",       		    	["label"] = "Charcoal",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "Charcoal.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Haha, burninatored."},
    ["sulfur"]						= {["name"] = "sulfur",       		    		["label"] = "Sulfur",	 				["weight"] = 100, 		["type"] = "item", 		["image"] = "Sulfur.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Yep. Smells like sulfur."},
	["pickaxe"]						= {["name"] = "pickaxe",       		    		["label"] = "Pickaxe",	 				["weight"] = 1000, 		["type"] = "item", 		["image"] = "Pickaxe.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "I pick you."},
	["sifter"]						= {["name"] = "sifter",       		    		["label"] = "Sifting Pan",	 			["weight"] = 1000, 		["type"] = "item", 		["image"] = "SiftingPan.png", 			["unique"] = true, 		["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Sifter the better picker upper."},
	["raw_ore"]						= {["name"] = "raw_ore",       		    		["label"] = "Raw Ore",	 				["weight"] = 5000, 		["type"] = "item", 		["image"] = "RawOre.png", 				["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Should probably wash this first."},
	["unrefined_ore"]				= {["name"] = "unrefined_ore",       		    ["label"] = "Unrefined Ore",	 		["weight"] = 5000, 		["type"] = "item", 		["image"] = "UnRefinedOre.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "Why yes, this ore is utterly lower class."},
```