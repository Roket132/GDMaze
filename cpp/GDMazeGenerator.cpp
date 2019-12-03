#include "GDMazeGenerator.h"

using namespace godot;

void godot::GDMazeGenerator::_register_methods()
{
	register_method("generate", &GDMazeGenerator::generate);
}

void godot::GDMazeGenerator::_init()
{
}

Array godot::GDMazeGenerator::generate(Vector2 size)
{	
	int n = size.x + 2, m = size.y + 2;

	std::vector<std::string> res = main_generator(size.x, size.y);

	Array arr;

	for (int i = 0; i < n; i++) {
		Array row;
		for (int j = 0; j < m; j++) {
			std::string str;
			str += res[i][j];
			row.append(str.c_str());
		}
		arr.append(row);
	}

	return arr;
}
