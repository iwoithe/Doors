extends Node2D

signal door_selected

var current_door := 0
var selected_door: int

func _ready() -> void:
	randomize()
	
	Data.connect("score_changed", self, "update_ui")
	Data.connect("high_score_changed", self, "update_ui")
	
	update_ui()
	
	play_round()

func _on_PushButton_pressed():
	emit_signal("door_selected", Enums.DoorType.PUSH)

func _on_PullButton_pressed():
	emit_signal("door_selected", Enums.DoorType.PULL)

func get_door(door_num: int):
	return get_node("%Door" + str(door_num))

func get_current_door():
	return get_door(current_door)

func get_door_string(door_num: int) -> String:
	return "%Door" + str(door_num)

func get_current_door_string() -> String:
	return get_door_string(current_door)

func get_next_door():
	for door in $Doors.get_children():
		if !door.is_current:
			return door

func play_round() -> void:
	current_door = Data.score % 2
	get_current_door().is_current = true
	update_doors()

	pick_door_type()

	selected_door = yield(self, "door_selected")

	yield(check_guess(), "completed")
	
	get_current_door().is_current = false
	play_round()

func pick_door_type() -> void:
	# TODO: Add an option to continue on the same path
	get_current_door().door_type = randi() % 2
	# get_current_door().door_type = 1

func check_guess() -> void:
	if selected_door == get_current_door().door_type:
		# Round won
		Data.score += 1
		
		$SoundManager.play("Win")
		
		match get_current_door().door_type:
			Enums.DoorType.PULL:
				get_current_door().play_animation(Enums.DoorAnimation.PULL)
			Enums.DoorType.PUSH:
				get_current_door().play_animation(Enums.DoorAnimation.PUSH)
		
		yield(get_node(get_current_door_string() + "/AnimationPlayer"), "animation_finished")
		
		$Person.play_animation("Walk")
		
		var camera_width := $Camera2D.get_viewport().get_visible_rect().size.x
		$Tween.interpolate_property($Person, "position:x", $Person.position.x, (camera_width * Data.score) + (camera_width / 2), 1.0)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		$Person.play_animation("RESET")
		
		get_next_door().set_visible(true)
		$Tween.interpolate_property($Camera2D, "position:x", $Camera2D.position.x, camera_width * Data.score, 1.0)
		$Tween.start()
		yield($Tween, "tween_all_completed")
	else:
		# Round lost
		Data.reset_score()
		
		$Person.play_animation("Walk")
		
		$Tween.interpolate_property($Person, "position:x", $Person.position.x, get_current_door().position.x - ($Person.texture.get_size().x / 2) + 3, 0.7)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		
		$Person.play_animation("RESET")
		
		$SoundManager.play("Loose")
		yield(get_tree().create_timer(1), "timeout")
		
		get_tree().change_scene("res://ui/mainmenu.tscn")
		yield(get_tree(), "idle_frame")

func update_doors() -> void:
	for door in $Doors.get_children():
		if door.is_current:
			door.set_visible(true)
		else:
			door.set_visible(false)
			door.play_animation(Enums.DoorAnimation.RESET)
			door.update_next_position()

func update_ui() -> void:
	$"%ScoreLabel".text = "Score: " + str(Data.score)
	$"%HighScoreLabel".text = "High: " + str(Data.high_score)
