extends Area2D

signal shoot_bullet(bullet_position: Vector2, bullet_rotation: float)
signal hit

@export var rotation_speed = 4.0 
@export var shoot_cooldown: float = 0.45 # <-- 1. Change this number to make it faster or slower (e.g., 0.1 for fast, 0.5 for slow)
var can_shoot: bool = true

func _ready():
	pass 

func _process(delta):
	var rotation_direction = 0
	
	if Input.is_action_pressed("rotate_right"):
		rotation_direction += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_direction -= 1

	rotation += rotation_direction * rotation_speed * delta

	# 2. Updated to check if the gun is ready to fire
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		
		var muzzle_pos = global_position
		if has_node("Muzzle"):
			muzzle_pos = $Muzzle.global_position
			
		shoot_bullet.emit(muzzle_pos, global_rotation)
		
		var shoot_sound = get_node_or_null("ShootSound")
		if shoot_sound:
			shoot_sound.play()
			
		# 3. Wait for the cooldown time before allowing another shot
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true

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
