extends CanvasLayer

signal start_game

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	start_game.emit()

# This satisfies the leftover timer signal and clears the warning
func _on_message_timer_timeout():
	pass
