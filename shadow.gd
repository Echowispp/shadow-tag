extends CharacterBody2D

@export var speed = 330.0

@onready var player = get_parent().get_node("player")
@onready var animated_sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	
		var direction = (player.global_position - global_position).normalized();
		velocity = direction * speed
		move_and_slide()
		if velocity.length() > 0:
			var movement_angle_rad = velocity.angle()
			var movement_angle = movement_angle_rad * 180 / PI
			if movement_angle > -45 and movement_angle < 45:
				animated_sprite.play("walk_h")
			if movement_angle < -135 or movement_angle > 135:
				animated_sprite.play("walk_h");
				animated_sprite.flip_h = true
			if movement_angle < -45 and movement_angle > -135:
				animated_sprite.play("walk_down")
			if movement_angle < 135 and movement_angle > 45:
				animated_sprite.play("walk_up")
