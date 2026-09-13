extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("left", "right", "up", "down")
	if direction.x:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
	
	if direction.y:
		velocity.y = direction.y * SPEED
	else:
		velocity.y = lerp(velocity.y, 0.0, 0.1)

	move_and_slide()
