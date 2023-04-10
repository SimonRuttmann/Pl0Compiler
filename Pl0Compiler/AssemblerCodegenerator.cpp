#include "AssemblerCodegenerator.h"

AssemblerCodegenerator* AssemblerCodegenerator::instance = nullptr;

AssemblerCodegenerator::AssemblerCodegenerator()
{
}

AssemblerCodegenerator::~AssemblerCodegenerator()
{
}


AssemblerCodegenerator* AssemblerCodegenerator::getInstance()
{
	if (instance == nullptr)
		instance = new AssemblerCodegenerator();

	return instance;
}

void AssemblerCodegenerator::setFile(FILE* file)
{
	f = file;
}