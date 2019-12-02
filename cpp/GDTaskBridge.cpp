#include "GDTaskBridge.h"

using namespace godot;

void godot::GDTaskBridge::_register_methods()
{
	register_method("add_file", &GDTaskBridge::add_file);
	register_method("get_next_task", &GDTaskBridge::get_next_task);

//	register_property<GDTest, String>("data", &GDTest::_data, String("Hello world"));
//  register_property<GDTest, String>("data", &GDTest::set_data, &GDTest::get_data, String("Hello world"));
}

void godot::GDTaskBridge::_init()
{
}

namespace {
	String std_to_gd_string(std::string str) {
		return str.c_str();
	}

	std::string gd_to_std_string(String str) {
		return str.utf8().get_data();
	}

}

void godot::GDTaskBridge::add_file(String path)
{
	std::string std_path = path.utf8().get_data();
	_archive.readFile(std_path);
}

Dictionary godot::GDTaskBridge::get_next_task(int lvl)
{
	Dictionary task_dict;
	auto task = _archive.getNextTask(lvl);
	cur_task = task;

	task_dict["name"] = task->getName().c_str();
	task_dict["task"] = task->getText().c_str();
	task_dict["lvl"] = task->getLvl();

	auto answers = task->getAnswer();
	Array GDAnswers;

	for (auto it : *answers) {
		GDAnswers.push_back(std_to_gd_string(it));
	}

	task_dict["answers"] = GDAnswers;

	return task_dict;
}

