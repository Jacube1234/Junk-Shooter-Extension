extends Node

@export var junk_scene: PackedScene
var score = 0

func _ready():
	# Safely connect only if not already connected (fixes the error)
	if not $Player.hit.is_connected(game_over):
		$Player.hit.connect(game_over)
	new_game()

func game_over():
	$JunkTimer.stop()
	
	# Instantly delete all existing junk currently on the screen
	get_tree().call_group("junk", "queue_free")

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_start_timer_timeout():
	print("StartTimer finished! Starting JunkTimer...")
	$JunkTimer.start()
	
func _on_junk_timer_timeout():
	print("Timer ticked, trying to spawn junk!")
	# Create a new instance of the Junk scene.
	var junk = junk_scene.instantiate()
	
	# Add the junk to a group so we can clear them all on game over
	junk.add_to_group("junk")

	# Choose a random location on the Path2D.
	var junk_spawn_location = $JunkPath/JunkSpawnLocation
	junk_spawn_location.progress_ratio = randf()

	# Set the junk's position to the random location.
	junk.position = junk_spawn_location.position

	# Set the junk's direction straight toward the player.
	var player_position = $Player.position
	var direction = junk.position.angle_to_point(player_position)

	# Add a little bit of random spread so they don't all fly in a single pixel-perfect line.
	direction += randf_range(-PI / 6, PI / 6)
	junk.rotation = direction

	# Choose the velocity for the junk.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	junk.linear_velocity = velocity.rotated(direction)

	# Spawn the junk by adding it to the Main scene.
	add_child(junk)
