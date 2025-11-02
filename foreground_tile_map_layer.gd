extends TileMapLayer

var light_texture = preload("res://light_texture.tres")
@onready var lights_container = $"../LightSources/"

func _ready():
	_spawn_lantern_lights()

func _spawn_lantern_lights():
	var lantern_atlas_coords = Vector2i(11, 5);
	var shadow = get_tree().get_first_node_in_group("shadow")
	
	for cell in get_used_cells():
		
		var tile_data = get_cell_tile_data(cell);
		
		if tile_data and get_cell_atlas_coords(cell) == lantern_atlas_coords:
			
			var light = PointLight2D.new();
			var area = Area2D.new();
			var collision = CollisionShape2D.new();
			var collision_shape = CircleShape2D.new();
			
			area.collision_layer = 2; 
			area.collision_mask = 0;
			
			light.global_position = to_global(map_to_local(cell));
			
			collision_shape.radius = 30
			collision.shape = collision_shape
			
			light.texture = light_texture;
			light.energy = 1.2;
			light.texture_scale = 4.0;
			light.color = Color("#fc6");
			light.shadow_enabled = true;
			
			if shadow:
				area.area_entered.connect(shadow._on_area_entered)
				area.area_exited.connect(shadow._on_area_exited)
			
			area.add_child(collision)
			light.add_child(area)
			lights_container.add_child(light);
