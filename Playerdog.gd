extends Sprite2D


@export var shift_move_multiplier = 5
@onready var tilemap = get_parent()
@onready var player_position = Vector2i(20,20)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(InputEvent):
	if Input.is_action_just_pressed("SW"):
		test_cell(Vector2i(-1,1))
	elif Input.is_action_just_pressed("SE"):
		test_cell(Vector2i(1,1))
	elif Input.is_action_just_pressed("S"):
		test_cell(Vector2i(0,1))
	elif Input.is_action_just_pressed("N"):
		test_cell(Vector2i(0,-1))
	elif Input.is_action_just_pressed("NW"):
		test_cell(Vector2i(-1,-1))
	elif Input.is_action_just_pressed("NE"):
		test_cell(Vector2i(1,-1))
	elif Input.is_action_just_pressed("E"):
		test_cell(Vector2i(1,0))
	elif Input.is_action_just_pressed("W"):
		test_cell(Vector2i(-1,0))
		
func test_cell(coords: Vector2i):
	var testingcell = player_position + coords 
	var data = tilemap.get_cell_tile_data(1, testingcell)
	if data:
		if data.get_custom_data_by_layer_id(0) == 1:
			pass
		else: 
			player_position += coords
	else:
		player_position += coords
	update_position()
	
func update_position():
	self.position = tilemap.map_to_local(player_position)
	

