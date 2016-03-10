%{
	#include <stdio.h>
	#include <stdlib.h>
	#define INDENT (4)
	#define MAXSYMBOLS 200

	int line = 1;
	int column = 4;
	int paren = 0;
	struct entry
	{
		char *lexptr;
		int token;
	};

	struct entry symtable[MAXSYMBOLS];
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

auto|break|case|char|const|continue|default|do|double|else|enum|extern				{write_keyword();}
float|for|goto|if|int|long|register|return|short|signed|sizeof|static				{write_keyword();}
struct|switch|typedef|union|unsigned|void|volatile|while|NULL|malloc|main			{write_keyword();}
{ditto}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{quote})*{ditto}	{write_string();}
{quote}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{ditto}){quote}	{write_char();}
0[0-7]+																				{write_oct();}
0(x|X){hex}+																		{write_hex();}	
{digit}+																			{write_int();}
{digit}*\.{digit}*({exp}|\ )														{write_fp();}
{alpha}({alpha}|{digit})*															{write_id();}
[{]																					{write_begin();}
[}]																					{write_end();}
[(]																					{write_open();}
[)]																					{write_close();}
[\[]																				{write_bopen();}
[\]]																				{write_bclose();}
[;]																					{write_sep();}
\+|\-|\*|\/|%|\+\+|\-\-																{write_op();}
\<|\>|<=|>=|==|!=																	{write_op();}
&&|\|\||!																			{write_op();}
&|\||\^|~|\<\<|\>\>																	{write_op();}
=|\+=|\-=|\*=|\/=|%=|\<\<=|\>\>=|&=|\^=|\|=											{write_op();}
\/\/[^\n]*																			{write_inline();}
\/\*																				{write_comment();}
#[^\n]*																				{write_directive();}
[\t\v\n\r\f]																		{}

%%

indent() 
{ 
	printf("\n%-*d", column, line++); 
}

write_html_char(int c)
{ 
	switch (c)
	{ 
		case '<': 	printf("&lt;"); 
					break;
		case '>': 	printf("&gt;"); 
					break;
		case '"': 	printf("&quot;"); 
					break;
		case '&': 	printf("&amp;"); 
					break;
		default: 	putchar(c);
	}
}

write_html() 
{ 
	char *s = yytext;
	while (*s)
	{
		write_html_char(*s++);
	}
}

write_keyword()
{
	printf("<font color='#0000FF'><b>");
	write_html();
	printf("</b></font>");
}

write_string()
{
	printf("<font color='#FF0000'>");
	write_html();
	printf("</font>");
}

write_char()
{
	printf("<font color='#00FFFF'><u>");
	write_html();
	printf("</u></font>");
}

write_oct()
{
	printf("<font color='#00FFFF'><i>");
	write_html();
	printf("</i></font>");
}

write_hex()
{
	printf("<font color='#00FFFF'><i>");
	write_html();
	printf("</i></font>");
}

write_int()
{
	printf("<font color='#00FFFF'><i>");
	write_html();
	printf("</i></font>");
}

write_fp()
{
	printf("<font color='#00FFFF'>");
	write_html();
	printf("</font>");
}

write_id()
{
	printf("<font color='#0000FF'>");
	write_html();
	printf("</font>");
}

write_begin()
{ 
	indent();
	write_html();
	column += INDENT;
	indent();
}

write_end()
{ 
	column -= INDENT;
	indent();
	write_html();
	indent();
}

write_open()
{ 
	write_html();
	putchar(' ');
	paren++; 
}

write_close()
{ 
	write_html();
	putchar(' ');
	paren--; 
}

write_bopen()
{
	write_html();
}

write_bclose()
{
	write_html();
}

write_sep()
{ 
	write_html();
	if (!paren)
	{
		indent();
	}
	else
	{
		putchar(' ');
	}
}

write_op()
{
	printf("<font color='#000000'><b>");
	write_html();
	printf("</b></font>");
}

write_inline()
{
	printf("<font color='#00FF00'>");
	write_html();
	printf("</font>");
	indent();
}

write_comment()
{
	char c, c1;
	printf("<font color='#00FF00'>/*");
	loop:
		while ((c = input()) != '*' && c != 0)
		{
			write_html_char(c);
		}
		write_html_char('*');
		if ((c1 = input()) != '/' && c != 0)
		{ 
			unput(c1);
			goto loop; 
		}
		if (c != 0)
		{
			write_html_char(c1);
		}
		printf("</font>");
		indent();
}

write_directive()
{
	printf("<font color='#FF00FF'><b>");
	write_html();
	printf("</b></font>");
	indent();
}

int main()
{
	printf("<html><pre>\n");
	indent();
	yylex();
	printf("\n</pre></html>\n");
	return 0;
}
