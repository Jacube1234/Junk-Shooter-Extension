extends Area2D

@export var rotation_speed = 4.0 # How fast the player will rotate.
signal hit

func _ready():
	hide() # Player is hidden when the game starts.

func _process(delta):
	var rotation_direction = 0
	
	# Check for input - is the player pressing a rotation key?
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1

	# Smoothly update the player's rotation using delta for frame-rate independence.
	rotation += rotation_direction * rotation_speed * delta

func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	rotation = 0 # Reset rotation angle when starting a new game.
	show()
	$CollisionShape2D.disabled = false
	
	
