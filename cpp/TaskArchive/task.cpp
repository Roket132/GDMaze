#include "task.h"

#include <iostream>

using std::string;
using std::vector;

Task::Task(std::string name, std::string text, std::string lvl, std::vector<std::string> answers) :
    name_(name), text_(text), lvl_(static_cast<size_t>(std::stoi(lvl)))
{
    std::swap(answers_, answers);
}

void Task::setName(std::string name) {
    name_ = name;
}

void Task::setText(std::string text) {
    text_ = text;
}

void Task::addAnswer(std::string ans) {
    answers_.emplace_back(ans);
}


std::string Task::getName() {
    return name_;
}

std::string Task::getText() {
    return text_;
}

std::vector<std::string> *Task::getAnswer() {
    return &answers_;
}

size_t Task::getLvl() const
{
    return lvl_;
}

void Task::setLvl(const size_t &lvl)
{
    lvl_ = lvl;
}
