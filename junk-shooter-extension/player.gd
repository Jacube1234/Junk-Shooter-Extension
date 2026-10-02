extends Area2D

signal hit

@export var rotation_speed = 4.0
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1
	
	# Only rotates, doesn't move positionally
	rotation += rotation_direction * rotation_speed * delta

func _on_body_entered(_body):
	hide() # Player disappears when hit
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
