#include "GDTaskBridge.h"

using namespace godot;

void godot::GDTaskBridge::_register_methods()
{
	register_method("init_acrhive", &GDTaskBridge::init_acrhive);
	register_method("get_next_enemy_task", &GDTaskBridge::get_next_enemy_task);
	//register_method("kek", &GDTaskBridge::kek);

//	register_property<GDTest, String>("data", &GDTest::_data, String("Hello world"));
//  register_property<GDTest, String>("data", &GDTest::set_data, &GDTest::get_data, String("Hello world"));
}

void godot::GDTaskBridge::_init()
{
}

void godot::GDTaskBridge::init_acrhive(String enemy_path)
{
	std::cout << "start" << std::endl;
	std::string std_enemy_path = enemy_path.utf8().get_data();
	std::cout << "str = " << std_enemy_path << std::endl;
	fs::path p = std_enemy_path;
	std::cout << "ok" << std::endl;
	enemy_archive.readFile(std_enemy_path);
}

String godot::GDTaskBridge::get_next_enemy_task(int lvl)
{
	auto task = enemy_archive.getNextTask(lvl);
	std::string name = task->getName();
	return name.c_str();
}

