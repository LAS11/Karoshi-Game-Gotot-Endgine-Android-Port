class_name LevelPack
extends Node

# Класс для загрузки уровней
var main_menu: PackedScene = preload("res://ui/main_menu/main_menu.tscn")
var level00: PackedScene = preload("res://levels/level00.tscn")
var level01: PackedScene = preload("res://levels/level01.tscn")
var level02: PackedScene = preload("res://levels/level02.tscn")
var level03: PackedScene = preload("res://levels/level03.tscn")
var level04: PackedScene = preload("res://levels/level04.tscn")
var level05: PackedScene = preload("res://levels/level05.tscn")
var level06: PackedScene = preload("res://levels/level06.tscn")
var level07: PackedScene = preload("res://levels/level07.tscn")
var level08: PackedScene = preload("res://levels/level08.tscn")
var level09: PackedScene = preload("res://levels/level09.tscn")
var level10: PackedScene = preload("res://levels/level10.tscn")
var level11: PackedScene = preload("res://levels/level11.tscn")
var level12: PackedScene = preload("res://levels/level12.tscn")
var level13: PackedScene = preload("res://levels/level13.tscn")
var level14: PackedScene = preload("res://levels/level14.tscn")
var level15: PackedScene = preload("res://levels/level15.tscn")
var level16: PackedScene = preload("res://levels/level16.tscn")
var level17: PackedScene = preload("res://levels/level17.tscn")
var level18: PackedScene = preload("res://levels/level18.tscn")
var level19: PackedScene = preload("res://levels/level19.tscn")
var level20: PackedScene = preload("res://levels/level20.tscn")
var level21: PackedScene = preload("res://levels/level21.tscn")
var level22: PackedScene = preload("res://levels/level22.tscn")
var level23: PackedScene = preload("res://levels/level23.tscn")
var level24: PackedScene = preload("res://levels/level24.tscn")
var level25: PackedScene = preload("res://levels/level25.tscn")
var level26: PackedScene = preload("res://levels/level26.tscn")
var level27: PackedScene = preload("res://levels/level27.tscn")
var level28: PackedScene = preload("res://levels/level28.tscn")
var level29: PackedScene = preload("res://levels/level29.tscn")
var level30: PackedScene = preload("res://levels/level30.tscn")


func get_level_instance(level_number: int = -1) -> Node:
	var level: Node = null
	match level_number:
		0:
			level = level00.instance()
		1:
			level = level01.instance()
		2:
			level = level02.instance()
		3:
			level = level03.instance()
		4:
			level = level04.instance()
		5:
			level = level05.instance()
		6:
			level = level06.instance()
		7:
			level = level07.instance()
		8:
			level = level08.instance()
		9:
			level = level09.instance()
		10:
			level = level10.instance()
		11:
			level = level11.instance()
		12:
			level = level12.instance()
		13:
			level = level13.instance()
		14:
			level = level14.instance()
		15:
			level = level15.instance()
		16:
			level = level16.instance()
		17:
			level = level17.instance()
		18:
			level = level18.instance()
		19:
			level = level19.instance()
		20:
			level = level20.instance()
		21:
			level = level21.instance()
		22:
			level = level22.instance()
		23:
			level = level23.instance()
		24:
			level = level24.instance()
		25:
			level = level25.instance()
		26:
			level = level26.instance()
		27:
			level = level27.instance()
		28:
			level = level28.instance()
		29:
			level = level29.instance()
		30:
			level = level30.instance()
		_:
			level = main_menu.instance()
	return level
