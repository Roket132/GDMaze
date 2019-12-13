extends TileMap

var n
var m
var bfs_map
var paths_map

func _ready():
	pass
	
func init(map, start_pos, paths_map_):
	if map.size() == 0:
		# assert
		return
	init_paths_map(map if paths_map_ == null else paths_map_)
	bfs_map = bfs(map, start_pos)

func init_paths_map(p_map_):
	paths_map = p_map_.duplicate(true)
	for i in range(paths_map.size()):
		for j in range(paths_map[i].size()):
			paths_map[i][j] = "#" if paths_map[i][j] == "#" else "P" if paths_map[i][j] == "P" else "."
	_draw_paths_map()

func bfs(map, start):
	var res_map = create_2d_array(map.size(), map[0].size())
	var D = [[1, 0], [-1, 0], [0, 1], [0, -1]]
	var queue = []
	
	res_map[start.y][start.x] = 1
	queue.append(Vector2(start.y, start.x))
	
	n = map.size()
	m = map[0].size()
	
	while queue.size() != 0:
		var p = queue.pop_front()
		for k in range(4):
			var i = p.x + D[k][0]
			var j = p.y + D[k][1]
			if i >= n or j >= m or i < 0 or j < 0:
				continue			
			if map[i][j] != "#" and res_map[i][j] == 0:
				res_map[i][j] = res_map[p.x][p.y] + 1
				queue.append(Vector2(i, j))
	return res_map
	
# if steps == -1 then return all path
func get_array_path(from, steps = -1):
	var res = []
	var i = from.x
	var j = from.y
	res.append(Vector2(j, i))
	
	while bfs_map[i][j] != 1 and steps != 0:
		if i - 1 > 0 and bfs_map[i - 1][j] == bfs_map[i][j] - 1:
			i -= 1
		elif i + 1 < n and bfs_map[i + 1][j] == bfs_map[i][j] - 1:
			i += 1
		elif j - 1 > 0 and bfs_map[i][j - 1] == bfs_map[i][j] - 1:
			j -= 1
		elif j + 1 < m and bfs_map[i][j + 1] == bfs_map[i][j] - 1:
			j += 1
		steps -= 1
		res.append(Vector2(j, i))
			
	return res

func draw(from, steps = -1):
	var path = get_array_path(from, steps)
	for it in path:
		set_cellv(it, 0)
		paths_map[it.y][it.x] = "P"

func create_2d_array(n, m, val = 0):
	var arr = []
	for i in range(n):
		arr.append([])
		for j in range(m):
			arr[i].append(val)
	return arr

func _draw_paths_map():
	for i in range(paths_map.size()):
		for j in range(paths_map[i].size()):
			if paths_map[i][j] == "P":
				set_cell(j, i, 0)

func get_paths_map():
	return paths_map