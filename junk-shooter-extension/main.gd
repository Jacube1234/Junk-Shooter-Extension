extends Node

@export var junk_scenes: Array[PackedScene] = []
@export var bullet_scene: PackedScene # <--- 1. ADD THIS AT THE TOP
var score = 0

func _ready():
	if not $Player.hit.is_connected(game_over):
		$Player.hit.connect(game_over)
		
	# <--- 2. ADD THIS CONNECTION IN _ready() --->
	if not $Player.shoot_bullet.is_connected(_on_player_shoot_bullet):
		$Player.shoot_bullet.connect(_on_player_shoot_bullet)
		
	$AudioStreamPlayer2D.play()
	new_game()

func game_over():
	$JunkTimer.stop()
	get_tree().call_group("junk", "queue_free")
	
	var title_menu = load("res://title_screen.tscn").instantiate()
	title_menu.final_score = score
	get_tree().root.add_child(title_menu)
	queue_free()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)

# <--- 3. ADD THIS FUNCTION AT THE BOTTOM --->
func _on_player_shoot_bullet(bullet_position, bullet_rotation):
	var bullet = bullet_scene.instantiate()
	bullet.position = bullet_position
	bullet.rotation = bullet_rotation
	add_child(bullet)

func _on_start_timer_timeout():
	$JunkTimer.start()
	
func _on_junk_timer_timeout():
	if junk_scenes.is_empty():
		return

	var random_junk_scene = junk_scenes.pick_random()
	var junk = random_junk_scene.instantiate()
	
	if not junk.is_in_group("junk"):
		junk.add_to_group("junk")

	var junk_spawn_location = $JunkPath/JunkSpawnLocation
	junk_spawn_location.progress_ratio = randf()
	junk.position = junk_spawn_location.position

	var player_position = $Player.position
	var direction = junk.position.angle_to_point(player_position)

	var velocity = Vector2(randf_range(100.0, 150.0), 0.0)
	junk.linear_velocity = velocity.rotated(direction)

	add_child(junk)
