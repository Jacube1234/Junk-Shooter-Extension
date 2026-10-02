extends Control

# An empty slot that main.gd can fill with your final match data right as you die
var final_score: int = 0

func _ready() -> void:
	# If the game passed a score greater than 0, show the end-game HUD messages!
	if final_score > 0:
		$Message.text = "Game Over"
		$Message.show()
		$ScoreLabel.text = "Final Score: " + str(final_score)
		$ScoreLabel.show()
	else:
		# Otherwise, this is the very first boot, so hide the end-game layout text
		$Message.text = "Space Junk Shooter" # Put your game title name here!
		$Message.show()
		$ScoreLabel.hide()

func _on_button_pressed() -> void:
	# 1. Safely swap to a 100% fresh, clean game scene file
	get_tree().change_scene_to_file("res://main.tscn")
	# 2. THE FIX: Safely delete this menu canvas layer so it can't linger over the gameplay!
	queue_free()
