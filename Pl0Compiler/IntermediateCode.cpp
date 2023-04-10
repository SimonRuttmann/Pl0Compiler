#include <iostream>
#include <iostream>
#include <algorithm>
#include "IntermediateCode.h"
#include "pl0-symtab.hpp"

using namespace std;

//---------------------------------------------------------------------------------------------------//
// IdentifierNode (var a) -> IdentifierNode (var b) -> IdentifierNode (var c)                        //
//---------------------------------------------------------------------------------------------------//

IdentifierNode::IdentifierNode(string identifier)
	: identifier(identifier)
{
}

IdentifierNode::~IdentifierNode()
{
}

//Simple function to get the size of the identifier chain (only used for variables) 
void IdentifierNode::getNumberOfVariablesInChain(int & numVariables){

	numVariables++;
	
	if (next != nullptr)
	{
		next->getNumberOfVariablesInChain(numVariables);
	}
}


//---------------------------------------------------------------------------------------------------//
//			    ExpressionNode 																		 //
//		Left					Right															     //
// 	ExpressionNode			ExpressionNode															 //
//																									 //
// Identifierinformations (Variables, Constants)													 //
// The Id for constants, the level and the offset for variables										 //
//---------------------------------------------------------------------------------------------------//

ExpressionNode::ExpressionNode(AssemblerCodegenerator::ExpressionType type, ExpressionNode* leftNode, ExpressionNode* rightNode)
	: type(type), leftNode(leftNode), rightNode(rightNode)
{
}


ExpressionNode::ExpressionNode(string identifier, AssemblerCodegenerator::ExpressionType type, ExpressionNode* leftNode, ExpressionNode* rightNode)
	: identifier(identifier), type(type), leftNode(leftNode), rightNode(rightNode)
{
}

ExpressionNode::~ExpressionNode()
{
}

void ExpressionNode::generateAssemblerCodeForExpressionTree()
{
	if (leftNode != nullptr)
	{
		leftNode->generateAssemblerCodeForExpressionTree();
	}
		
	if (rightNode != nullptr)
	{
		rightNode->generateAssemblerCodeForExpressionTree();
	}

	writeMyNodeAsAssemblerCode();
}

void ExpressionNode::writeMyNodeAsAssemblerCode()
{
	int val = 9999;
	if(type == AssemblerCodegenerator::CONST){
		val = value;
	}

	AssemblerCodegenerator::getInstance()->writeExpression(type, offset, level, identifier, val);
}

//---------------------------------------------------------------------------------------------------//
//			    StatementNode --next--> StatementNode --next--> StatementNode ... 					 //
// 	            ExpressionNode	ExpressionNode													     //
//																									 //
// Identifierinformations (Variables, Constants)													 //
// The Id for constants, the level and the offset for variables										 //
//---------------------------------------------------------------------------------------------------//


StatementNode::StatementNode(AssemblerCodegenerator::StatementType type, string identifier, int jumpTarget)
	: type(type), identifier(identifier), jumpTarget(jumpTarget)
{
	next = nullptr;
	nextStatementChain = nullptr;
	expressionNode = nullptr;
}

StatementNode::StatementNode(AssemblerCodegenerator::StatementType type, int jumpTarget)
	: type(type), jumpTarget(jumpTarget)
{
	next = nullptr;
	nextStatementChain = nullptr;
	expressionNode = nullptr;
}

StatementNode::StatementNode(AssemblerCodegenerator::StatementType type, string identifier)
	: type(type),  identifier(identifier)
{
	next = nullptr;
	nextStatementChain = nullptr;
	expressionNode = nullptr;
}

StatementNode::StatementNode(AssemblerCodegenerator::StatementType type)
	: type(type)
{
	next = nullptr;
	nextStatementChain = nullptr;
	expressionNode = nullptr;
}

StatementNode::~StatementNode()
{
}

void StatementNode::generateAssemblerCode()
{
	if (expressionNode != nullptr)
	{
		if (type == AssemblerCodegenerator::ASSIGN)
		{
			AssemblerCodegenerator::getInstance()->writeAssignmentHeader(level, offset);
            expressionNode->generateAssemblerCodeForExpressionTree();
            AssemblerCodegenerator::getInstance()->writeAssignmentFooter();
		}
		else
		{
			expressionNode->generateAssemblerCodeForExpressionTree();
			AssemblerCodegenerator::getInstance()->writeStatement(type, level, offset, identifier, jumpTarget);
		}
	}
	else if (expressionNode == nullptr){
		AssemblerCodegenerator::getInstance()->writeStatement(type, level, offset, identifier, jumpTarget);
    }
	if (next != nullptr)
	{
		next->generateAssemblerCode();
	}
	if (nextStatementChain != nullptr)
	{
		nextStatementChain->generateAssemblerCode();
	}
}

//---------------------------------------------------------------------------------------------------//
//	Block Node (Main)   -> IdentifierNode (Variables) -> IdentifierNode (Constants) -> StatmentNodes //
//  Block Node (Proc 1)	-> IdentifierNode (Variables) -> IdentifierNode (Constants) -> StatmentNodes //
//  ....			 																				 //
//---------------------------------------------------------------------------------------------------//

BlockNode::BlockNode(string identifier, StatementNode* firstStatementNode, IdentifierNode* firstConstantNode, IdentifierNode* firstVariableNode)
	: identifier(identifier), firstStatementNode(firstStatementNode), firstConstantNode(firstConstantNode), firstVariableNode(firstVariableNode)
{
	level = 0;
	offset = 0;
	numberOfVariables = 0;
}

BlockNode::~BlockNode()
{
}

void BlockNode::resolveAmountVariables()
{
	if (firstVariableNode != nullptr)
	{
		int chainLength = 0;
		firstVariableNode->getNumberOfVariablesInChain(chainLength);
		numberOfVariables = chainLength;
	}
}

void BlockNode::generateAssemblerCode()
{
	AssemblerCodegenerator::getInstance()->writeProcedureHeader(identifier, numberOfVariables);

	if(firstStatementNode == nullptr || firstStatementNode == NULL){
		
	} 
	else{
		firstStatementNode->generateAssemblerCode();
	}
	
	AssemblerCodegenerator::getInstance()->writeProcedureFooter();
}


//---------------------------------------------------------------------------------------------------//
//	Singleton holding all procedures as block nodes and the "main" procedure as blocknode 		 	 //
//        			 																				 //
//---------------------------------------------------------------------------------------------------//

DataModel* DataModel::instance = nullptr;

DataModel::DataModel()
{
	procedures = vector<BlockNode*>();
}

DataModel::~DataModel()
{
}

DataModel* DataModel::getInstance()
{
	if (instance == nullptr){
		instance = new DataModel();
	}

	return instance;
}


void DataModel::prepareAssemberGeneration()
{
	//Reverse procedures, as due to the recursive parser there are in the wrong order
	reverse(procedures.begin(), procedures.end());

	//Add an increasing offset to each procedure
	int i = 0;
	for (auto & blockNode : procedures)
	{
		blockNode->offset = i;
		i += 1;
	}

	//Calculate the amount of variables for each procedure
	for (auto& blockNode : procedures){
		blockNode->resolveAmountVariables();
	}
		
}


void DataModel::generateAssember()
{
	for (auto & blockNode : procedures)
	{
		currentLevel = blockNode->level;
		blockNode->generateAssemblerCode();
	}
}

