#pragma once

#include <algorithm>
#include <iostream>
#include <assert.h>
#include <vector>
#include <string>
#include <random>
#include <chrono>
#include <ctime>
#include <set>
#include <map>

#include <boost/signals2.hpp>

class Generator {
public:
	std::vector<std::string> main_generator(int n, int m, std::map<std::string, int> _params);

	boost::signals2::signal<void(int)> signal_max_value_changed;

	boost::signals2::signal<void(int)> signal_value_changed;
};



