extends CharacterBody2D


@export var speed = 35.0

@onready var animated_sprite = $AnimatedSprite2D

#func _ready():
	#pass
## CHECK GDOCS TODO!!!!
## CHECK GDOCS TODO!!!!
## CHECK GDOCS TODO!!!!
## CHECK GDOCS TODO!!!!
## CHECK GDOCS TODO!!!!
## CHECK GDOCS TODO!!!!
## CHECK GDOCS TODO!!!!
## CHECK GDOCS TODO!!!!
#when reviewing code, ignore the above. I'm trying to use a todo list between sessions to remember what I need to do next, I'm afraid I'll forget it otherwise. 
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if (Input.is_action_pressed("move_right")):
		velocity.x += 1
	if (Input.is_action_pressed("move_left")):
		velocity.x -= 1
	if (Input.is_action_pressed("move_up")):
		velocity.y -= 1
	if (Input.is_action_pressed("move_down")):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		move_and_slide()
		var movement_angle_rad = velocity.angle()
		var movement_angle = movement_angle_rad * 180 / PI
		if movement_angle > -45 and movement_angle < 45:
				animated_sprite.play("walk_h");
				animated_sprite.flip_h = false;
		elif movement_angle < -135 or movement_angle > 135:
			animated_sprite.play("walk_h");
			animated_sprite.flip_h = true;
		elif movement_angle >= 45 and movement_angle <= 135:
			animated_sprite.play("walk_down");
			animated_sprite.flip_h = false;
		elif movement_angle >= -135 and movement_angle <= -45:
			animated_sprite.play("walk_up");
			animated_sprite.flip_h = false;
	else:
		animated_sprite.play("idle")
