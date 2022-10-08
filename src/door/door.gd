extends Node2D

export (NodePath) var camera_path
onready var camera = get_node(camera_path)

var door_type: int
var is_current := false

func _ready() -> void:
	update_position()

func get_width() -> int:
	return $Sprite.texture.get_width()

func update_position() -> void:
	position.x = (camera.get_viewport().get_visible_rect().size.x - $Position2D.position.x) * (Data.score + 1)
	position.y = camera.get_viewport().get_visible_rect().size.y / 2

func update_next_position() -> void:
	var camera_width: int = camera.get_viewport().get_visible_rect().size.x
	position.x = (camera_width * (Data.score + 2)) - $Position2D.position.x
	position.y = camera.get_viewport().get_visible_rect().size.y / 2

func play_animation(animation: int) -> void :
	match animation:
		Enums.DoorAnimation.PULL:
			$AnimationPlayer.play("Pull")
		Enums.DoorAnimation.PUSH:
			$AnimationPlayer.play("Push")
		Enums.DoorAnimation.RESET:
			$AnimationPlayer.play("RESET")
