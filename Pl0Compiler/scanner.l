
%{
#include "IntermediateCode.h"
#include "y.tab.h"

// See options: https://stackoverflow.com/questions/39075510/option-noinput-nounput-what-are-they-for
// nounput, noinput for warnings
// caseless to accept keywords lower and higher case (and mixed)
%}


%option nounput
%option noinput
%option caseless

%%
"CONST"     return T_CONST;
"VAR"       return T_VAR;
","         return T_COMMA;
";"         return T_SEMICOLON;
":="        return T_ASSIGN;
"."         return T_POINT;


"+"         return T_PLUS;
"-"         return T_MINUS;
"*"         return T_MULT;
"/"         return T_DIV;


"="         return T_EQUAL;
"#"         return T_NOT_EQUAL;
"<="        return T_LESS_OR_EQUAL;
"<"         return T_LESS;
">="        return T_GREATER_OR_EQUAL; 
">"         return T_GREATER;
"ODD"       return T_ODD;


"("         return T_OPEN_BRACKET;
")"         return T_CLOSE_BRACKET;

"?"         return T_READ;
"!"         return T_WRITE;

"CALL"      return T_CALL;
"PROCEDURE" return T_PROCEDURE;
"IF"        return T_IF;
"THEN"      return T_THEN;
"WHILE"     return T_WHILE;
"DO"        return T_DO;
"BEGIN"     return T_BEGIN;
"END"       return T_END;

[0-9]+						{ 
                                yylval.NUMBER_VALUE = atoi(yytext); 
                                return T_NUMBER; 
                            }

[A-Za-z_][A-Za-z_0-9]*		{ 
                                strcpy(yylval.IDENTIFIER_VALUE, yytext);
                                return T_IDENTIFIER; 
                            }

[ \t\n\r\f]						;

%%

int yywrap()
{
	return 1;
}
