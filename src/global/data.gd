extends Node

signal score_changed
signal high_score_changed

var score := 0 setget set_score, get_score
var high_score := 0 setget set_high_score, get_high_score

func get_score() -> int:
	return score

func set_score(new_score: int) -> void:
	if (new_score == score):
		return

	score = new_score
	emit_signal("score_changed")
	
	if score > high_score:
		set_high_score(score)

func reset_score() -> void:
	score = 0

func get_high_score() -> int:
	return high_score

func set_high_score(new_high_score: int) -> void:
	if (new_high_score == high_score):
		return
	
	high_score = new_high_score
	emit_signal("high_score_changed")
