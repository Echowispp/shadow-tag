extends CharacterBody2D

@export var speed = 30.0

@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var shadow_area = $Area2D

var is_in_light = false

func _ready():
	print("Shadow area: ", shadow_area)
	shadow_area.area_entered.connect(_on_area_entered)
	shadow_area.area_exited.connect(_on_area_exited)

func _physics_process(_delta: float):
	if not is_in_light:
		var direction = (player.global_position - global_position).normalized();
		velocity = direction * speed;
		move_and_slide();
		if velocity.length() > 0:
			var movement_angle_rad = velocity.angle();
			var movement_angle = movement_angle_rad * 180 / PI;
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

func _on_area_entered(area):
	if area.get_parent() != null and area.get_parent().name == "PlayerFlashlight":
		is_in_light = true

func _on_area_exited(area):
	if area.get_parent() != null and area.get_parent().name == "PlayerFlashlight":
		is_in_light = false
