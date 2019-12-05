#ifndef GDMAZEGENERATOR_H
#define GDMAZEGENERATOR_H

#include <Godot.hpp>
#include <Node2D.hpp>

#include "TaskGen/gen.h"

#include <iostream>
#include <vector>
#include <string>

namespace godot {

	class GDMazeGenerator : public Node2D {
		GODOT_CLASS(GDMazeGenerator, Node2D)
	public:

		static void _register_methods();

		void _init();

		Array generate(Vector2 size);

		void update_max_value(int max_value);

		void update_value(int value);
	};

}

#endif // GDMAZEGENERATOR_H