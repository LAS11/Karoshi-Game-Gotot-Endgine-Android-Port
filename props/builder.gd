extends TileMap

var brick = preload("res://props/brick/brick.tscn")
var brickA = preload("res://props/brickA/brickA.tscn")
var brickB = preload("res://props/brickB/brickB.tscn")
var buttonA = preload("res://props/buttonA/button.tscn")
var buttonB = preload("res://props/buttonB/brick_button.tscn")
var crate = preload("res://props/crate/crate.tscn")
var bounce_block = preload("res://props/bounce_brick/bounce_block.tscn")
var bounce_block_LDown = preload("res://props/bounce_brick/bounce_block_LDown.tscn")
var bounce_block_LUp = preload("res://props/bounce_brick/bounce_block_LUp.tscn")
var bounce_block_RUp = preload("res://props/bounce_brick/bounce_block_RUp.tscn")
var bounce_block_RDown = preload("res://props/bounce_brick/bounce_block_RDown.tscn")
var pistol = preload("res://props/pistol/pistol.tscn")
var spike = preload("res://props/spike/spike.tscn")
var shot_block = preload("res://props/shot_brick/shot_brick.tscn")

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	for cell in get_used_cells():
		var id = get_cellv(cell)
		var type = tile_set.tile_get_name(id)
		var pos = map_to_world(cell) + cell_size/2
		match type:
			'shot_block':
				var s = shot_block.instance()
				s.position = pos
				add_child(s)
			'pistol':
				var s = pistol.instance()
				s.position = pos
				add_child(s)
			'brick':
				var s = brick.instance()
				s.position = pos
				add_child(s)
			'brickA':
				var s = brickA.instance()
				s.position = pos
				add_child(s)
				set_cellv(pos, -1)
			'brickB':
				var s = brickB.instance()
				s.position = pos
				add_child(s)
			'crate':
				var s = crate.instance()
				s.position = pos
				add_child(s)
			'buttonA':
				var s = buttonA.instance()
				s.position = pos
				add_child(s)
			'buttonB':
				var s = buttonB.instance()
				s.position = pos
				add_child(s)
			'bounce_block':
				var s = bounce_block.instance()
				s.position = pos
				add_child(s)
			'bounce_block_LDown':
				var s = bounce_block_LDown.instance()
				s.position = pos
				add_child(s)
			'bounce_block_LUp':
				var s = bounce_block_LUp.instance()
				s.position = pos
				add_child(s)
			'bounce_block_RUp':
				var s = bounce_block_RUp.instance()
				s.position = pos
				add_child(s)
			'bounce_block_RDown':
				var s = bounce_block_RDown.instance()
				s.position = pos
				add_child(s)
			'spike':
				var s = spike.instance()
				s.position = pos
				add_child(s)
			'spike_down':
				var s = spike.instance()
				s.position = pos
				s.rotation = deg2rad(180)
				add_child(s)
			'spike_left':
				var s = spike.instance()
				s.position = pos
				s.rotation = deg2rad(-90)
				add_child(s)
			'spike_right':
				var s = spike.instance()
				s.position = pos
				s.rotation = deg2rad(90)
				add_child(s)
	if (get_name() != "decoration"):
		clear()
