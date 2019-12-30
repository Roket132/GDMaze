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

		void add_file(String path);

		void add_task(Dictionary task_);

		Dictionary get_next_task(int lvl);

	private:
		TaskArchive _archive;

		std::shared_ptr<Task> cur_task;
	};

}

#endif // GDTASKBRIDGE_H