extends TileMap

var shadow = preload("res://props/shadow.png")
var eButton = preload("res://levels/level5/electro_button/electro_button.tscn")
var ebutton_id

func _enter_tree():
	for cell in get_used_cells():
		var id = get_cellv(cell)
		var type = tile_set.tile_get_name(id)
		var pos = map_to_world(cell) + cell_size/2
		if (type == 'eButton'):
			var button = eButton.instance()
			button.position = pos + Vector2(0, 17)
			add_child(button)
			
			var sp = Sprite.new()
			sp.set_texture(shadow)
			sp.set_position(pos + Vector2(0, 32))
			sp.set_draw_behind_parent(true)
			sp.set_self_modulate(Color(1, 1, 1, 0.27))
			add_child(sp)
			
			tile_set.tile_set_modulate(id, Color(1, 1, 1, 0))
		else:
			var sp = Sprite.new()
			sp.set_texture(shadow)
			sp.set_position(pos)
			sp.set_draw_behind_parent(true)
			sp.set_self_modulate(Color(1, 1, 1, 0.27))
			add_child(sp)