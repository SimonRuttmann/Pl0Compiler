%{
//---------------------------------------------------------------------------------------------------//
//                                           PL-0                                                    //
//---------------------------------------------------------------------------------------------------//
//                                                                                                   //
//      1 (∗ Berechnet GGT von zwei Zahlen ∗)                                                        //
//      2 VAR a, b, g;                                                                               //
//      3 PROCEDURE ggt;                            Funktionsbeginn ggt                              //
//      4 BEGIN                                                                                      //
//      5    WHILE a # b DO                         "#"  == Ungleich                                 //
//      6    BEGIN                                                                                   //
//      7       IF a > b THEN a := a − b;           ":=" == Zuweisung                                //
//      8       IF b > a THEN b := b − a;                                                            //
//      9    END;                                                                                    //
//      10   g := a;                                                                                 //
//      11 END;                                                                                      //
//      12 BEGIN (∗ Hauptprogramm ∗)                                                                 //
//      13 ? a;                                     // Lese a                                        //
//      14 ? b;                                     // Lese b                                        //
//      15 CALL ggt;                                // Aufruf ggt                                    //
//      16 ! g ;                                    // Ausgabe g                                     //
//      17 END.                                                                                      //
//                                                                                                   //
//---------------------------------------------------------------------------------------------------//

//Include C++ standard libraries
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
//Include Lex-Scanner
#include "lex.yy.h"  
#include "y.tab.h"

//Include intermediate code classes
#include "IntermediateCode.h"

//Include Symboltable (Variables and prodecures)
#include "pl0-symtab.hpp"

//Include assembler generation
#include "AssemblerCodegenerator.h"

//Include Debugger Class
#include "DebugConsole.h"
    
using namespace std;

//Prototypes required by Lex/Yacc
int yyparse();
int yylex();
int yyerror(char const* s);

//Prototypes implemented at the end of the file
IdentifierNode* insertVariable(int & result, char variableIdentifier[], IdentifierNode* nextIdentifier);
IdentifierNode* insertConstant(int & result, char constantIdentifier[], int value, IdentifierNode* nextIdentifier);
void prepareInsertProcedure(int & result, char procedureIdentifier[]);
BlockNode* insertProcedure(int & result, char procedureIdentifier[], BlockNode* blockOfProcedure);

ExpressionNode* resolveIdentifier(int & result, char identifier[]);
ExpressionNode * resolveVariable(char identifier[], int level, int offset, int & result);
ExpressionNode* resolveConstant(char identifier[], int level, int offset);

//Symbol table to manage variables, constants and procedures
symtab* symbolTable = new symtab();

//Global counters required by the parser
int global_ProcedureCounter = 0;
int global_VariableCounter = -1;
int global_JumpCounter = 1;

//Console used to debug
DebugConsole* debugConsole = new DebugConsole();


//---------------------------------------------------------------------------------------------------//
//                                  Schnittstelle LEX-Scanner                                        //
//---------------------------------------------------------------------------------------------------//


//---------------------------------------------------------------------------------------------------//
//                                           UNION                                                   //
//---------------------------------------------------------------------------------------------------//
//  Für ein Token kann es ein Ergebnis geben, welches im Parser verarbeitet werden muss.             //
//  Die Ergebnisse für verschiedene Token haben dabei verschiedene Datentypen,                       //
//  welche übergeben werden müssen.                                                                  //
//                                                                                                   //
//  Daher muss im folgenden der "union" Datentyp definiert werden,                                   //
//  welcher es ermöglicht z.B. für das gefundene Token IDENTIFIER den Wert zu übermitteln.           //
//  Die Yacc-Directve ist dafür "%union", die in der LEX-Datei mittels der globalen Variablen        //
//  "yylval" referenziert wird.                                                                      //
//                                                                                                   //
//                                                                                                   //
//  Anmerkung zu Unions:                                                                             // 
//  Ein union ist ein Datentyp mit mehreren Namen und Datentypen für die selbe Variable.             //
//                                                                                                   //
//  union number { int numInt; float numFloat; }                                                     //
//  union number myNumber;                                                                           //
//  myNumber.numInt = 5;       >> numInt: 5,   numFloat: xxx                                         //
//  myNumber.numFloat = 1.2345 >> numInt: xxx, numFloat: 1.2345                                      //
//---------------------------------------------------------------------------------------------------//


%}

%union 
{ 
	int NUMBER_VALUE;                   //Additional value for T_NUMBER Token
	char IDENTIFIER_VALUE[256];         //Additional value for T_IDENTIFIER Token


	BlockNode* BLOCK_NODE;               
	StatementNode* STATEMENT_NODE; 
	ExpressionNode* EXPRESSION_NODE;
	IdentifierNode* IDENTIFIER_NODE;
	struct { StatementNode* from; StatementNode* to; } FROM_TO_NODE;
}


//---------------------------------------------------------------------------------------------------//
//                                           TOKENS                                                  //
//---------------------------------------------------------------------------------------------------//
//  Alle Tokens, welche vom LEX-Scanner gefunden werden                                              //
//---------------------------------------------------------------------------------------------------//
%token <NUMBER_VALUE>       T_NUMBER
%token <IDENTIFIER_VALUE>   T_IDENTIFIER



%token T_CONST        /* CONST */     T_VAR              /*    VAR    */           
%token T_COMMA        /*   ,   */     T_SEMICOLON        /*     ;     */
%token T_ASSIGN       /*  :=   */     T_POINT            /*     .     */

%token T_PLUS         /*   +   */     T_MINUS            /*     -     */            
%token T_MULT         /*   *   */     T_DIV              /*     /     */

%token T_EQUAL        /*   =   */     T_NOT_EQUAL        /*     #     */         
%token T_LESS         /*   <   */     T_LESS_OR_EQUAL    /*     <=    */ 
%token T_GREATER       /*   >   */     T_GREATER_OR_EQUAL /*     >=    */
%token T_ODD          /*  ODD  */

%token T_OPEN_BRACKET /*   (   */     T_CLOSE_BRACKET    /*     )     */

%token T_READ         /*   ?   */     T_WRITE            /*     !     */

%token T_CALL         /* CALL  */     T_PROCEDURE        /* PROCEDURE */
%token T_IF           /* IF    */     T_THEN             /* THEN      */          
%token T_WHILE        /* WHILE */     T_DO               /* DO        */
%token T_BEGIN        /* BEGIN */     T_END              /* END       */            

//---------------------------------------------------------------------------------------------------//
//                                   Datentypen für Grammtik                                         //
//---------------------------------------------------------------------------------------------------//
//  Definition, welcher Ausdruck, welchen Datentyp zurückgibt                                        //
//---------------------------------------------------------------------------------------------------//

%type <BLOCK_NODE> Block Repetition_Procedure_Definition Procedure_Definition
%type <IDENTIFIER_NODE> Optional_Const_Definition Repetition_Multiple_Const_Defintion Repetition_Multiple_Var_Defintion Optional_Var_Definition
%type <EXPRESSION_NODE> Factor Expression Condition Term
%type <FROM_TO_NODE> Repetition_Statement Statement



//---------------------------------------------------------------------------------------------------//
//                                      PL-0 Grammatik                                               //
//---------------------------------------------------------------------------------------------------//
//      program     ::= block "."                                                                    //
//                                                                                                   //
//      block       ::= [ "CONST" ident "=" number {"," ident "=" number} ";"]                       //
//                      [ "VAR" ident {"," ident} ";"]                                               //
//                      { "PROCEDURE" ident ";" block ";" } statement                                //
//                                                                                                   //
//      statement   ::= [   ident ":=" expression                                                    //
//                          | "CALL" ident                                                           //
//                          | "?" ident                                                              //
//                          | "!" expression                                                         //
//                          | "BEGIN" statement {";" statement } "END"                               //
//                          | "IF" condition "THEN" statement                                        //
//                          | "WHILE" condition "DO" statement                                       //
//                      ]                                                                            //
//                                                                                                   //
//      condition   ::= "ODD" expression                                                             //
//                      | expression ("="|"#"|"<"|"<="|">"|">=") expression                          //
//                                                                                                   //
//      expression  ::= [ "+"|"-"] term { ("+"|"-") term}                                            //
//                                                                                                   //
//      term        ::= factor {("*"|"/") factor}                                                    //
//                                                                                                   //
//      factor      ::= ident | number | "(" expression ")"                                          //
//                                                                                                   //
//---------------------------------------------------------------------------------------------------//
//                            Erweiterte Backus Naur Form (EBNF)                                     //
//---------------------------------------------------------------------------------------------------//
//  EBNF Syntax:                                                                                     //
//      [...]           Optional, 1 oder 0 mal                                                       //
//      |               Alternative                                                                  //
//      {...}           Wiederholung, 0 bis N mal                                                    //
//      "xxx"           Konstante                                                                    //
//      (aaa|bbb|ccc)   aaa oder bbb oder ccc                                                        //
//                                                                                                   //
//---------------------------------------------------------------------------------------------------//


%%

//---------------------------------------------------------------------------------------------------//
//      program     ::= block "."                                                                    //
//---------------------------------------------------------------------------------------------------//

Program:                Block T_POINT 
                        { 
                            debugConsole->startGrammar("Program");

                            // Add Main-Procedure
                            DataModel::getInstance()->procedures.push_back($1); 
                            DataModel::getInstance()->mainProcedure = $1; 
                            $1->identifier = "main"; 

                            //prepare generation of assembler code
                            DataModel::getInstance()->prepareAssemberGeneration();       

                            debugConsole->endGrammar("Program");                                                    
                        }
                        ;

//---------------------------------------------------------------------------------------------------//
//      block       ::= [ "CONST" ident "=" number {"," ident "=" number} ";"]                       //
//                      [ "VAR" ident {"," ident} ";"]                                               //
//                      { "PROCEDURE" ident ";" block ";" } statement                                //
//---------------------------------------------------------------------------------------------------//
Block:                  { 
                            symbolTable->level_up(); 
                        } 
                        Optional_Const_Definition Optional_Var_Definition Repetition_Procedure_Definition Statement        
                        { 
                            debugConsole->startGrammar("Block");
                                            
                            $$ = new BlockNode("", $5.from, $2, $3);
                            symbolTable->level_down();
                            
                            debugConsole->startGrammar("Block");
                        }
                        ;

 // [ "CONST" ident "=" number {"," ident "=" number} ";"]


//---------------------------------------------------------------------------------------------------//
//      block       ::= [ "CONST" ident "=" number {"," ident "=" number} ";"]                       //
//                      ...                                                                          //
//                      ...                                                                          //
//                                                                                                   //
//      block       ::= [ "CONST" ident "=" number Repetition_Multiple_Const_Defintion ";"]          //
//---------------------------------------------------------------------------------------------------//
Optional_Const_Definition: T_CONST T_IDENTIFIER T_EQUAL T_NUMBER Repetition_Multiple_Const_Defintion T_SEMICOLON                              
                        {  
                            debugConsole->startGrammar("Optional_Const_Definition");

                            int result;                                        // identifier // value // next constant
                            IdentifierNode* newConstant = insertConstant(result, $2, $4, $5);

                            if(result != 0) return result;

                            $$ = newConstant;


                            debugConsole->endGrammar("Optional_Const_Definition");
                        }
                        | /*epsilon*/                                               
                        { 
                            debugConsole->startGrammar("Optional_Const_Definition", "Epsilon");
                            
                            //Nothing to do, no constants
                            $$ = nullptr; 

                            debugConsole->endGrammar("Optional_Const_Definition", "Epsilon");
                        }
                        ;

//---------------------------------------------------------------------------------------------------//
//      Repetition_Multiple_Const_Defintion:=       ... {"," ident "=" number} ...                   //
//---------------------------------------------------------------------------------------------------//
Repetition_Multiple_Const_Defintion: T_COMMA T_IDENTIFIER T_EQUAL T_NUMBER Repetition_Multiple_Const_Defintion           
                        { 
                            debugConsole->startGrammar("Repetition_Multiple_Const_Defintion", "Multiple Assignment");
 
                            int result;                                        // identifier // value // next constant
                            IdentifierNode* newConstant = insertConstant(result, $2, $4, $5);

                            if(result != 0) return result;

                            $$ = newConstant;
              
                            debugConsole->endGrammar("Repetition_Multiple_Const_Defintion", "Multiple Assignment");
                        }
                        | /* epsilon */
                        { 
                            debugConsole->startGrammar("Repetition_Multiple_Const_Defintion", "Epsilon");
                            
                            //Nothing to do, Last Identifier -- next --> nullptr
                            $$ = nullptr; 

                            debugConsole->endGrammar("Repetition_Multiple_Const_Defintion", "Epsilon");
                        }
                        ;


//---------------------------------------------------------------------------------------------------//
//      block       ::= ...                                                                          //
//                      [ "VAR" ident {"," ident} ";"]                                               //
//                      ...                                                                          //
//                                                                                                   //
//      block       ::= [ "VAR" ident Repetition_Multiple_Var_Defintion ";"]                         //
//---------------------------------------------------------------------------------------------------//
Optional_Var_Definition: T_VAR T_IDENTIFIER Repetition_Multiple_Var_Defintion T_SEMICOLON                                  
                        {  
                            debugConsole->startGrammar("Optional_Var_Definition");


                            int result;
                            IdentifierNode* newVariable = insertVariable(result, $2, $3);

                            if(result != 0) return result;

                            $$ = newVariable;

                            debugConsole->endGrammar("Optional_Var_Definition");
                        }
                        | /*epsilon*/                                               
                        {
                            debugConsole->startGrammar("Optional_Var_Definition", "Epsilon");

                            //Nothing to do, no variables
                            $$ = nullptr;

                            debugConsole->endGrammar("Optional_Var_Definition", "Epsilon");
                        }
                        ;

//---------------------------------------------------------------------------------------------------//
//      Repetition_Multiple_Var_Defintion:=     ...{"," ident}...                                    //
//---------------------------------------------------------------------------------------------------//
Repetition_Multiple_Var_Defintion: T_COMMA T_IDENTIFIER Repetition_Multiple_Var_Defintion                                
                        { 
                            debugConsole->startGrammar("Repetition_Multiple_Var_Defintion", "Multiple Assignment");
                            
                            int result;
                            IdentifierNode* newVariable = insertVariable(result, $2, $3);

                            if(result != 0) return result;

                            $$ = newVariable;

                            debugConsole->endGrammar("Repetition_Multiple_Var_Defintion", "Multiple Assignment");
                        }
                        | /*epsilon*/                                               
                        {
                            debugConsole->startGrammar("Repetition_Multiple_Var_Defintion", "Epsilon");
                            
                            //Nothing to do, Last Identifier -- next --> nullptr
                            $$ = nullptr;

                            debugConsole->endGrammar("Repetition_Multiple_Var_Defintion", "Epsilon");
                        }
                        ;

//---------------------------------------------------------------------------------------------------//
//      block       ::= ...                                                                          //
//                      ...                                                                          //
//                      { "PROCEDURE" ident ";" block ";" } ...                                      //
//---------------------------------------------------------------------------------------------------//


//---------------------------------------------------------------------------------------------------//
//      Repetition_Procedure_Definition       ::= { Procedure_Definition }                           //
//                                                                                                   //
//      Procedure_Definition ::= "PROCEDURE" ident ";" block ";"                                     //
//---------------------------------------------------------------------------------------------------//
Repetition_Procedure_Definition: Procedure_Definition Repetition_Procedure_Definition                        
                        {  
                            debugConsole->startGrammar("Repetition_Procedure_Definition");

                            $$ = $1; 
                            DataModel::getInstance()->procedures.push_back($$); 

                            debugConsole->endGrammar("Repetition_Procedure_Definition");
                        }
                        | /*epsilon*/                                               
                        {  
                            debugConsole->startGrammar("Repetition_Procedure_Definition", "Epsilon");
                             
                            $$ = nullptr; 

                            debugConsole->endGrammar("Repetition_Procedure_Definition", "Espilon");
                        }
                        ;

//---------------------------------------------------------------------------------------------------//
//      Procedure_Definition ::= "PROCEDURE" ident ";" block ";"                                     //
//---------------------------------------------------------------------------------------------------//
Procedure_Definition: T_PROCEDURE T_IDENTIFIER
                        { 
                            debugConsole->startGrammar("Procedure_Definition", "Identifier");

                            //We insert here the correct name of the procedure, to avoid duplicate procedures on the same level

                            int result;
                            prepareInsertProcedure(result, $2);

                            if(result != 0) return result;

                            debugConsole->endGrammar("Procedure_Definition", "Identifier");

                        }
                        T_SEMICOLON Block T_SEMICOLON
                        {
                            debugConsole->startGrammar("Procedure_Definition", "Block");

                            //We manipulate the identifier by appending a global procedure counter
                            //This is required to have multiple procedures on different levels

                            int res;
                            BlockNode* blockOfProcedure = insertProcedure(res, $2, $5);

                            $$ = blockOfProcedure;

                            debugConsole->endGrammar("Procedure_Definition", "Block");                            
                        }
                        ;

//---------------------------------------------------------------------------------------------------//
//      statement   ::= [   ident ":=" expression                                                    //
//                          | "CALL" ident                                                           //
//                          | "?" ident                                                              //
//                          | "!" expression                                                         //
//                          | "BEGIN" statement {";" statement } "END"                               //
//                          | "IF" condition "THEN" statement                                        //
//                          | "WHILE" condition "DO" statement                                       //
//                      ]                                                                            //
//                                                                                                   //
//---------------------------------------------------------------------------------------------------//
Statement:              T_IF Condition T_THEN Statement
                        {
                            debugConsole->startGrammar("If_Then");

                            // Return
                            //  From = IF
                            //  To   = END IF

                            // |-------------------------------------------------------------------|    Jump Counter
                            // |                                                                   |    To create assembler code also Jump Reference 
                            // IF -> Some Statement -> Some Statement -> ... -> Some Statement END IF (NOP)
                            // Expression

                            StatementNode* ifStatement = new StatementNode(AssemblerCodegenerator::JUMP_FALSE, global_JumpCounter);
                            
                            ExpressionNode* condition = $2;
                            ifStatement->expressionNode = condition;
                            
                            // If Statement -> Some Statement -> Some Statement -> ....
                            ifStatement->next = $4.from;

                            StatementNode* endIfStatement = new StatementNode(AssemblerCodegenerator::NOP, global_JumpCounter);
                            
                            //Reference to create assembler code
                            ifStatement->nextStatementChain = endIfStatement;
                            
                            global_JumpCounter++;

                            $$.from = ifStatement;
                            $$.to = endIfStatement;
                            
                            debugConsole->endGrammar("If_Then");
                        }
                        ;
                        | T_WHILE Condition T_DO Statement                            
                        {
                            debugConsole->startGrammar("While_Do");

                            // Return FROM: NOP_START
                            //       TO:   NOP_END

                            //  |-------------------------Jump Back------------------------------------------------|    Jump Counter = x 
                            //  |                                                                                  |    
                            // NOP_START -> WHILE_START (JUMP_F) -> Some Statmeent -> ... -> Some Statement     WHILE_END (Jump) -> NOP_END
                            //                |                                                                                       |    To create assembler code also Jump Reference 
                            //                |-----------Jump Front------------------------------------------------------------------|    Jump Counter = x + 1
                            //              Expression


                            int currentCounter = global_JumpCounter;
                            global_JumpCounter++;
                            global_JumpCounter++;

                            StatementNode* nopStartNode = new StatementNode(AssemblerCodegenerator::NOP, currentCounter);
                            StatementNode* whileStartNode = new StatementNode(AssemblerCodegenerator::JUMP_FALSE, currentCounter + 1);

                            StatementNode* whileEndNode = new StatementNode(AssemblerCodegenerator::JUMP, currentCounter);
                            StatementNode* nopEndNode = new StatementNode(AssemblerCodegenerator::NOP, currentCounter + 1);

                            //NOP_START -> WHILE_START
                            nopStartNode->next = whileStartNode;

                            //WHILE_START -> Condition (Expression)
                            ExpressionNode * condition = $2;
                            whileStartNode->expressionNode = condition;

                            //WHILE_START -- jump reference to create assembler conde --> WHILE_END
                            whileStartNode->nextStatementChain = whileEndNode;
                            
                            //WHILE_START -> Next Statement
                            whileStartNode->next = $4.from;

                            whileEndNode->next = nopEndNode;

                            $$.from = nopStartNode;
                            $$.to = nopEndNode;

                            debugConsole->endGrammar("While_Do");
                        }
                        | T_IDENTIFIER T_ASSIGN Expression                                 
                        { 
                            debugConsole->startGrammar("Assign");

                            int level;
                            int offset;
                            int result = symbolTable->lookup($1, st_var, level, offset);
                            if(result != 0)
						    {
								printf("Error at assignment with identifier: %s\n", $1);
								return result;
							}
                            StatementNode* assignmentNode = new StatementNode(AssemblerCodegenerator::ASSIGN, $1); 
                            assignmentNode->level = level;
                            assignmentNode->offset = offset;
                            assignmentNode->expressionNode = $3; 

                            $$.from = assignmentNode;
                            $$.to = assignmentNode;

                            debugConsole->endGrammar("Assign");
                        }
                        | T_BEGIN Repetition_Statement T_END
                        {
                            debugConsole->startGrammar("Statement", "BEGIN_END");

                            //Nothing to do, handled by Repetition_Statement
                            $$ = $2; 

                            debugConsole->endGrammar("Statement", "BEGIN_END");
                        }
                        | T_CALL T_IDENTIFIER                                              
                        { 
                            debugConsole->startGrammar("Call");

                            int level;
                            int offset;
						    int result = symbolTable->lookup($2, st_proc, level, offset);
						    if(result != 0)
							{
						        printf("Error at CALL with identifier: %s\n", $2);
							    return result;
							}

                            StatementNode* callNode = new StatementNode(AssemblerCodegenerator::CALL, $2+std::to_string(offset)); 
                            callNode->level = level;
                            callNode->offset = offset;

                            $$.from = callNode;
                            $$.to = callNode;

                            debugConsole->endGrammar("Call");
                        }
                        | T_READ T_IDENTIFIER                                      
                        { 
                            debugConsole->startGrammar("Read");
                            
                            int level;
                            int offset;
							int result = symbolTable->lookup($2, st_var, level, offset);
						    if(result != 0)
						    {
								printf("Error at READ with identifier: %s\n", $2);
								return result;
							}
                            StatementNode* readNode = new StatementNode(AssemblerCodegenerator::READ, $2); 
                            readNode->level = level;
                            readNode->offset = offset;

                            $$.from = readNode;
                            $$.to = readNode;
            
                            debugConsole->endGrammar("Read");
                        }
                        | T_WRITE Expression                                
                        { 
                            debugConsole->startGrammar("Write");
                            
                            ExpressionNode* expression = $2;
                            
                            StatementNode* writeNode = new StatementNode(AssemblerCodegenerator::WRITE, expression->identifier);
                            writeNode->expressionNode = expression; 
                            
                            $$.from = writeNode;
                            $$.to = writeNode;

                            debugConsole->endGrammar("Write");
                        }
                        | /*epsilon*/
                        {
                            debugConsole->startGrammar("Statement", "Epsilon");
                            
                            //Nothing to do
                            $$.from = $$.to = nullptr;

                            debugConsole->endGrammar("Statement", "Epsilon");
                        }
                        ;
//---------------------------------------------------------------------------------------------------//
//      Repetition_Statement   ::=   "BEGIN" statement {";" statement } "END"                        //
//                                                                                                   //
//---------------------------------------------------------------------------------------------------//
Repetition_Statement:   Statement                                                   
                        { 
                            debugConsole->startGrammar("Repetition_Statement", "Single Statement");

                            $$ = $1;

                            debugConsole->endGrammar("Repetition_Statement", "Single Statement");
                        }
                        | Statement T_SEMICOLON Repetition_Statement                       
                        {
                            debugConsole->startGrammar("Repetition_Statement");

                            //Both are empty return nullptr
                            if( $1.from == nullptr && $1.to == nullptr && 
                                $3.from == nullptr && $3.to == nullptr )
                            {
                                $$ = $1;
                            }
                            //statment is empty -> return statementlist
                            else if($1.from == nullptr && $1.to == nullptr)
                            {
                                $$ = $3;
                            }
                            //statementlist is empty -> return statement
                            else if($3.from == nullptr && $3.to == nullptr)
                            {
                                $$ = $1;
                            }
                            //statment is not empty and statementlist is also not empty
                            //Link statment-> statementlist
                            //Statment.to == statementlist.from
                            //Return From = statmenet.from, To = Statementlist.to
                            else {
                                $$ = $1;
                                $$.to->next = $3.from;
                                $$.to = $3.to;
                            }
                            
                            debugConsole->endGrammar("Repetition_Statement");
                        }
                        ;

//---------------------------------------------------------------------------------------------------//
//      condition   ::= "ODD" expression                                                             //
//                      | expression ("="|"#"|"<"|"<="|">"|">=") expression                          //
//---------------------------------------------------------------------------------------------------//
Condition:              T_ODD Expression
                        { 
                            $$ = new ExpressionNode(AssemblerCodegenerator::ODD, $2, nullptr); 
                        }
                        | Expression T_EQUAL Expression
                        { 
                            $$ = new ExpressionNode(AssemblerCodegenerator::EQUAL, $1, $3); 
                        }
                        | Expression T_NOT_EQUAL Expression
                        { 
                            $$ = new ExpressionNode(AssemblerCodegenerator::NOT_EQUAL, $1, $3); 
                        } 
                        | Expression T_LESS Expression
                        { 
                            $$ = new ExpressionNode(AssemblerCodegenerator::LESS, $1, $3);  
                        }
                        | Expression T_LESS_OR_EQUAL Expression
                        { 
                            $$ = new ExpressionNode(AssemblerCodegenerator::LESS_OR_EQUAL, $1, $3); 
                        }
                        | Expression T_GREATER Expression
                        { 
                            $$ = new ExpressionNode(AssemblerCodegenerator::GREATER, $1, $3);  
                        }
                        | Expression T_GREATER_OR_EQUAL Expression
                        { 
                            $$ = new ExpressionNode(AssemblerCodegenerator::GREATER_OR_EQUAL, $1, $3); 
                        }
                        ;

//---------------------------------------------------------------------------------------------------//
//      ORIGINALE GRAMMATIK                                                                          //
//                                                                                                   //
//      expression  ::= [ "+"|"-"] term { ("+"|"-") term}                                            //
//                                                                                                   //
//      term        ::= factor {("*"|"/") factor}                                                    //
//                                                                                                   //
//      factor      ::= ident | number | "(" expression ")"                                          //
//                                                                                                   //
//---------------------------------------------------------------------------------------------------//


//---------------------------------------------------------------------------------------------------//
// Veraendert wie in der Vorlesung vorgestellt                                                       //
// Siehe S. 126 Compilerbau bzw. S. 254 Compilerbau_Folien                                           //
//                                                                                                   //
//      expression  ::= term   | expression t_plus term | expression t_minus term                    //
//                                                                                                   //
//      term        ::= factor | term t_mal factor  | term t_div factor                              //
//                                                                                                   //
//      factor      ::= t_zahl | t_kla_auf expression t_ka_zu  | t_minus factor | t_plus factor      //
//                                                                                                   //
//---------------------------------------------------------------------------------------------------//
Expression:             Term
                        { 
                            debugConsole->startGrammar("Expression", "Term");

                            //Nothing to do
                            $$ = $1;

                            debugConsole->endGrammar("Expression", "Term");
                        }
                        | Expression T_PLUS Term            
                        { 
                            debugConsole->startGrammar("Expression", "Plus");

                            $$ = new ExpressionNode(AssemblerCodegenerator::PLUS, $1, $3); 

                            debugConsole->endGrammar("Expression", "Plus");
                        }
                        | Expression T_MINUS Term
                        { 
                            debugConsole->startGrammar("Expression", "Minus");

                            $$ = new ExpressionNode(AssemblerCodegenerator::MINUS, $1, $3); 

                            debugConsole->endGrammar("Expression", "Minus");
                        }
                        ;


Term:                   Factor                                                      
                        { 
                            debugConsole->startGrammar("Term");

                            $$ = $1; 

                            debugConsole->endGrammar("Term");
                        }
                        | Term T_MULT Factor                                         
                        { 
                            debugConsole->startGrammar("Term", "Mult");

                            $$ = new ExpressionNode(AssemblerCodegenerator::MULT, $1, $3); 

                            debugConsole->endGrammar("Term", "Mult");
                        }
                        | Term T_DIV Factor                                         
                        {   
                            debugConsole->startGrammar("Term", "Div");

                            $$ = new ExpressionNode(AssemblerCodegenerator::DIV, $1, $3); 

                            debugConsole->endGrammar("Term", "Div");
                        }
                        ;


Factor:                 T_IDENTIFIER                                                     
                        { 
                            debugConsole->startGrammar("Factor", "Identifier");

                            int result;
                            ExpressionNode* identifier = resolveIdentifier(result, $1);
                            
                            if(result != 0) return result;

                            $$ = identifier;

                            debugConsole->endGrammar("Factor", "Identifier");
                        }
                        | T_NUMBER                                                  
                        { 
                            debugConsole->startGrammar("Factor", "Number");

                            $$ = new ExpressionNode(std::to_string($1), AssemblerCodegenerator::NUMBER, nullptr, nullptr); 

                            debugConsole->endGrammar("Factor", "Number");
                        }
                        | T_OPEN_BRACKET Expression T_CLOSE_BRACKET                             
                        { 
                            debugConsole->startGrammar("Factor", "( )");

                            //Nothing to do
                            $$ = $2;

                            debugConsole->endGrammar("Factor", "( )");
                        }
                        | T_PLUS Factor                                            
                        { 
                            debugConsole->startGrammar("Factor", "Plus");

                            //Nothing to do
                            $$ = $2; 

                            debugConsole->endGrammar("Factor", "Plus");
                        }
                        | T_MINUS Factor                                            
                        { 
                            debugConsole->startGrammar("Factor", "Minus");

                            //Change sign of underlying expression
                            $$ = new ExpressionNode(AssemblerCodegenerator::CHANGESIGN, nullptr, $2); 

                            debugConsole->endGrammar("Factor", "Minus");
                        }
                        ;
%%

IdentifierNode* insertVariable(int & result, char variableIdentifier[], IdentifierNode* nextIdentifier)
{
    global_VariableCounter += 1;
    result = symbolTable->insert(variableIdentifier, st_var, global_VariableCounter); 

    if(result != 0){
		printf("Error at inserting variable with identifier: %s\n", variableIdentifier);
	}

    IdentifierNode * newIdentifier = new IdentifierNode(variableIdentifier);  
    newIdentifier->next = nextIdentifier;
    
    return newIdentifier;
}

IdentifierNode* insertConstant(int & result, char constantIdentifier[], int value, IdentifierNode* nextIdentifier)
{

    result = symbolTable->insert(constantIdentifier, st_const, value); 

    if(result != 0){
		printf("Error at inserting constant with identifier: %s\n", constantIdentifier);
	}

    IdentifierNode * newIdentifier = new IdentifierNode(constantIdentifier);  
    newIdentifier->value = value;
    newIdentifier->next = nextIdentifier;
    
    return newIdentifier;
}


void prepareInsertProcedure(int & result, char procedureIdentifier[])
{

    result = symbolTable->insert(procedureIdentifier, st_proc, ++global_ProcedureCounter);
    if(result != 0)
	{
		printf("Error at inserting procedure with identifier %s\n", procedureIdentifier);
	}
    //Reset variable counter for each procedure
    global_VariableCounter = -1;
};

BlockNode* insertProcedure(int & result, char procedureIdentifier[], BlockNode* blockOfProcedure)
{

    int level;
    int offset;

    result = symbolTable->lookup(procedureIdentifier, st_proc, level, offset);

    blockOfProcedure->identifier = std::string(procedureIdentifier)+std::to_string(offset);

    return blockOfProcedure;
};

ExpressionNode* resolveIdentifier(int & result, char identifier[])
{

    int level;
    int offset;

    result = symbolTable->lookup(identifier, st_const, level, offset);
	if(result != 0)
	{
        ExpressionNode* variable = resolveVariable(identifier, level, offset, result);
        if(result != 0){
            printf("Error in factor with identifier:  %s\n", identifier);
            return nullptr;
        }
        return variable;
	}
    else 
    {
        ExpressionNode* constant = resolveConstant(identifier, level, offset);
        return constant;
    }

}

ExpressionNode* resolveVariable(char identifier[], int level, int offset, int & result){
    	result = symbolTable->lookup(identifier, st_var, level, offset);
        if(result != 0)
		{
            return nullptr;
		}
        else
        {
            ExpressionNode* variable = new ExpressionNode(identifier, AssemblerCodegenerator::VAR, nullptr, nullptr);
            variable->level = level;
            variable->offset = offset;

            return variable;
        }
}

ExpressionNode* resolveConstant(char identifier[], int level, int offset){
        ExpressionNode* constant = new ExpressionNode(identifier, AssemblerCodegenerator::CONST, nullptr, nullptr);
        constant->value = offset; //In case of a constant, the "offset" is the value
        constant->level = level;
        constant->offset = offset;

        return constant;
}

int yyerror(char const* s) 
{
	printf("%s\n", s);
	return 1;
}


int startParse(int argc, char* argv[])
{
    //extern FILE * yyin;
	if (argc < 2)
	{
		std::cout << "Not enough arguments" << std::endl;
		return 1;
	}

	FILE* file;
	std::string toOpen = std::string(argv[1]) + ".pl0";
	file = fopen(toOpen.c_str(), "r+");

	if (!file)
	{
		std::cout << toOpen << " can not be opend" << std::endl;
		return 1;
	}

	yyin = file;

	
    //debugConsole->printGrammar();
    
	if (yyparse() == 0)
	{

		std::string outputFileName = std::string(argv[1]) + ".asm";

    	FILE* outputFile = fopen((outputFileName).c_str(), "w");

		AssemblerCodegenerator::getInstance()->setFile(outputFile);

		DataModel::getInstance()->generateAssember(); 
        fclose(outputFile);
		return 0;
	}
	else
	{
		return 1;
	}
}

