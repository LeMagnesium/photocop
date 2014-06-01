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
      "invsize[10,11;]"..
      "list[context;phinput;2,1;1,1;]"..
      "list[context;phoutput;6,1;2,2;]"..
      "list[context;phpapin;1,4;2,1;]"..
      "list[context;phinkin;3,4;1,1;]"..
      "list[context;phinkout;4,4;1,1;]"..
      "list[current_player;main;1,6;8,4;]"..
      "field[2,3;2,1;qttcopies;Copies : ;0]"..
      "button[2,4;2,1;start;Start]"..
      "image[4,1;1,1;photocop_fleche.png]"..
      "image[1.5,3;1,1;default_paper.png]"..
      "image[3,3;1,1;photocop_ink.png]"..
      "image[4,3;1,1;vessels_glass_bottle_inv.png]"..
      "image[6,4;1,1;photocop_ink.png^photocop_ink_level_monitor_font.png]"..
      "image[7,4;1,1;default_paper.png^photocop_ink_level_monitor_font.png]"
    )
    inv:set_size("phinput",1*1)
    inv:set_size("phoutput",2*2)
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
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
    local inv = minetest.get_meta(pos):get_inventory()
    --[[if listname == "phinkin" then
      if stack:get_metadata() == "" then
        stack:set_metadata("100")
      end
    end]]--
    if (not inv:is_empty("phinput")) and (not inv:is_empty("phpapin")) and (not inv:is_empty("phinkin")) then
      --[[tabtrans = {
        inklevel = inv:get_list("phinkin")[1]:get_metadata()
        text = inv:get_list("phinput")[1]:get_metadata()
        phoutput = {[1] = inv:get_list("phoutput")[1]:get_name().." "..inv:get_list("phoutput")[1]:get_count(),
                    [2] = inv:get_list("phoutput")[2]:get_name().." "..inv:get_list("phoutput")[1]:get_count(),
                    [3] = inv:get_list("phoutput")[3]:get_name().." "..inv:get_list("phoutput")[1]:get_count(),
                    [4] = inv:get_list("phoutput")[4]:get_name().." "..inv:get_list("phoutput")[1]:get_count(),
        }
        phinkin = {[1] = inv:get_list("phinkin")[1]:get_name(),
                   [2] = inv:get_list("phinkin")[1]:get_metadata(),
        }
        phinkout = {[1] = inv:get_list("phinkout")[1]:get_name().." "..inv:get_list("phinkout")[1]:get_count()}
        phpapin = {[1] = inv:get_list("phpapin")[1]:get_name().." "..inv:get_list("phpapin")[1]:get_count(),
                   [2] = inv:get_list("phpapin")[1]:get_name().." "..inv:get_list("phpapin")[2]:get_count()
        }
        qttcopies = minetest.get_meta(pos):get_int("qttcopies")
      }]]--
      photocopier(pos, minetest.get_meta(pos):to_table())
    end
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    if listname == "phinput" then return stack:get_count() end
    if listname == "phoutput" then return stack:get_count() end
    if listname == "phpapin" then return stack:get_count() end
    if listname == "phinkin" then return stack:get_count() end
    if listname == "phinkout" then return stack:get_count() end
    return 0
  end,
  allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
    if from_list == "phpapin" then
      if to_list == "phpapin" then return count
      end
    end
    if from_list == "phoutput" then
      if to_list == "phoutput" then return stack:get_count()
      end
    end
    return 0
  end,
  can_dig = function(pos, player)
    local inv = minetest.get_meta(pos):get_inventory()
    return inv:is_empty("phinput") and inv:is_empty("phoutput") and inv:is_empty("phinkin") and inv:is_empty("phinkout") and inv:is_empty("phpapin")
  end,
  on_receive_fields = function(pos, formname, fields, sender)
    if fields.quit == true then return
    else print("bonjour") end
    table.foreach(fields, print)
  end,
})

minetest.register_craftitem("photocop:encre", {
  inventory_image = "photocop_ink.png",
  description = "Cartouche d'encre",
  stack_max = 1
})

minetest.register_craft({
  output = "photocop:encre",
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

minetest.register_node("photocop:photocopieuse_active", {
  description = "Photocopieuse",
  paramtype = "light",
  drop = "photocop:photocopieuse_inactive",
  drawtype = "nodebox",
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
      "invsize[10,11;]"..
      "list[context;phinput;2,1;1,1;]"..
      "list[context;phoutput;6,1;2,2;]"..
      "list[context;phpapin;1,4;2,1;]"..
      "list[context;phinkin;3,4;1,1;]"..
      "list[context;phinkout;4,4;1,1;]"..
      "list[current_player;main;1,6;8,4;]"..
      "field[2,2;3.5,1;qttcopies;Copies : ;0]"..
      "button[2,3;2,1;start;Start]"..
      "image[4,1;1,1;photocop_fleche.png]"..
      "image[1.5,3;1,1;default_paper.png]"..
      "image[3,3;1,1;photocop_ink.png]"..
      "image[4,3;1,1;vessels_glass_bottle_inv.png]"..
      "image[6,4;1,1;photocop_ink.png^photocop_ink_level_monitor_font.png]"..
      "image[7,4;1,1;default_paper.png^photocop_ink_level_monitor_font.png]"
    )
    meta:set_int("qttcopies", 0)
    inv:set_size("phinput",1*1)
    inv:set_size("phoutput",2*2)
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
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
    if listname == "phinkin" then
      if stack:get_metadata() == "" then
        stack:set_metadata("100")
      end
    end
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    if listname == "phinput" then return stack:get_count() end
    if listname == "phoutput" then return stack:get_count() end
    if listname == "phpapin" then return stack:get_count() end
    if listname == "phinkin" then return stack:get_count() end
    if listname == "phinkout" then return stack:get_count() end
    return 0
  end,
  allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
    if from_list == "phpapin" then
      if to_list == "phpapin" then return stack:get_count()
      end
    end
    if from_list == "phoutput" then
      if to_list == "phoutput" then return stack:get_count()
      end
    end
    return 0
  end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
    if not (listname == "phoutput" or listname == "phinkout") then
      minetest.set_node(pos, "photocop:photocopieuse_inactive")
    end
  end,
  can_dig = function(pos, player)
    local inv = minetest.get_meta(pos):get_inventory()
    return inv:is_empty("phinput") and inv:is_empty("phoutput") and inv:is_empty("phinkin") and inv:is_empty("phinkout") and inv:is_empty("phpapin")
  end
})

photocopier = function (pos, tab)
  minetest.set_node(pos, {name = "photocop:photocopieuse_active"})
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()
  inv:set_list("phinput", tab.inventory.phinput)
  inv:set_list("phoutput", tab.inventory.phoutput)
  meta:set_int("qttcopies", tab.fields.qttcopies)
  inv:set_list("phinkin", tab.inventory.phinkin)
  inv:set_list("phinkout", tab.inventory.phinkout)
  inv:set_list("phpapin", tab.inventory.phpapin)
  i = 0
  print(minetest.get_meta(pos):get_int("qttcopies"))
  while i > minetest.get_meta(pos):get_int("qttcopies") do
    i = i+1
  end
  minetest.set_node(pos, {name = "photocop:photocopieuse_inactive"})
end