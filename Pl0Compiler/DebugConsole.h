#pragma once
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

class DebugConsole
{
    public:
    void debug(string stringToLog);

    void printGrammar();

    void startGrammar(string grammar);
    void endGrammar(string grammar);

    void startGrammar(string grammar, string alternative);
    void endGrammar(string grammar, string alternative);

private:
    bool shouldLog = false;
};