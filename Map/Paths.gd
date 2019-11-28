extends TileMap

var n
var m
var bfs_map

func _ready():
	pass
	
func init(map, start_pos):
	if map.size() == 0:
		# assert
		return
	bfs_map = bfs(map, start_pos)
	for i in bfs_map:
		print(i)
	#print(bfs_map)

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
			if map[i][j] != "1" and res_map[i][j] == 0:
				res_map[i][j] = res_map[p.x][p.y] + 1
				queue.append(Vector2(i, j))
	return res_map
	
# if steps == -1 then return all path
func get_array_path(from, steps = -1):
	var res = []
	print("get path from ", from)
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
		print("draf in ", it,  "   ___    ", bfs_map[it.y][it.x])
		set_cellv(it, 0)

func create_2d_array(n, m, val = 0):
	var arr = []
	for i in range(n):
		arr.append([])
		for j in range(m):
			arr[i].append(val)
	return arr