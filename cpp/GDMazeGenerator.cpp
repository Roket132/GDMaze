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

Array godot::GDMazeGenerator::generate(Vector2 size)
{	
	global_this = this;
	int n = size.x + 2, m = size.y + 2;

	Generator generator;
	generator.signal_max_value_changed.connect(&hide_update_max_value);
	generator.signal_value_changed.connect(&hide_update_value);

	std::vector<std::string> res = generator.main_generator(size.x, size.y);

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
