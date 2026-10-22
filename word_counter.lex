%{		//Section 1: Here goes the declaration and option settings
  int numLines=0,numWords=0;
%}

word	[^[:space:]]+	

%%		//Section 2: Here goes the rules
\n			{++numLines;}
{word}		{++numWords;}	
[[:space:]]	{}
%%

void main(){	//Here goes the C code that is copied to the actual scanner	
	yylex();
	printf("Lines: %d\n", numLines);
	printf("Words: %d\n", numWords);
}


