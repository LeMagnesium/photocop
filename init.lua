minetest.register_node("photocop:photocopieuse_inactive", {
  description = "Photocopieuse",
  drawtype = "nodebox",
  paramtype = "light",
  tiles = {
    'photocopieuse2b.png',
    'photocopieuse2.png',
    'photocopieuse2.png',
    'photocopieuse2.png',
    'photocopieuse2.png',
    'photocopieuse.png',
  },
  groups = {oddly_breakable_by_hand = 2},
  selection_box = {
    type = 'fixed',
    fixed = {-0.5,-0.5,-0.5,0.5,0.5,0.5}
  },
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.375,0.25,0.25,0.125}, 
			{-0.375,-0.4375,-0.5,0.0625,0.125,-0.375}, 
			{0.25,-0.0625,-0.3125,0.5,0.0625,0.0625}, 
		}
	},
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    meta:set_string("infotext", "Photocopieuse")
    meta:set_string("formspec",
      "size[10,11]"..
      "list[context;phinput;2,1;1,1;]"..
      "list[context;phoutput;6,1;3,4;]"..
      "list[context;phpapin;1,4;2,1;]"..
      "list[context;phinkin;3,4;1,1;]"..
      "list[context;phinkout;4,4;1,1;]"..
      "list[current_player;main;1,6;8,4;]"..
      --"field[6.3,4.5;2,1;qttcopies;Copies : ;${qttcopies}]"..
      --"button[6,5;2,1;start;Start]"..
      "image[4,1;1,1;photocop_fleche.png]"..
      "image[1.5,3;1,1;default_paper.png]"..
      "image[3,3;1,1;photocop_ink.png]"..
      "image[4,3;1,1;vessels_glass_bottle_inv.png]"
      --"image[6,3;1,1;photocop_ink.png^photocop_ink_level_monitor_font.png]"..
      --"image[7,3;1,1;default_paper.png^photocop_ink_level_monitor_font.png]"
    )
	meta:set_int("tick",0)
	meta:set_int("qttcopies",0)
	meta:set_string("state","disabled")
	
    inv:set_size("phinput",1*1)
    inv:set_size("phoutput",3*4)
    inv:set_size("phpapin",2*1)
    inv:set_size("phinkin",1*1)
    inv:set_size("phinkout",1*1)
  end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    if listname == "phinput" and stack:get_name() == "memorandum:letter" then return stack:get_count() end
    if listname == "phoutput" then return 0 end
    if listname == "phpapin" and stack:get_name() == "default:paper" then return stack:get_count() end
    if listname == "phinkin" and stack:get_name() == "photocop:encre" then return stack:get_count() end
    if listname == "phinkout" then return 0 end
    return 0
  end,
  allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
    if from_list == "phpapin" then
      if to_list == "phpapin" then return count
      end
    end
    if from_list == "phoutput" then
      if to_list == "phoutput" then return count
      end
    end
    return 0
  end,
  can_dig = function(pos, player)
    local inv = minetest.get_meta(pos):get_inventory()
	return inv:is_empty("phinput") and inv:is_empty("phoutput") and inv:is_empty("phinkin") and inv:is_empty("phinkout") and inv:is_empty("phpapin")
  end,
})

minetest.register_craftitem("photocop:encre", {
  inventory_image = "photocop_ink.png",
  description = "Cartouche d'encre",
  stack_max = 99
})

minetest.register_craft({
  output = "photocop:encre 50",
  recipe = {
    {"default:stick"},
    {"default:coal_lump"},
    {"vessels:glass_bottle"}
  }
})

minetest.register_craft({
  output = "photocop:photocopieuse_inactive",
  recipe = {
    {"default:steelblock", "default:glass", "default:steelblock"},
    {"default:chest", "pipeworks:sand_tube_000000", "default:chest"},
    {"default:steelblock", "default:steelblock", "default:steelblock"}
  }
})

-- Alias vers une itemstring plus simple
minetest.register_alias ("photocop:photocop", "photocop:photocopieuse_inactive")

---------------------------------------
----- NOYAU DU MOD | MOD'S KERNEL -----
---------------------------------------

minetest.register_abm({
	nodenames = {"photocop:photocopieuse_inactive"},
	interval = 1,
	chance = 1,
	action = function (pos)
		local meta = minetest.get_meta(pos)
		local inv 	= meta:get_inventory()
		
		-- Update infotext
		local new_infotext = "Photocopieuse"
		if inv:is_empty("phinput") and inv:is_empty("phpapin") and inv:is_empty("phinkin") then
			new_infotext = "Photocopieuse"
		elseif not inv:is_empty("phinput") and not inv:is_empty("phinkout") and not inv:is_empty("phpapin") then
			new_infotext = "Photocopie.."
		elseif inv:is_empty("phinput") and (not inv:is_empty("phinkout") or not inv:is_empty("phoutput")) then
			new_infotext = "Take your objects please"
		elseif	inv:is_empty("phinput") then
			new_infotext = "Insert paper and/or ink.."
		end
		meta:set_string("infotext",new_infotext)
		
		-- Update tick
		if meta:get_int("tick") < 2 then 
			meta:set_int("tick", meta:get_int("tick")+1)
			return
		else meta:set_int("tick",0) end
		
		if not inv:is_empty("phpapin")
			and not inv:is_empty("phinput")
			and not inv:is_empty("phinkin")
			and inv:room_for_item("phoutput",{name = "memorandum:letter"})
			and inv:room_for_item("phinkout",{name = "vessels:glass_bottle"}) then
			
			local inputstack 	= inv:get_list("phinput")[1]
			local outputstacks	= inv:get_list("phoutput")
			local papinstacks	= inv:get_list("phpapin")
			local inkinstack	= inv:get_list("phinkin")[1]
			local inkoutstack	= inv:get_list("phinkout")[1]
		
			-- Dicrease paper and ink level
			inv:remove_item	("phpapin",{name = "default:paper"})
			inv:remove_item	("phinkin",{name = "photocop:encre"})
		
			-- Add a paper, add an empty bottle and copy text
			inv:add_item("phoutput",{name = "memorandum:letter", metadata = inputstack:get_metadata()})
			inv:add_item("phinkout",{name = "vessels:glass_bottle"})
		end
	end,
})