#include "DebugConsole.h"
using namespace std;

void DebugConsole::debug(string stringToLog)
{
    if(!this->shouldLog) return;

    printf(" %-30s| %-40s| %-20s|\n", "DEBUG:", stringToLog.c_str(), "");
}

void DebugConsole::printGrammar()
{
    if(!this->shouldLog) return;
    printf("------------------------------------------------------------------------------------------------\n");
    printf(" %-30s| %-40s| %-20s|\n", "Begin or end of grammar rule", "Grammar rule", "Alternative");
    printf("------------------------------------------------------------------------------------------------\n");
}

void DebugConsole::startGrammar(string grammar)
{
    if(!this->shouldLog) return;

    printf(" %-30s| %-40s| %-20s|\n", "Start grammar", grammar.c_str(), "");
}

void DebugConsole::endGrammar(string grammar)
{
    if(!this->shouldLog) return;

    printf(" %-30s| %-40s| %-20s|\n", "End   grammar", grammar.c_str(), "");
}

void DebugConsole::startGrammar(string grammar, string alternative)
{
    if(!this->shouldLog) return;

    printf(" %-30s| %-40s| %-20s|\n", "Start grammar", grammar.c_str(), alternative.c_str());
}

void DebugConsole::endGrammar(string grammar, string alternative)
{
    if(!this->shouldLog) return;

    printf(" %-30s| %-40s| %-20s|\n", "End   grammar", grammar.c_str(), alternative.c_str());
}