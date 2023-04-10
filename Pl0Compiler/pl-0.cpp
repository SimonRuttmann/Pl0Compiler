#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
//Include intermediate code classes
#include "IntermediateCode.h"
int startParse(int argc, char* argv[]);
#include "y.tab.h"

int main(int argc, char* argv[])
{
	int res = startParse(argc, argv);
	return res;
}