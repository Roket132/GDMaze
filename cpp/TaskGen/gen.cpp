#include "gen.h"

#define ALL(c) (c).begin(), (c).end()
using namespace std;
using ll = long long;
using ld = long double;

struct dsu {
	vector<int> p, sz;
	dsu(int n) {
		p.resize(n);
		for (int i = 0; i < n; ++i) p[i] = i;
		sz.assign(n, 1);
	}
	int get(int i) {
		return i == p[i] ? i : p[i] = get(p[i]);
	}
	bool unite(int i, int j) {
		i = get(i);
		j = get(j);
		if (i == j) return false;
		if (sz[i] < sz[j]) swap(i, j);
		p[j] = i;
		sz[i] += sz[j];
		return true;
	}
};

int dist(int ax, int ay, int bx, int by) {
	return abs(ax - bx) + abs(ay - by);
}

mt19937 rnd(chrono::high_resolution_clock::now().time_since_epoch().count());
int dx[4] = { -1,0,1,0 };
int dy[4] = { 0,-1,0,1 };

void dfs(vector<string>& a, int x, int y) {
	if (a[x][y] == '#') return;
	a[x][y] = '#';
	for (int k = 0; k < 4; ++k) {
		int tx = x + dx[k];
		int ty = y + dy[k];
		if (tx < 0 || ty < 0 || tx >= a.size() || ty >= a[tx].size() || a[tx][ty] == '#') continue;
		dfs(a, tx, ty);
	}
}

bool connected(vector<string> a) {
	int n = a.size(), m = a[0].size();
	for (int i = 0; i < n; ++i)
		for (int j = 0; j < m; ++j) if (a[i][j] != '#') {
			dfs(a, i, j);
			i = a.size();
			break;
		}
	int walls = 0;
	for (string& r : a) for (char c : r) if (c == '#') ++walls;
	return walls == n * m;
}

vector<vector<int>> distmap(int x, int y, const vector<string>& a) {
	int n = a.size(), inf = 1e9;
	int m = a[0].size();
	vector<vector<int>> d(n, vector<int>(m, inf));
	vector<pair<int, int>> q = { {x,y} };
	d[x][y] = 0;
	for (int h = 0; h < q.size(); ++h) {
		x = q[h].first;
		y = q[h].second;
		for (int k = 0; k < 4; ++k) {
			int tx = x + dx[k];
			int ty = y + dy[k];
			if (tx < 0 || ty < 0 || tx >= n || ty >= m || a[tx][ty] == '#') continue;
			if (d[tx][ty] == inf) {
				d[tx][ty] = d[x][y] + 1;
				q.push_back({ tx,ty });
			}
		}
	}
	return d;
}

vector<pair<int, int>> cells_in_dist(int sx, int sy, const vector<string>& a, int dmin, int dmax) {
	int n = a.size(), inf = 1e9;
	int m = a[0].size();
	vector<pair<int, int>> res, q = { {sx,sy} };
	map<pair<int, int>, int> d;
	d[{sx, sy}] = 0;
	for (int h = 0; h < q.size(); ++h) {
		int x = q[h].first, y = q[h].second;
		if (dmin <= d[{x, y}]) res.push_back({ x,y });
		if (d[{x, y}] == dmax) continue;
		for (int k = 0; k < 4; ++k) {
			int tx = x + dx[k];
			int ty = y + dy[k];
			if (tx < 0 || ty < 0 || tx >= n || ty >= m || a[tx][ty] == '#') continue;
			pair<int, int> to(tx, ty);
			if (!d.count(to)) {
				d[to] = d[{x, y}] + 1;
				q.push_back(to);
			}
		}
	}
	return res;
}


int steps(int x, int y, const vector<string>& a, string bad) {
	set<char> ch(ALL(bad));
	vector<pair<int, int>> q = { {x,y} };
	map<pair<int, int>, int> d;
	d[{x, y}] = 0;
	for (int h = 0; h < q.size(); ++h) {
		x = q[h].first;
		y = q[h].second;
		if (ch.count(a[x][y])) return d[{x, y}];
		for (int k = 0; k < 4; ++k) {
			int tx = x + dx[k];
			int ty = y + dy[k];
			if (tx < 0 || ty < 0 || tx >= a.size() || ty >= a[tx].size() || a[tx][ty] == '#') continue;
			pair<int, int> t = { tx,ty };
			if (!d.count(t)) {
				d[t] = d[{x, y}] + 1;
				q.push_back(t);
			}
		}
	}
	return 1e9;
}

/*
int steps(int x, int y, vector<string> &a, string bad){
	int n = a.size(), m = a[0].size(), inf = 1e9;
	set<char> ch(ALL(bad));
	vector<pair<int,int>> q = {{x,y}};
	vector<vector<int>> d(n, vector<int>(m,inf));
	d[x][y] = 0;
	for(int h=0;h<q.size();++h){
		x = q[h].first;
		y = q[h].second;
		if(ch.count(a[x][y])) return d[x][y];
		for(int k=0;k<4;++k){
			int tx = x+dx[k];
			int ty = y+dy[k];
			if(tx<0 || ty<0 || tx>=n || ty>=m || a[tx][ty]=='#') continue;
			if(d[tx][ty]==inf){
				d[tx][ty] = d[x][y] + 1;
				q.push_back({x,y});
			}
		}
	}
	return 1e9;
}
*/


bool no2x2(vector<string> a) {
	for (int i = 0; i + 1 < a.size(); ++i)
		for (int j = 0; j + 1 < a[i].size(); ++j)
			if (a[i][j] == '#' && a[i + 1][j] == '#' && a[i][j + 1] == '#' && a[i + 1][j + 1] == '#')
				return false;
	return true;
}


vector<pair<int, int>> get_pool(vector<string>& a) {
	vector<pair<int, int>> res;
	for (int i = 0; i < a.size(); ++i)
		for (int j = 0; j < a[i].size(); ++j) if (a[i][j] == '.')
			res.push_back({ i,j });
	return res;
}

void erase_from_pool(vector<pair<int, int>>& pool, pair<int, int> cell) {
	/*set<pair<int,int>> u(ALL(pool));
	assert(u.size() == pool.size());
	u.erase(cell);
	pool.assign(ALL(u));*/
	/*auto it = find(ALL(pool), cell);
	if(it<pool.end()) pool.erase(it);*/
	for (int i = 0; i < pool.size(); ++i) if (pool[i] == cell) {
		pool[i] = pool.back();
		pool.pop_back();
		return;
	}
}

vector<pair<int, int>> get_cuts(vector<string> a) {
	vector<pair<int, int>> res;
	for (int i = 0; i < a.size(); ++i)
		for (int j = 0; j < a[i].size(); ++j) if (a[i][j] == '.') {
			a[i][j] = '#';
			if (!connected(a)) res.push_back({ i,j });
			a[i][j] = '.';
		}
	return res;
}

vector<string> gen(int n, int m, map<string, int> params, boost::signals2::signal<void(int)> &signal_value_changed) {
	//ofstream out("maze.txt");

	int midx = n / 2;
	int midy = m / 2;

	int lim = n * m * params["walls"] / 100;
	int wrand = params["wrand"];

	int resd = 0;
	vector<string> W;

	signal_value_changed(0);

	for (int it = 0; it < 1; ++it) {

		vector<string> w(n, string(m, '.'));

		vector<pair<int, int>> cells;
		for (int i = 0; i < n; ++i)
			for (int j = 0; j < m; ++j) cells.push_back({ i,j });


		auto pool = cells;
		for (int k = 0; k < cells.size(); ++k) {
			int i = rnd() % pool.size();
			for (int h = 0; h < wrand; ++h) {
				int i2 = rnd() % pool.size();
				if (dist(pool[i].first, pool[i].second, midx, midy) >
					dist(pool[i2].first, pool[i2].second, midx, midy)) i = i2;
			}
			cells[k] = pool[i];
			swap(pool[i], pool.back());
			pool.pop_back();
		}

		// first 
		signal_value_changed(1);

		int cur = 0;
		for (auto cell : cells) {
			int x = cell.first;
			int y = cell.second;
			w[x][y] = '#';
			if (no2x2(w) && connected(w)) {
				++cur;
				if (cur >= lim) break;
			}
			else {
				w[x][y] = '.';
			}
		}

		W = w;
	}
		
	signal_value_changed(2);

	//std::cout << "respawns" << std::endl;

	///respawns
	vector<vector<vector<int>>> dto(4);
	vector<pair<int, int>> resps(4);
	for (int k = 0, h = 3; k < 4; ++k) {
		int ax, ay, bx, by;
		if (k == 0) ax = 0, bx = h, ay = 0, by = h;
		if (k == 1) ax = n - h - 1, bx = n - 1, ay = 0, by = h;
		if (k == 2) ax = n - h - 1, bx = n - 1, ay = m - h - 1, by = m - 1;
		if (k == 3) ax = 0, bx = h, ay = m - h - 1, by = m - 1;
		int x, y;
		do {
			x = rnd() % (bx - ax + 1) + ax;
			y = rnd() % (by - ay + 1) + ay;
		} while (W[x][y] == '#');
		W[x][y] = 'S';
		dto[k] = distmap(x, y, W);
		resps[k] = { x,y };
	}


	signal_value_changed(3);

	//std::cout << "DOOR" << std::endl;
	//DOOR
	int doorx, doory, doordist = -1;
	for (int i = n / 3; i < n - n / 3; ++i)
		for (int j = m / 3; j < m - m / 3; ++j) if (W[i][j] == '.') {
			int res = 1e9;
			for (int k = 0; k < 4; ++k) res = min(res, dto[k][i][j]);
			if (res > doordist) {
				doordist = res;
				doorx = i;
				doory = j;
			}
		}
	W[doorx][doory] = 'E';
	cerr << "ddist = " << doordist << endl;

	//std::cout << "FAKEL" << std::endl;
	signal_value_changed(4);

	//FAKEL init
	for (int d : {4, 10, 30})
		for (int k = 0; k < 4; ++k) {
			auto c = cells_in_dist(resps[k].first, resps[k].second, W, d, d);
			assert(c.size() > 0);
			auto cell = c[rnd() % c.size()];
			W[cell.first][cell.second] = 'T';
		}
	int fakel_radius = params["fakel_radius"];
	auto fakel_pool = get_pool(W);
	while (!fakel_pool.empty()) {
		auto cell = fakel_pool[rnd() % fakel_pool.size()];
		auto c = cells_in_dist(cell.first, cell.second, W, 0, fakel_radius);
		for (auto cc : c) erase_from_pool(fakel_pool, cc);
		W[cell.first][cell.second] = 'T';
	}

	//std::cout << "FIRE" << std::endl;
	signal_value_changed(5);

	//FIRE init
	int fire_radius = params["fire_radius"];
	auto fpool = get_pool(W);
	for (int k = 0; k < 4; ++k) {
		auto c = cells_in_dist(resps[k].first, resps[k].second, W, 1, 1);
		assert(c.size() > 0);
		auto cell = c[rnd() % c.size()];
		W[cell.first][cell.second] = 'B';
		erase_from_pool(fpool, cell);
		c = cells_in_dist(cell.first, cell.second, W, 0, fire_radius);
		for (auto cc : c) erase_from_pool(fpool, cc);
	}
	while (!fpool.empty()) {
		auto cell = fpool[rnd() % fpool.size()];
		auto c = cells_in_dist(cell.first, cell.second, W, 0, fire_radius);
		for (auto cc : c) erase_from_pool(fpool, cc);
		W[cell.first][cell.second] = 'B';
	}


	signal_value_changed(6);

	//std::cout << "CHESTS" << std::endl;

	///CHESTS
	int chest_radius = params["chest_radius"]; 
	auto chest_pool = get_pool(W);
	while (!chest_pool.empty()) {
		auto cell = chest_pool[rnd() % chest_pool.size()];
		auto c = cells_in_dist(cell.first, cell.second, W, 0, chest_radius);
		for (auto cc : c) erase_from_pool(chest_pool, cc);
		W[cell.first][cell.second] = '.';
	}

	signal_value_changed(7);

	//std::cout << "ARROWS" << std::endl;

	///ARROWS
	int arrow_radius = params["arrow_radius"];
	auto arrow_pool = get_pool(W);
	for (int k = 0; k < 4; ++k) {
		auto c = cells_in_dist(resps[k].first, resps[k].second, W, 0, arrow_radius / 2);
		for (auto cc : c) erase_from_pool(arrow_pool, cc);
	}
	for (int arrows = 0; arrows < 15 * 4 * 2 && !arrow_pool.empty();) {
		auto cell = arrow_pool[rnd() % arrow_pool.size()];
		auto c = cells_in_dist(cell.first, cell.second, W, 0, arrow_radius);
		for (auto cc : c) erase_from_pool(arrow_pool, cc);
		W[cell.first][cell.second] = 'A';
		++arrows;
	}

	signal_value_changed(8);

	//std::cout << "LIONS" << std::endl;

	///LIONS
	{
		int lion_radius = params["lion_radius"];
		int lions_limit = params["lions_limit"];
		auto lion_pool = get_cuts(W);
		for (int k = 0; k < 4; ++k) {
			auto c = cells_in_dist(resps[k].first, resps[k].second, W, 0, lion_radius);
			for (auto cc : c) erase_from_pool(lion_pool, cc);
		}
		for (int i = 0; i < n; ++i)
			for (int j = 0; j < m; ++j) {
				if (W[i][j] != '.' && W[i][j] != '#') {
					for (auto c : cells_in_dist(i, j, W, 0, 2)) erase_from_pool(lion_pool, c);
				}
			}
		for (int lions = 0; lions < lions_limit && !lion_pool.empty();) {
			auto cell = lion_pool[rnd() % lion_pool.size()];
			auto c = cells_in_dist(cell.first, cell.second, W, 0, lion_radius);
			for (auto cc : c) erase_from_pool(lion_pool, cc);
			W[cell.first][cell.second] = 'L';
			++lions;
		}
	}

	signal_value_changed(9);

	//std::cout << "DRAGONS" << std::endl;

	///DRAGONS
	{
		int dragon_radius = params["dragon_radius"];
		int dragons_limit = params["dragons_limit"];
		auto dragon_pool = get_cuts(W);
		for (int k = 0; k < 4; ++k) {
			auto c = cells_in_dist(resps[k].first, resps[k].second, W, 0, dragon_radius);
			for (auto cc : c) erase_from_pool(dragon_pool, cc);
		}
		for (int i = 0; i < n; ++i)
			for (int j = 0; j < m; ++j) {
				if (W[i][j] != '.' && W[i][j] != '#') {
					for (auto c : cells_in_dist(i, j, W, 0, 2)) erase_from_pool(dragon_pool, c);
				}
			}
		for (int dragons = 0; dragons < 5 * 4 * 2 && !dragon_pool.empty();) {
			auto cell = dragon_pool[rnd() % dragon_pool.size()];
			auto c = cells_in_dist(cell.first, cell.second, W, 0, dragon_radius);
			for (auto cc : c) erase_from_pool(dragon_pool, cc);
			W[cell.first][cell.second] = 'D';
			++dragons;
		}
	}

	signal_value_changed(10);

	//std::cout << "ALL" << std::endl;

	cerr << resd << endl;
	for (int k = 0; k < 4; ++k) {
		cerr << k << " dist: " << steps(resps[k].first, resps[k].second, W, "E") << endl;
	}

	signal_value_changed(11);

	//std::cout << "FOKING" << std::endl;

	W.insert(W.begin(), string(m, '#'));
	W.push_back(W[0]);
	for (string& r : W) r = "#" + r + "#";

	signal_value_changed(12);

	//std::cout << "RETURN" << std::endl;

	return W;

	//	out<<"\r\n";
	vector<pair<char, string>> vv = {
		{'B', "fires"},
		{'T', "fakels"},
		{'.', "chests"},
		{'A', "arrows"},
		{'L', "lions"},
		{'D', "dragons"}
	};
	for (pair<char, string> p : vv) {
		int cnt = 0;
		for (string row : W) cnt += count(ALL(row), p.first);
		//out<<p.second<<" ("<<p.first<<"): "<<cnt<<"\r\n";
	}
}

/*
0 пол
1 стена
2 респ
L лев
D дракон
3 факел
B костёр (50)
9 дверь
P pekti
$ chest

*/

std::vector<std::string> Generator::main_generator(int n, int m, map<string, int> _params)
{
	//freopen("input.txt","r",stdin); //freopen("output.txt","w",stdout);
	ios::sync_with_stdio(0); cin.tie(0);//cout.precision(12);cout<<fixed;

	map<string, int> params = _params;
	/*
	map<string, int> params = {
		{"walls", 35}, //процент стен
		{"fakel_radius", 40},
		{"fire_radius", 25},
		{"arrow_radius", 25},
		{"lion_radius", 25},
		{"lions_limit", 10 * 4 * 2},
		{"dragon_radius", 35},
		{"dragons_limit", 5 * 4 * 2},
		{"chest_radius", 22},
	};
	*/
	signal_max_value_changed(12);

	return gen(n, m, params, signal_value_changed);
}
