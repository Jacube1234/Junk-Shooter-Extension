extends Area2D

signal shoot_bullet(bullet_position: Vector2, bullet_rotation: float)
signal hit

@export var rotation_speed = 4.0 

func _ready():
	pass 

func _process(delta):
	var rotation_direction = 0
	
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1

	rotation += rotation_direction * rotation_speed * delta

	if Input.is_action_just_pressed("shoot"):
		var muzzle_pos = global_position
		if has_node("Muzzle"):
			muzzle_pos = $Muzzle.global_position
			
		shoot_bullet.emit(muzzle_pos, global_rotation)

func _on_body_entered(_body):
	if _body.is_in_group("junk"):
		hide() 
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	rotation = 0 
	show()
	$CollisionShape2D.disabled = false
