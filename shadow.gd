extends CharacterBody2D;

@export var speed = 200.0;

@onready var player = get_tree().get_first_node_in_group("player");
@onready var animated_sprite = $AnimatedSprite2D;
@onready var shadow_area = $Area2D;
@onready var kill_area = $KillArea;

var is_in_light = false;
var light_timer = 0.0;
var invis_timer = 0.0;

#var debug_timer = 0.0;
#var debug_timer_s = 0

func _ready():
	shadow_area.area_entered.connect(_on_area_entered);
	shadow_area.area_exited.connect(_on_area_exited);
	kill_area.body_entered.connect(_on_player_touched);

func _physics_process(delta: float):
	if not is_in_light:
		var direction = (player.global_position - global_position).normalized();
		if direction.length() > 0.0:
			velocity = direction * speed;
			move_and_slide();
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
		else:
			animated_sprite.play("idle");
		if light_timer > 0:
			light_timer -= delta;
	elif light_timer < 1:
		animated_sprite.play("idle");
		light_timer += delta;
		
	elif light_timer > 1:
		light_timer = 0.0;
		global_position += 5 * (player.global_position - global_position); 
		# unstuck by going to the other side of the player
		visible = false;
		# make the shadow invisible to let it do a jumpscare
		invis_timer = 0.0 + delta;
		is_in_light = false;
		
	if invis_timer > 0 and invis_timer < 5:
		invis_timer += delta;
	if invis_timer > 5 or (player.global_position - global_position).length() < 150:
		visible = true; # turn shadow visible once close enough to the player
	if (player.global_position - global_position).length() > 500:
		var tp_direction = (player.global_position - global_position).normalized()
		global_position = player.global_position - tp_direction * 400

func _on_player_touched(body):
	if body.is_in_group("player"):
		body.die();

func _on_area_entered(area):
	if area.get_parent() != null and area.get_parent() is PointLight2D:
		is_in_light = true;

func _on_area_exited(area):
	if area.get_parent() != null and area.get_parent() is PointLight2D:
		var overlapping = shadow_area.get_overlapping_areas();
		var still_in_light = false;
		for other_area in overlapping:
			if other_area.get_parent() is PointLight2D:
				still_in_light = true;
				break;
		is_in_light = still_in_light;
