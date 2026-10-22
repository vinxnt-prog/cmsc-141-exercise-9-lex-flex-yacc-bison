%{
  #define YYSTYPE double
  #include "simple_calc.tab.h"
  #include <stdlib.h>
%}

NUM	-?([0-9]+(\.[0-9]*)?|\.[0-9]+)

%%
"+"			{return ADD;}
"-"			{return SUB;}
"/"			{return DIV;}
"*"			{return MUL;}
"("           		{ return '('; }
")"            		{ return ')'; }
{NUM}		{yylval = atof(yytext); return NUMBER;}
\n			{return EOL;}
[[:space:]]	{/*ignore white space*/}
"exit"		{return QUIT;}
.			{printf("\nUnrecognized string %c\n", *yytext);}
%%

