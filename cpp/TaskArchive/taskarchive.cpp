#include "taskarchive.h"

#include <iostream>
#include <fstream>
#include <cctype>
#include <string>
#include <algorithm>

using std::unique_ptr;

TaskArchive::TaskArchive() : currentTask(0) {
    mutex_ = new std::mutex;
}

TaskArchive::TaskArchive(fs::path path) : currentTask()  {
    readFile(path);
}

namespace {

    void removeLeadSpaces(std::string &str) {
        std::reverse(str.begin(), str.end());
        while (str.back() == ' ') str.pop_back();
        std::reverse(str.begin(), str.end());
    }

    std::string lower(const std::string &str) {
        std::string res = str;
        std::transform(res.begin(), res.end(), res.begin(),
            [](unsigned char c){ return std::tolower(c); });
        return res;
    }

}

bool TaskArchive::readFile(fs::path path) {
    //std::lock_guard<std::mutex> lg(*mutex_);

    std::fstream file;

    try {
        file.open(path.string(), std::ifstream::in);
    } catch (std::ifstream::failure e) {
        std::cerr << "Cannot readFile for TaskArchive" << std::endl;
        return false;
    }

    constexpr size_t bufferSize = 1024;
    unique_ptr<char[]> buffer(new char[bufferSize]);

    static const int NAME = 1;
    static const int TASK = 2;
    static const int ANSWER = 3;
    static const int LVL = 4;
    int mode = 0;

    std::string name;
    std::string task;
    std::string answer;
    std::string lvl;
    std::vector<std::string> answers;

    while (file) {
        file.read(buffer.get(), bufferSize);

        for (size_t i = 0; i < bufferSize; i++) {
            if (buffer.get()[i] == '<') {
                mode = NAME;
            } else if (buffer.get()[i] == '{') {
                mode = TASK;
            } else if (buffer.get()[i] == '[') {
                if (mode == NAME) mode = LVL;
                else
                    mode = ANSWER;
            } else if (buffer.get()[i] == '>' || buffer.get()[i] == '}') {
                mode = 0;
                if (name == "!END!") {
                    break;
                }
            } else if (buffer.get()[i] == ']') {
                if (mode == ANSWER) {
                    removeLeadSpaces(answer);
                    answers.emplace_back(answer);
                    if (lvl == "") lvl = "1";
                    addTask(std::make_shared<Task>(Task(name, task, lvl, answers)));
                    name = task = answer = lvl = "";
                    answers.clear();
                }
                mode = 0;
            } else if (buffer.get()[i] == ',' && mode == ANSWER) {
                removeLeadSpaces(answer);
                answers.emplace_back(answer);
                answer = "";
            } else {
                char ch = buffer.get()[i];
                if (mode == NAME) name += ch;
                if (mode == TASK) task += ch;
                if (mode == ANSWER) answer += ch;
                if (mode == LVL) lvl += ch;
            }
        }
    }

	std::cout << "rturn " << std::endl;
    return true;
}

void TaskArchive::addTask(std::shared_ptr<Task> task) {
    std::lock_guard<std::mutex> lg(*mutex_);
    auto lvl = task->getLvl();
    //std::cerr << "AddTask lvl = " << lvl << " " << task->getName() << " " << task->getText() << std::endl;
    if (tasks.size() <= lvl) {
        tasks.resize(lvl + 1);
        currentTask.resize(lvl + 1, 0);
    }
    for (auto it : tasks[lvl]) {
        if (it->getName() == task->getName()) {
            return;
        }
    }
    tasks[lvl].emplace_back(task);
}

std::shared_ptr<Task> TaskArchive::getNextTask(size_t lvl) {
    std::lock_guard<std::mutex> lg(*mutex_);
    if (lvl >= tasks.size() || currentTask[lvl] >= tasks[lvl].size())
        return std::make_shared<Task>(Task("nullptr", "nullptr", "1", std::vector<std::string>(1, "ok")));
    return tasks[lvl][currentTask[lvl]++];
}

std::shared_ptr<Task> TaskArchive::getTask(size_t pos, size_t lvl) {
    std::lock_guard<std::mutex> lg(*mutex_);
    if (lvl >= tasks.size() || pos >= tasks[lvl].size())
        return std::make_shared<Task>(Task("nullptr", "nullptr", "1", std::vector<std::string>(1, "ok")));
    return tasks[lvl][pos];
}

bool TaskArchive::checkAnswer(std::string answer, std::string taskName, size_t lvl) {
    std::lock_guard<std::mutex> lg(*mutex_);
    if (taskName == "nullptr") return true;
    removeLeadSpaces(answer);
    for (auto it : tasks[lvl]) {
        if (it->getName() == taskName) {
            for (auto ans : *it->getAnswer())
                if (lower(ans) == lower(answer)) return true;
            return false;
        }
    }
    return false;
}

void TaskArchive::clear() {
    std::lock_guard<std::mutex> lg(*mutex_);
    currentTask.clear();
    for (size_t lvl = 0; lvl < tasks.size(); lvl++) {
        for (auto it : tasks[lvl]) {
            it.~shared_ptr();
        }
    }
    tasks.clear();
}
