/*simplest version of calculator: from O'Reilly Media, Inc. 2021*/
%{  // Section 1a: C declarations
  #include<stdio.h>
  #include<stdlib.h>
  int yylex();
  void yyerror(char *s);
  double power_func(double base, int exp);
  
  // symbol table
  double variables[26];
%}

%union{
	double numval;
	char varval;
}

// Section 1b: YACC/Bison declarations
/*declare tokens*/
%token <numval> NUMBER
%token <varval> VARNAME
%type <numval> exp factor power term asgn
%token POW
%left ADD SUB
%left MUL DIV
%token EOL QUIT

%%  // Section 2: Grammar rules
calclist: /*nothing*/		//matches at beginning of input
  | calclist exp EOL 		{printf("=%f\n", $2); } //EOL is end of an expression
  | calclist asgn EOL
  | calclist QUIT 			{printf("Exitting..."); return 0;}
  ;

asgn: VARNAME '=' exp {
		variables[$1 - 'a'] = $3;
		printf("= %f (stored in %c)\n", $3, $1);
		$$ = $3;
	}
	| VARNAME '=' asgn {
		variables[$1 - 'a'] = $3;
		printf("= %f (stored in %c)\n", $3, $1);
		$$ = $3;
	}
	;

exp: factor 				//default $$ = $1
  | exp ADD factor 			{$$ = $1 + $3;}
  | exp SUB factor 			{$$ = $1 - $3;}
  ;

factor: power				//default $$ = $1
  | factor MUL power 		{$$ = $1 * $3;}
  | factor DIV power 		{$$ = $1 / $3;}
  ;

power: term
  | term POW power      {$$ = power_func($1, (int)$3);}
  ;

term: NUMBER 				//default $$ = $1
  | SUB term      {$$ = -$2;}
	| VARNAME 		{$$ = variables[$1 - 'a'];}
	| '(' exp ')' 		{$$ = $2;}
  ;
%%

// Section 3: Additional C code
double power_func(double base, int exp) {
  double result = 1.0;

  if (exp >= 0) { // if raised to 0 to positive number
    for (int i = 0; i < exp; i++) {
      result *= base; // multiply repeatedly to the current product (result)
    }
  } else { // if raised to a negative value
    for (int i = 0; i > exp; i--) {
      result *= base; // multiply repeatedly to the current product (result)
    }
    result = 1.0 / result; // since negative, divide final result with 1 as dividend
  }

  return result; // return computed result
}

void yyerror(char *s){
  fprintf(stderr, "error: %s\n", s);
}

int main(int argc, char **argv){
  yyparse();
}
