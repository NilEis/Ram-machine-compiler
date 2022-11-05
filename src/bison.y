%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdint.h>
    #include <inttypes.h>
    #include <ctype.h>
    #include <string.h>
    #include "definitions.h"
    #define YYDEBUG 1
    #define NUM_REGISTERS 32768
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    uint32_t exec_size = 0;
    uint16_t data_size = 0;
    uintmax_t registers[NUM_REGISTERS] = { 0 };
    FILE* out;
    void yyerror (char const *err);
%}

%define parse.error detailed

%union {
  uint16_t i;
};

%token <i> INT

%token INSTRUCTION_LOAD
%token INSTRUCTION_STORE
%token INSTRUCTION_ADD
%token INSTRUCTION_SUB
%token INSTRUCTION_MULT
%token INSTRUCTION_DIV

%token INSTRUCTION_INDLOAD
%token INSTRUCTION_INDSTORE
%token INSTRUCTION_INDADD
%token INSTRUCTION_INDSUB
%token INSTRUCTION_INDMULT
%token INSTRUCTION_INDDIV

%token INSTRUCTION_CLOAD
%token INSTRUCTION_CADD
%token INSTRUCTION_CSUB
%token INSTRUCTION_CMULT
%token INSTRUCTION_CDIV

%token INSTRUCTION_GOTO
%token INSTRUCTION_IF_GOTO
%token INSTRUCTION_END

%token EQ
%token LEQ
%token GEQ
%token LE
%token GE
%token THEN
%token ARRAY

%token COLON
%token COMMA

%token BRACKET_LEFT
%token BRACKET_RIGHT
%token LINE_SEPARATOR

%type <i> VAL

%%
input:
  | input op
  | input op data
  ;

op: instruction LINE_SEPARATOR | LINE_SEPARATOR;

data: ARRAY COLON data_entry;

data_entry: data_entry COMMA VAL { registers[data_size++] = $3; } |
            VAL {registers[data_size++] = $1;};

instruction: ins | ind_ins | c_ins | flow_ins
;

ins: load | store | add | sub | mult | div
;

ind_ins: indload | indstore | indadd | indsub | indmult | inddiv
;

c_ins: cload | cadd | csub | cmult | cdiv
;

flow_ins: goto | if | end
;

load:  INSTRUCTION_LOAD VAL         { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_LOAD, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out); printf("LOAD %d\n", $2);};
store:  INSTRUCTION_STORE VAL       { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_STORE, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out); printf("STORE %d\n", $2);};
add:  INSTRUCTION_ADD VAL           { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_ADD, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out); printf("ADD %d\n", $2);};
sub:  INSTRUCTION_SUB VAL           { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_SUB, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out); printf("SUB %d\n", $2);};
mult:  INSTRUCTION_MULT VAL         { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_MULT, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out); printf("MULT %d\n", $2);};
div:  INSTRUCTION_DIV VAL           { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_DIV, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out); printf("DIV %d\n", $2);};

indload:  INSTRUCTION_INDLOAD VAL   { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_INDLOAD, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("INDLOAD %d\n", $2);};
indstore:  INSTRUCTION_INDSTORE VAL { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_INDSTORE, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("INDSTORE %d\n", $2);};
indadd:  INSTRUCTION_INDADD VAL     { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_INDADD, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("INDADD %d\n", $2);};
indsub:  INSTRUCTION_INDSUB VAL     { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_INDSUB, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("INDSUB %d\n", $2);};
indmult:  INSTRUCTION_INDMULT VAL   { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_INDMULT, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("INDMULT %d\n", $2);};
inddiv:  INSTRUCTION_INDDIV VAL     { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_INDDIV, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("INDDIV %d\n", $2);};

cload:  INSTRUCTION_CLOAD VAL       { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_CLOAD, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("CLOAD %d\n",$2);};
cadd:  INSTRUCTION_CADD VAL         { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_CADD, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("CADD %d\n",$2);};
csub:  INSTRUCTION_CSUB VAL         { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_CSUB, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("CSUB %d\n",$2);};
cmult:  INSTRUCTION_CMULT VAL       { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_CMULT, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("CMULT %d\n",$2);};
cdiv:  INSTRUCTION_CDIV VAL         { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_CDIV, (uint16_t)$2}; fwrite(&v, sizeof(uint16_t), 2, out);printf("CDIV %d\n",$2);};

goto: INSTRUCTION_GOTO VAL          { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_GOTO, (uint16_t)$2-1}; fwrite(&v, sizeof(uint16_t), 2, out); printf("GOTO %d\n", $2-1);};

if: INSTRUCTION_IF_GOTO BRACKET_LEFT VAL BRACKET_RIGHT LEQ  VAL THEN INSTRUCTION_GOTO VAL     { exec_size += 4; uint16_t v[4] = {(uint16_t)DEF_IF_LEQ_GOTO, (uint16_t)$6, DEF_GOTO, (uint16_t)$9-1}; fwrite(&v, sizeof(uint16_t), 4, out);printf("IF c(0) <= %d -> goto %d\n", $6, $9-1);}
  | INSTRUCTION_IF_GOTO BRACKET_LEFT VAL BRACKET_RIGHT LE  VAL THEN INSTRUCTION_GOTO VAL      { exec_size += 4; uint16_t v[4] = {(uint16_t)DEF_IF_LE_GOTO, (uint16_t)$6, DEF_GOTO, (uint16_t)$9-1}; fwrite(&v, sizeof(uint16_t), 4, out);printf("IF c(0) < %d -> goto %d\n", $6, $9-1);}
  | INSTRUCTION_IF_GOTO BRACKET_LEFT VAL BRACKET_RIGHT EQ  VAL THEN INSTRUCTION_GOTO VAL      { exec_size += 4; uint16_t v[4] = {(uint16_t)DEF_IF_EQ_GOTO, (uint16_t)$6, DEF_GOTO, (uint16_t)$9-1}; fwrite(&v, sizeof(uint16_t), 4, out);printf("IF c(0) = %d -> goto %d\n", $6, $9-1);}
  | INSTRUCTION_IF_GOTO BRACKET_LEFT VAL BRACKET_RIGHT GE  VAL THEN INSTRUCTION_GOTO VAL      { exec_size += 4; uint16_t v[4] = {(uint16_t)DEF_IF_GE_GOTO, (uint16_t)$6, DEF_GOTO, (uint16_t)$9-1}; fwrite(&v, sizeof(uint16_t), 4, out);printf("IF c(0) > %d -> goto %d\n", $6, $9-1);}
  | INSTRUCTION_IF_GOTO BRACKET_LEFT VAL BRACKET_RIGHT GEQ  VAL THEN INSTRUCTION_GOTO VAL     { exec_size += 4; uint16_t v[4] = {(uint16_t)DEF_IF_GEQ_GOTO, (uint16_t)$6, DEF_GOTO, (uint16_t)$9-1}; fwrite(&v, sizeof(uint16_t), 4, out);printf("IF c(0) >= %d -> goto %d\n", $6, $9-1);};
end: INSTRUCTION_END                { exec_size += 2; uint16_t v[2] = {(uint16_t)DEF_END, (uint16_t)DEF_END};fwrite(&v, sizeof(uint16_t), 2, out);printf("END\n");};

VAL:  INT {$$=$1;}
;
%%

int main(int argc, char**argv) {
    FILE*f = fopen(argv[1],"r");
    yyin = f;
    out = fopen("a.out", "wb");
    {
      uint32_t v = 0xDECAFFEE;
      fwrite(&v, sizeof(uint32_t), 1, out);
    }
    yyparse();
    fclose(f);
    uint64_t size = ftell(out)-4;
    size /= 2;
    fwrite(&data_size, sizeof(uint16_t), 1, out);
    fwrite(&registers, sizeof(uintmax_t), data_size, out);
    fseek(out, 0, SEEK_SET);
    fwrite(&size, sizeof(uint32_t), 1, out);
    fclose(out);
    printf("Size: %d\nData: %d\n", size, data_size);
}