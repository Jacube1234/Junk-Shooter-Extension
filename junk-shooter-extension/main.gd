extends Node

# Drag your 4 separate junk files into this inspector array slot!
@export var junk_scenes: Array[PackedScene] = []
var score = 0

func _ready():
	if not $Player.hit.is_connected(game_over):
		$Player.hit.connect(game_over)
		
	# Instantly start the game because they already clicked "Play" on the menu
	new_game()

func game_over():
	$JunkTimer.stop()
	get_tree().call_group("junk", "queue_free")
	
	# 1. Safely load your title screen file into the background memory
	var title_menu = load("res://title_screen.tscn").instantiate()
	
	# 2. Hand your active score variables straight backward to its empty slot!
	title_menu.final_score = score
	
	# 3. Slap the fully updated menu layout directly onto the player's monitor view
	get_tree().root.add_child(title_menu)
	
	# 4. Safely delete this dead gameplay level out of memory to prevent background lag
	queue_free()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$JunkTimer.start()
	
func _on_junk_timer_timeout():
	if junk_scenes.is_empty():
		return

	# Randomly pick and instantiate one of your separate junk files
	var random_junk_scene = junk_scenes.pick_random()
	var junk = random_junk_scene.instantiate()
	
	if not junk.is_in_group("junk"):
		junk.add_to_group("junk")

	var junk_spawn_location = $JunkPath/JunkSpawnLocation
	junk_spawn_location.progress_ratio = randf()
	junk.position = junk_spawn_location.position

	var player_position = $Player.position
	var direction = junk.position.angle_to_point(player_position)

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	junk.linear_velocity = velocity.rotated(direction)

	add_child(junk)
