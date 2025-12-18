extends Node2D

var width = 7
var height = 7
var maze = []
var level = 1

func _ready():
	generate_maze()
	draw_maze()

func generate_maze():
	maze = []
	for y in range(height):
		maze.append([])
		for x in range(width):
			maze[y].append(1) # 1 = mur, 0 = chemin
	carve_passage(1, 1)

func carve_passage(x, y):
	maze[y][x] = 0
	var directions = [[1,0], [-1,0], [0,1], [0,-1]]
	directions.shuffle()
	for dir in directions:
		var nx = x + dir[0]*2
		var ny = y + dir[1]*2
		if nx > 0 and ny > 0 and nx < width-1 and ny < height-1:
			if maze[ny][nx] == 1:
				maze[y + dir[1]][x + dir[0]] = 0
				carve_passage(nx, ny)

func draw_maze():
	var tilemap = $TileMap
	tilemap.clear()
	for y in range(height):
		for x in range(width):
			if maze[y][x] == 1:
				tilemap.set_cell(0, Vector2i(x,y), 1) # mur
			else:
				tilemap.set_cell(0, Vector2i(x,y), 0) # chemin

func next_level():
	level += 1
	width += 2
	height += 2
	generate_maze()
	draw_maze()
	$player.position = Vector2(32, 32)
	print("Niveau ", level, " généré !")
