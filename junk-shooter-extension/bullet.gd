extends Area2D

@export var speed: float = 750.0

func _process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("junk"):
		body.queue_free()
		queue_free()
		
		var main_node = get_tree().root.get_node_or_null("Main")
		if main_node:
			main_node.score += 1
			main_node.get_node("HUD").update_score(main_node.score)
			
			if main_node.score % 10 == 0:
				var spawn_timer = main_node.get_node_or_null("JunkTimer")
				if spawn_timer and spawn_timer.wait_time > 0.5:
					spawn_timer.wait_time -= 0.05
