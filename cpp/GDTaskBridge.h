#ifndef GDTASKBRIDGE_H
#define GDTASKBRIDGE_H

#include <Godot.hpp>
#include <Node2D.hpp>

#include "TaskArchive/task.h"
#include "TaskArchive/taskarchive.h"

#include <string>
#include <vector>

namespace godot {

	class GDTaskBridge : public Node2D {
		GODOT_CLASS(GDTaskBridge, Node2D)
	public:

		static void _register_methods();

		void _init();

		void kek();

		void init_acrhive(String path);

		String get_next_enemy_task(int lvl);	

	private:
		TaskArchive enemy_archive;
	};

}

#endif // GDTASKBRIDGE_H