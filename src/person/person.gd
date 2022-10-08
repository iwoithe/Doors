extends Sprite

export (NodePath) var camera_path
onready var camera = get_node(camera_path)

func _ready():
	position.x = camera.get_viewport().get_visible_rect().size.x / 2
	position.y = camera.get_viewport().get_visible_rect().size.y / 2

func play_animation(anim_name: String) -> void:
	$AnimationPlayer.play(anim_name)
