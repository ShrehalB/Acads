#include <iostream>
#include <cstdio>

using namespace std;

class LexAnalyzer
{
	public:
		
		int state;
		int flag;

		char *lexBegin, *fwd;

		LexAnalyzer()
		{
			state = 12;
			flag = 0;
		}

		void get_token(char* input)
		{
			char c;
			lexBegin = input;
			fwd = input;

			while(1 && flag==0)
			{
				switch(state)
				{
					case 12 : c = *fwd;
							if(c>='0' && c<='9')
							{
								state = 13;
							}
							else
							{
								fail();
								flag = 1;
							}
							fwd++;
							break;
					case 13 : c = *fwd;
							if(c>='0' && c<='9')
							{
								state = 13;
							}
							else if(c=='.')
							{
								state = 14;
							}
							else if(c=='E')
							{
								state = 16;
							}
							else
							{
								state = 20;
							}
							fwd++;
							break;
					case 14 : c = *fwd;
							if(c>='0' && c<='9')
							{
								state = 15;
							}
							else
							{
								fail();
								flag = 1;
							}
							fwd++;
							break;
					case 15 : c = *fwd;
							if(c>='0' && c<='9')
							{
								state = 15;
							}
							else if(c=='E')
							{
								state = 16;
							}
							else
							{
								state = 21;
							}
							fwd++;
							break;
					case 16 : c = *fwd;
							if(c>='0' && c<='9')
							{
								state = 18;
							}
							else if(c=='+' || c=='-')
							{
								state = 17;
							}
							else
							{
								fail();
								flag = 1;
							}
							fwd++;
							break;
					case 17 : c = *fwd;
							if(c>='0' && c<='9')
							{
								state = 18;
							}
							else
							{
								fail();
								flag = 1;
							}
							fwd++;
							break;
					case 18 : c = *fwd;
							if(c>='0' && c<='9')
							{
								state = 18;
							}
							else
							{
								state = 19;
							}
							fwd++;
							break;

					case 19 : cout<<"Exponent"<<endl;
							  flag = 1;
							  break;
					case 20 : cout<<"Simple Integer"<<endl;
							  flag = 1;
							  break;
					case 21 : cout<<"Real Number"<<endl;
							  flag = 1;
							  break;

					default : break;
				}
			}
		}

		void fail()
		{
			lexBegin = --fwd;
			cout<<"Not a Number"<<endl;
		}
};

int main()
{
	char input[20];
	LexAnalyzer* l = new LexAnalyzer();
	scanf("%s",input);
	l->get_token(input);
}