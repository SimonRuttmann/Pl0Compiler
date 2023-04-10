#pragma once
#include <string>
#include <vector>
#include "AssemblerCodegenerator.h"

//---------------------------------------------------------------------------------------------------//
// IdentifierNode (var a) -> IdentifierNode (var b) -> IdentifierNode (var c)                        //
//---------------------------------------------------------------------------------------------------//

class IdentifierNode
{
	public:
		IdentifierNode(std::string identifier);
		~IdentifierNode();

		IdentifierNode* next;
		std::string identifier;
	
		int value;

		void getNumberOfVariablesInChain(int & numVariables);
};

//---------------------------------------------------------------------------------------------------//
//			    ExpressionNode 																		 //
//		Left					Right															     //
// 	ExpressionNode			ExpressionNode															 //
//																									 //
// Identifierinformations (Variables, Constants)													 //
// The Id for constants, the level and the offset for variables										 //
//---------------------------------------------------------------------------------------------------//

class ExpressionNode
{
	public:

		ExpressionNode(AssemblerCodegenerator::ExpressionType type, ExpressionNode* leftNode, ExpressionNode* rightNode);

		//For number and const expression types
		ExpressionNode(std::string id, AssemblerCodegenerator::ExpressionType type, ExpressionNode* leftNode, ExpressionNode* rightNode);

		~ExpressionNode();

		AssemblerCodegenerator::ExpressionType type;

		ExpressionNode* leftNode;
		ExpressionNode* rightNode;

		std::string identifier;
		int level;
		int offset;

		//Only used by constants
		int value;

		//Writes an expression tree (with all nodes appended to this expression) as assember code into a file
		void generateAssemblerCodeForExpressionTree();

		//Writes the expression node as assember code into a file
		void writeMyNodeAsAssemblerCode();
};

//---------------------------------------------------------------------------------------------------//
//			    StatementNode --next--> StatementNode --next--> StatementNode ... 					 //
// 	            ExpressionNode	ExpressionNode													     //
//																									 //
// Identifierinformations (Variables, Constants)													 //
// The Id for constants, the level and the offset for variables										 //
//---------------------------------------------------------------------------------------------------//

class StatementNode
{
public:

	//Default C-Tor
	StatementNode(AssemblerCodegenerator::StatementType type, std::string identifier, int jumpTarget);

	//For If-Then and While-Do
	StatementNode(AssemblerCodegenerator::StatementType type, int jumpTarget);

	//For Assignment and Call and Write
	StatementNode(AssemblerCodegenerator::StatementType type, std::string identifier);

	//For NOP
	StatementNode(AssemblerCodegenerator::StatementType type);

	~StatementNode();


	AssemblerCodegenerator::StatementType type;


	StatementNode* next;
	ExpressionNode* expressionNode;

	//reference for while do and if then nodes
	int jumpTarget;

	//required to traverse the chains
	StatementNode* nextStatementChain;

	std::string identifier;
	int level;
	int offset;

	void generateAssemblerCode();
};


//---------------------------------------------------------------------------------------------------//
//	Block Node (Main)   -> IdentifierNode (Variables) -> IdentifierNode (Constants) -> StatmentNodes //
//  Block Node (Proc 1)	-> IdentifierNode (Variables) -> IdentifierNode (Constants) -> StatmentNodes //
//  ....			 																				 //
//---------------------------------------------------------------------------------------------------//


class BlockNode
{
public:
	BlockNode(std::string identifier, StatementNode* firstStatementNode, IdentifierNode* firstConstantNode, IdentifierNode* firstVariableNode);
	~BlockNode();

	std::string identifier;

	StatementNode* firstStatementNode;
	IdentifierNode* firstConstantNode;
	IdentifierNode* firstVariableNode;

	int numberOfVariables;
	int level;
	int offset;

	void generateAssemblerCode();
	void resolveAmountVariables();
};


//---------------------------------------------------------------------------------------------------//
//	Singleton holding all procedures as block nodes and the "main" procedure as blocknode 		 	 //
//        			 																				 //
//---------------------------------------------------------------------------------------------------//


class DataModel
{
	public:
		~DataModel();
		static DataModel* getInstance();

		BlockNode* mainProcedure;
		std::vector<BlockNode*> procedures;
		int currentLevel;

		void prepareAssemberGeneration();
		void generateAssember();

	private:
		DataModel();
		static DataModel* instance;
};








