extends TileMap
# Карта тайлов, используется для создания уровней

# Все варианты ID содержимого клеток
enum Cell_ID {
	BLUE_BUTTON = 1,
	SHOOT_BLOCK,
	DEFAULT_BUTTON,
	DEFAULT_CRATE,
	CRATE_BUTTON,
	ITEM_PISTOL,
	DECOR_BASKET,
	DECOR_FLOWER,
	DEFAULT_BLOCK,
	BUTTON_BLOCK,
	CRATE_BLOCK,
	BOUNCE_BLOCK,
	BOUNCE_TRIANGLE,
	BOUNCE_TRIANGLE90,
	BOUNCE_TRIANGLE180,
	BOUNCE_TRIANGLE270,
	ITEN_WINGS,
	SPIKES,
	SPIKES270,
	SPIKES180,
	SPIKES90,
}

# Экземпляр класса, который генерирует экземпляры объекта
var props: PropsGenerator = PropsGenerator.new()

# При загрузке нода на сцену - проверяем все задействованные ячейки
func _enter_tree():
	var cells: Array = get_used_cells()
	for cell in cells:
		var cell_id: int = get_cellv(cell)
		_spawn_cell(cell_id, cell)


# Спавн содержимого ячейки
func _spawn_cell(id: int, cell_orig: Vector2):
	var cell_node: Node = null
	var cell_pos: Vector2 = map_to_world(cell_orig) + cell_size / 2
	
	match id:
		Cell_ID.BLUE_BUTTON:
			cell_node = props.create_default_button(cell_pos, true)
		Cell_ID.SHOOT_BLOCK:
			cell_node = props.create_block(cell_pos, props.Block_ID.SHOOT)
		Cell_ID.DEFAULT_BUTTON:
			cell_node = props.create_default_button(cell_pos)
		Cell_ID.DEFAULT_CRATE:
			cell_node = props.create_crate(cell_pos)
		Cell_ID.CRATE_BUTTON:
			cell_node = props.create_crate_button(cell_pos)
		Cell_ID.ITEM_PISTOL:
			cell_node = props.create_item_pistol(cell_pos)
		Cell_ID.DECOR_BASKET:
			cell_node = props.create_decoration(cell_pos, 0)
		Cell_ID.DECOR_FLOWER:
			cell_node = props.create_decoration(cell_pos, 1)
		Cell_ID.DEFAULT_BLOCK:
			cell_node = props.create_block(cell_pos, props.Block_ID.DEFAULT)
		Cell_ID.BUTTON_BLOCK:
			cell_node = props.create_block(cell_pos, props.Block_ID.BUTTON)
		Cell_ID.CRATE_BLOCK:
			cell_node = props.create_block(cell_pos, props.Block_ID.CRATE)
		Cell_ID.BOUNCE_BLOCK:
			cell_node = props.create_block(cell_pos, props.Block_ID.BOUNCE)
		Cell_ID.BOUNCE_TRIANGLE:
			cell_node = props.create_bounce_triangle(cell_pos)
		Cell_ID.BOUNCE_TRIANGLE90:
			cell_node = props.create_bounce_triangle(cell_pos, -90)
		Cell_ID.BOUNCE_TRIANGLE180:
			cell_node = props.create_bounce_triangle(cell_pos, -180)
		Cell_ID.BOUNCE_TRIANGLE270:
			cell_node = props.create_bounce_triangle(cell_pos, -270)
		Cell_ID.ITEN_WINGS:
			cell_node = props.create_item_wings(cell_pos)
		Cell_ID.SPIKES:
			cell_node = props.create_spikes(cell_pos)
		Cell_ID.SPIKES90:
			cell_node = props.create_spikes(cell_pos, 90)
		Cell_ID.SPIKES180:
			cell_node = props.create_spikes(cell_pos, 180)
		Cell_ID.SPIKES270:
			cell_node = props.create_spikes(cell_pos, 270)
	
	
	# Если по заданным координатам было что-то заспавнено - очищаем клетку от спрайта 
	if cell_node != null:
		add_child(cell_node)
		set_cellv(cell_orig, -1)
