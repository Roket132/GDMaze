#ifndef TASK_H
#define TASK_H

#include <string>
#include <vector>


class Task {
public:
    Task(std::string name = "", std::string text = "", std::string lvl = "1", std::vector<std::string> answers = std::vector<std::string>());

    void setName(std::string name);
    void setText(std::string text);

    void addAnswer(std::string ans);

    std::string getName();
    std::string getText();
    std::vector<std::string>* getAnswer();

    size_t getLvl() const;
    void setLvl(const size_t &lvl);

private:
    std::string name_;

    std::string text_;

    std::vector<std::string> answers_;

    size_t lvl_;
};

#endif // TASK_H
