%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdint.h>
    #include <inttypes.h>
    #include "bison.tab.h"
    extern int yylex();
    void yyerror (char const *err)
    {
        fprintf (stderr, "Line %d: %s\n", yylineno, err);
    }
%}
%option noyywrap
%option case-insensitive
%option yylineno
DIGIT [0-9]
WHITESPACE [ \t\n\r]
ALPHABET [a-zA-Z0-9_\\\%:;,. ]
%%

LOAD                      {return INSTRUCTION_LOAD;                                                                       }
STORE                     {return INSTRUCTION_STORE;                                                                      }
ADD                       {return INSTRUCTION_ADD;                                                                        }
SUB                       {return INSTRUCTION_SUB;                                                                        }
MULT                      {return INSTRUCTION_MULT;                                                                       }
DIV                       {return INSTRUCTION_DIV;                                                                        }

INDLOAD                   {return INSTRUCTION_INDLOAD;                                                                    }
INDSTORE                  {return INSTRUCTION_INDSTORE;                                                                   }
INDADD                    {return INSTRUCTION_INDADD;                                                                     }
INDSUB                    {return INSTRUCTION_INDSUB;                                                                     }
INDMULT                   {return INSTRUCTION_INDMULT;                                                                    }
INDDIV                    {return INSTRUCTION_INDDIV;                                                                     }

CLOAD                     {return INSTRUCTION_CLOAD;                                                                      }
CADD                      {return INSTRUCTION_CADD;                                                                       }
CSUB                      {return INSTRUCTION_CSUB;                                                                       }
CMULT                     {return INSTRUCTION_CMULT;                                                                      }
CDIV                      {return INSTRUCTION_CDIV;                                                                       }

GOTO                      {return INSTRUCTION_GOTO;                                                                       }
IF                        {return INSTRUCTION_IF_GOTO;                                                                    }
END                       {return INSTRUCTION_END;                                                                        }
THEN                      {return THEN;                                                                                   }
\=                        {return EQ;                                                                                     }
\<\=                      {return LEQ;                                                                                    }
\>\=                      {return GEQ;                                                                                    }
\<                        {return LE;                                                                                     }
\>                        {return GE;                                                                                     }
\(                        { return BRACKET_LEFT;                                                                          }
\)                        { return BRACKET_RIGHT;                                                                         }
\n                        { return LINE_SEPARATOR;                                                                        }
{DIGIT}+                  { yylval.i = atoi(yytext); return INT;                                                          }
{WHITESPACE}              ;
.                         ;
%%