#ifndef TASKARCHIVE_H
#define TASKARCHIVE_H

#include <filesystem> 
#include <vector>
#include <mutex>
#include <memory>
#include <set>
#include <map>

#include "task.h"

namespace fs = std::filesystem;

class TaskArchive
{
public:

    TaskArchive();

    TaskArchive(fs::path path);

    bool readFile(fs::path path); // looking for "tasks" in file

    void addTask(std::shared_ptr<Task> task);

    std::shared_ptr<Task> getNextTask(size_t lvl);
    std::shared_ptr<Task> getTask(size_t pos, size_t lvl);

    bool checkAnswer(std::string answer, std::string taskName, size_t lvl);

    void clear();

private:
    std::vector<std::vector<std::shared_ptr<Task>>> tasks;
    std::vector<size_t> currentTask;

    std::mutex* mutex_;
};

#endif // TASKARCHIVE_H
