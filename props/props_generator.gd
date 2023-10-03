class_name PropsGenerator
extends Node
# Класс для генерации нодов (он не спавнит их на сцене)

enum Block_ID { DEFAULT, BUTTON, CRATE, SHOOT, BOUNCE }

var block: Resource = preload("res://props/blocks/block.tscn")
var button_block: Resource = preload("res://props/blocks/button_block.tscn")
var crate_block: Resource = preload("res://props/blocks/crate_block.tscn")
var shoot_block: Resource = preload("res://props/blocks/shoot_block/shoot_block.tscn")
var bounce_block: Resource = preload("res://props/blocks/bounce_block/bounce_block.tscn")
var bounce_triangle: Resource = preload("res://props/blocks/bounce_block/bounce_triangle.tscn")

var floor_button: Resource = preload("res://props/buttons/floor_button.tscn")
var crate_button: Resource = preload("res://props/buttons/crate_button/crate_button.tscn")

var crate: Resource = preload("res://props/crate/crate.tscn")
var spikes: Resource = preload("res://props/spikes/spikes.tscn")

var pistol: Resource = preload("res://props/pistol/pistol.tscn")
var wings: Resource = preload("res://props/wings/wings.tscn")

var flower: Resource = preload("res://props/flower.tscn")
var basket: Resource = preload("res://props/basket.tscn")


func create_block(pos: Vector2, type := Block_ID.DEFAULT) -> Node:
	var node: Node
	match type:
		Block_ID.DEFAULT:
			node = block.instance()
		Block_ID.BUTTON:
			node = button_block.instance()
		Block_ID.CRATE:
			node = crate_block.instance()
		Block_ID.SHOOT:
			node = shoot_block.instance()
		Block_ID.BOUNCE:
			node = bounce_block.instance()
	node.position = pos
	return node


func create_default_button(pos: Vector2, blue := false) -> Node:
	var node: Node = floor_button.instance()
	node.blue_button = blue
	node.position = pos
	return node


func create_crate(pos: Vector2) -> Node:
	var node: Node = crate.instance()
	node.position = pos
	return node

func create_crate_button(pos: Vector2) -> Node:
	var node: Node = crate_button.instance()
	node.position = pos
	return node


func create_item_pistol(pos: Vector2) -> Node:
	var node: Node = pistol.instance()
	node.position = pos
	return node


func create_item_wings(pos: Vector2) -> Node:
	var node: Node = wings.instance()
	node.position = pos
	return node
	
	
func create_bounce_triangle(pos: Vector2, rot := 0) -> Node:
	var node: Node = bounce_triangle.instance()
	node.position = pos
	node.rotation_degrees = rot
	return node


func create_spikes(pos: Vector2, rot := 0) -> Node:
	var node: Node = spikes.instance()
	node.position = pos
	node.rotation_degrees = rot
	return node


func create_decoration(pos: Vector2, type: int = 0) -> Node:
	var node: Node
	match type:
		0:
			node = basket.instance()
		1:
			node = flower.instance()
	
	node.position = pos
	return node

