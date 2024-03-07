extends TileMap

@export_category("Basics")
@export var map_size = Vector2i(50,50)
@export var player_position = Vector2i(3,3)


@export_category("Brownblob")
##SOME DICTIONARIES
var browniness = {}
var browniness_atPosition = browniness["player_position"]
@export var b_type = FastNoiseLite.TYPE_PERLIN
@export var b_gain = 0.1
@export var b_octaves = 5
@export var b_lacunarity = 7
@export var b_frequency = .7

func _ready():
	randomize()
	browniness = generate_noise(b_type, b_frequency, b_octaves, b_lacunarity, b_gain)

func generate_noise(type, gain, octaves, lacunarity, frequency):
	# generate randomly seeded simplex noise map
	var noise = FastNoiseLite.new()
	noise.noise_type = type
	noise.seed = randi()
	noise.frequency = frequency
	noise.fractal_octaves = octaves
	noise.fractal_lacunarity = lacunarity
	noise.fractal_gain = gain
	var grid = {}
	for x in map_size.x:
		for y in map_size.y:
			var rand = noise.get_noise_2d(x,y) + 1
			grid[Vector2i(x, y)] = rand
	return grid

