%option noyywrap
%{
	#include <stdio.h>
	#include <stdlib.h>
	#define INDENT (4)
	int line = 1;
	int column = 4;
	int paren = 0;
%}

quote	[']
ditto	["]
back	[\\]
digit	[0-9]
exp 	(e|E)(\+|\-|\ )({digit})+
hex 	{digit}|[a-f]|[A-F]
alpha 	[a-zA-Z]
ch 		[^'\n\\"]

%%

{ditto}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{quote})*{ditto}	{write_string();}
{quote}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{ditto}){quote}	{write_char();}
0[0-7]+																				{write_oct();}
0(x|X){hex}+																		{write_hex();}	
{digit}+																			{write_int();}
{digit}*.{digit}*({exp}|\ )															{write_fp();}
{alpha}({alpha}|{digit})*															{write_id();}
[{]																					{write_begin();}
[}]																					{write_end();}
[(]																					{write_open();}
[)]																					{write_close();}
[\[]																				{write_bopen();}
[\]]																				{write_bclose();}
[;]																					{write_sep();}
\<|\>|<=|>=|==|!=																	{write_op();}
\/\/[^\n]*[\n]																		{write_inline();}
\/\*																				{write_comment();}
#[^\n]*[\n]																			{write_directive();}
[\t\v\n\r\f]																		{}

%%

write_string()
{
	printf("str\n");
}

write_char()
{
	printf("char\n");
}

write_oct()
{
	printf("oct\n");
}

write_hex()
{
	printf("hex\n");
}

write_int()
{
	printf("int\n");
}

write_fp()
{
	printf("fp\n");
}

write_id()
{
	printf("id\n");
}

write_begin()
{
	printf("begin\n");
}

write_end()
{
	printf("end\n");
}

write_open()
{
	printf("open\n");
}

write_close()
{
	printf("close\n");
}

write_bopen()
{
	printf("bopen\n");
}

write_bclose()
{
	printf("bclose\n");
}

write_sep()
{
	printf("sep\n");
}

write_op()
{
	printf("op\n");
}

indent() 
{ 
	printf("\n%-*d", column, line++); 
}

write_inline()
{
	printf("inline\n");
}

write_comment()
{
	printf("comment\n");
}

write_directive()
{
	printf("directive\n");
}

int main()
{
	printf("<html><pre>\n");
	indent();
	yylex();
	printf("\n</pre></html>\n");
	return 0;
}