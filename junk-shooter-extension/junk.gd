extends RigidBody2D

var speed_multiplier: float = 1.0

func _ready():
	# 1. Set the animation name
	$AnimatedSprite2D.animation = "default"
	
	# Stop it immediately so it doesn't override your frame choice
	$AnimatedSprite2D.stop()
	
	# 2. Get how many frames are in the animation
	var frame_count = $AnimatedSprite2D.sprite_frames.get_frame_count("default")
	
	# 3. Pick a random frame (0 or 1)
	if frame_count > 0:
		$AnimatedSprite2D.frame = randi() % frame_count
		print("Picked frame index: ", $AnimatedSprite2D.frame)
	
	# 5. Target the player and move
	var player = get_parent().get_node_or_null("Player")
	if player:
		look_at(player.global_position)
		var speed = randf_range(150.0, 250.0)
		linear_velocity = Vector2.RIGHT.rotated(rotation) * (speed * speed_multiplier)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
