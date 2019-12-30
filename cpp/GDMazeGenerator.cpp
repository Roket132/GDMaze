#include "GDMazeGenerator.h"

using namespace godot;

void godot::GDMazeGenerator::_register_methods()
{
	register_method("generate", &GDMazeGenerator::generate);

	register_signal<GDMazeGenerator>((char*)"progress_max_value_changed", "max_value", GODOT_VARIANT_TYPE_INT);
	register_signal<GDMazeGenerator>((char*)"progress_value_changed", "current_value", GODOT_VARIANT_TYPE_INT);
}

void godot::GDMazeGenerator::_init()
{
}

static GDMazeGenerator* global_this;

namespace {
	void hide_update_max_value(int max_value) {
		global_this->update_max_value(max_value);
	}

	void hide_update_value(int value) {
		global_this->update_value(value);
	}
}

// n, m, walls, torch_r, bonfire_r, arrow_r, chest_r, lvl1_r, l, lvl2_r, l

Array godot::GDMazeGenerator::generate(Array args)
{	
	global_this = this;
	int n = int(args[0]) + 2, m = int(args[1]) + 2;

		std::map<std::string, int> _params = {
			{"walls", args[2]},
			{"fakel_radius", args[3]},
			{"fire_radius", args[4]},
			{"arrow_radius", args[5]},
			{"chest_radius", args[6]},
			{"lion_radius", args[7]},
			{"lions_limit", args[8]},
			{"dragon_radius", args[9]},
			{"dragons_limit", args[10]},
		};

	Generator generator;
	generator.signal_max_value_changed.connect(&hide_update_max_value);
	generator.signal_value_changed.connect(&hide_update_value);

	std::vector<std::string> res = generator.main_generator(int(args[0]), int(args[1]), _params);

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

void godot::GDMazeGenerator::update_max_value(int max_value)
{
	emit_signal("progress_max_value_changed", max_value);
}

void godot::GDMazeGenerator::update_value(int value)
{
	emit_signal("progress_value_changed", value);
}
