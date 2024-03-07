extends TileMap

@export_category("Basics")
@export var map_size = Vector2i(300,300)
@export var player_position = Vector2i(3,3)

@export_category("Moisture")
@export var m_type = FastNoiseLite.TYPE_VALUE
@export var m_gain = 0.1
@export var m_octaves = 5
@export var m_lacunarity = 7
@export var m_frequency = .7


@export_category("Altitude")
@export var a_type = FastNoiseLite.TYPE_VALUE
@export var a_gain = 0.1
@export var a_octaves = 5
@export var a_lacunarity = 7
@export var a_frequency = .4


@onready var playerdog = $PlayerDog

#I WANT TO TEST WITH::
#noise Type, fractal type, domain warp type, cellular jitter, lacunarity, octaves, frequency

##SOME DICTIONARIES
var moisture = {}
var altitude = {}
var astar = AStar2D.new()

#and a generator
var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	moisture = generate_noise(m_type, m_frequency, m_octaves, m_lacunarity, m_gain)
	altitude = generate_noise(a_type, a_frequency, a_octaves, a_lacunarity, a_gain)
	build_map(map_size)
	add_roads()
	
func generate_noise(type, gain, octaves, lacunarity, frequency):
	# generate randomly seeded simplex noise map
	var name = FastNoiseLite.new()
	name.noise_type = type
	name.seed = randi()
	name.frequency = frequency
	name.fractal_octaves = octaves
	name.fractal_lacunarity = lacunarity
	name.fractal_gain = gain
	var grid = {}
	for x in map_size.x:
		for y in map_size.y:
			var rand = name.get_noise_2d(x,y) + 1 + randf_range(-0.1, 0.1)
			grid[Vector2i(x, y)] = rand
	return grid

func build_map(size : Vector2i):
	astar.reserve_space(size.x*size.y)
	for x in size.x:
		for y in size.y:
			var pos = Vector2i(x, y)
			var moi = moisture[pos]
			var alt = altitude[pos]
			specify_cells(x, y, moi, alt)

func specify_cells(x, y, moi, alt):
				#SETS UNDERLAYERS, first up is DARK GREEN
			if between(moi, 0.4, 1.4) and between(alt, 0.2, 0.8):
				set_cell(0, Vector2i(x,y), 0, Vector2i(2,11))
				#AND DARK GREEN AGAIN
			if between(moi, 1.6, 2) and between(alt, 0.4, 0.8):
				set_cell(0, Vector2i(x,y), 0, Vector2i(2,11))
				#NOW DARK BROWN
			if between(moi, 0, 0.4) and between(alt, 0.2, 0.8):
				set_cell(0, Vector2i(x,y), 0, Vector2i(1,11))
#				#SETS BLUE SHADE
#			if between(moi, 1.4, 1.6) and between(alt, 0, 0.4):
#				set_cell(0, Vector2i(x,y), 0, Vector2i(3,11))
				#NOW THE SECOND LAYER:
				#SETS SAND
			if between(moi, 0, 0.4) and between(alt, 0, 0.4):
				set_cell(1, Vector2i(x,y), 0, Vector2i(10,0))
				#SETS SWAMP
			if between(moi, 0.4, 0.8) and between(alt, 0, 0.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(8,9),3))
				if randi_range(0,100) > 95:
					set_cell(2, Vector2i(x-1,y), 0, Vector2i(1,27))
				#SETS DARK SWAMP
			if between(moi, 0.8, 1.2) and between(alt, 0, 0.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(8,9),2))
				#SETS LOW SWAMP 
			if between(moi, 1.2, 1.4) and between(alt, 0, 0.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(5,7),3))
				#SETS OCEAN
			if between(moi, 1.4, 2) and between(alt, 0, 0.4):
				set_cells_terrain_connect(1, [Vector2i(x,y)], 0, 0, 0)
				#SETS dark brown
			if between(moi, 0, 0.4) and between(alt, 0.4, 0.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(1,11))
				#SETS Dark green 
			if between(moi, 0.4, 1.2) and between(alt, 0.2, 0.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(2,11))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(4,6), 27))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(1,10), 32))
				#SETS DEAD TREES
			if between(moi, 1.2, 1.4) and between(alt, 0.4, 0.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(8,9),0))
				#SETS DARK GREEN AGAIN LOL
			if between(moi, 1.4, 2) and between(alt, 0.4, 0.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(2,11))
				#SETS SHROOM FOREST
			if between(moi, 2, 2.2) and between(alt, 0.4, 0.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(8,9),1))
				#SETS dry grass
			if between(moi, 0, 0.4) and between(alt, 0.6, 1.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(0,4), 3))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(1,10), 36))
				#SETS light grass 
			if between(moi, 0.4, 0.8) and between(alt, 0.6, 1.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(0,4),2))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(1,10), 40))
				#SETS grass
			if between(moi, 0.8, 1.2) and between(alt, 0.6, 1.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(0,4),1))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(1,10), 44))
				#SETS DARK grass
			if between(moi, 1.2, 1.6) and between(alt, 0.6, 1.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(0,4),0))
				#SETS trees
			if between(moi, 1.6, 2) and between(alt,0.6, 1.0):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(5,7),0))
				#SETS pines
			if between(moi, 1.6, 2) and between(alt, 1, 1.4):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(5,7),1))
				#SET SNOW PINES
			if between(moi, 1.6, 2) and between(alt, 1.4, 1.8):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(5,7),2))
				#SETS dry hills lower
			if between(moi, 0, 0.4) and between(alt, 1.2, 1.4):
				set_cell(1, Vector2i(x,y), 0, Vector2i(0, randi_range(6,7)))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(1,10), 36))
				#SETS blue hills lower
			if between(moi, 0.4, 0.8) and between(alt, 1.2, 1.4):
				set_cell(1, Vector2i(x,y), 0, Vector2i(0, randi_range(4,5)))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(1,10), 40))
				#SETS light hill 
			if between(moi, 0.8, 1.2) and between(alt, 1.2, 1.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(0,6), 9))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(1,10), 44))
				#SETS DARK hill 
			if between(moi, 1.2, 1.6) and between(alt, 1.2, 1.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(0,6),10))
				#SETS dry hills upper
			if between(moi, 0, 0.4) and between(alt, 1.4, 1.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(1, randi_range(6,7)))
				#SETS blue hills upper
			if between(moi, 0.4, 0.8) and between(alt, 1.4, 1.6):
				set_cell(1, Vector2i(x,y), 0, Vector2i(1, randi_range(4,5)))
				#SETS A MINE:
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(5,32))
				#SETS PLATEAUS
			if between(moi, 0, 0.2) and between(alt, 0, 0.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(0,1), 8))
				#SETS dry mtn 0 TBI
			if between(moi, 0.0, 0.4) and between(alt, 1.6, 2):
				if randi_range(0,10) > 5:
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(9,10),randi_range(6,7)))
				else: 
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(5,6),randi_range(6,7)))
				#SETS dry mtn snow 1 TBI
			if between(moi, 0.4, 0.8) and between(alt, 1.6, 2):
				if randi_range(0,10) > 5:
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(11,12),6))
				else: 
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(7,8),6))
				#SETS blue mtn 2 TBI
			if between(moi, 0.8, 1.2) and between(alt, 1.6, 2):
				if randi_range(0,10) > 5:
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(9,10),5))
				else: 
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(5,6),5))
					#AND A MINE:
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(5,32))
				#SETS light blue mtn 3
			if between(moi, 1.2, 1.6) and between(alt, 1.6, 2):
				if randi_range(0,10) > 5:
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(9,10),4))
				else: 
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(5,6),4))
				if randi_range(0,100) > 99:
					set_cell(2, Vector2i(x,y), 0, Vector2i(5,32))
				#SETS snow mtn
			if between(moi, 1.6, 2) and between(alt, 1.6, 2):
				if randi_range(0,10) > 5:
					set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(11, 12), 4))
				else: set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(7, 8), 4))
			if between(moi, 1.9, 2.3) and between(alt, 1.9, 2.3):
				set_cell(1, Vector2i(x,y), 0, Vector2i(10, 3))
			if between(moi, 0, 1.9) and between (alt, 2.0, 2.2):
				set_cell(1, Vector2i(x,y), 0, Vector2i(randi_range(4,12), randi_range(4,7)))
# THIS is a function that rewrites some tiles w/ nothing. idk man
#			if randi_range(0,10) > 9:
#				set_cell(1, Vector2i(x,y), 0, Vector2i(0,11))
			#AND NOW A THIRD LAYER FOR ITEMS?
			if between(moi, 0.2, 1.6) and between(alt, 0.2, 1.6) and randi_range(0,100) > 99:
				set_cell(2, Vector2i(x,y), 0, Vector2i(randi_range(0,10), 26))


func add_roads():
	var road_astar = AStar2D.new()
	road_astar.add_point(0, Vector2i(10,10), 0)
	road_astar.add_point(1, Vector2i(20,20), 0)
	road_astar.connect_points(0, 1, true)
	print(road_astar.get_point_path(0,1))

func between(val, start, end):
	if start <= val and val < end:
		return true

func _unhandled_input(event):
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

func update_position():
	playerdog.position = map_to_local(player_position)
	
	
func test_cell(coords: Vector2i):
	var shift_jump = 1
	if Input.is_action_pressed("Shift_jump"):
		shift_jump = playerdog.shift_move_multiplier
	else :
		shift_jump = 1
	var testingcell = player_position + coords 
	var data = get_cell_tile_data(1, testingcell)
	if data:
		if data.get_custom_data_by_layer_id(0) == 1:
			if playerdog.walljump:
				player_position += (-2 * coords)
				update_position()
			else:
				pass
		else: 
			player_position = testingcell
	update_position()

func get_astar_ID(x,y):
	pass
