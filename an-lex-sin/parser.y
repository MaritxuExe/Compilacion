%{
   #include <stdio.h>
   #include <iostream>
   #include <vector>
   #include <string>
   using namespace std; 
   extern int yyerrornum;
   extern int yylex();
   extern int yylineno;
   extern char *yytext;
   void yyerror (const char *msg) {
     printf("line %d: %s at '%s'\n", yylineno, msg, yytext) ;
     yyerrornum++;
   }

%}

/* 
   Ikurrek izan ditzaketen atributu-mota guztiak eta lotutako izenak
   hemen zehaztu.
   Oharra: union egiturak bakarrik onartzen ditu oinarrizko datu-motak,
   osoko, erreal, karaktere eta erakusleak.
   Adibidez, 'izena' atributua karaktere-katea bada, string erakuslea:

%union {
    string *izena ;
}
********************************      
   Especifica todos los tipos de atributos que pueden tener los símbolos
   y sus nombres asociados.
   Nota: la estructura union solo acepta tipos básicos,
   enteros, reales, caracteres y punteros.
   Por ejemplo, si el atributo 'nombre' es una secuencia de caracteres,
   puntero a string:

%union {
    string *nombre ;
}
*/

/* 
   Tokenak erazagutu. Honek tokens.l fitxategiarekin 
   bat etorri behar du.
   Atributu lexikoak hemen zehaztu behar da.
   Adibidez, identifikadoreek 'izena' atributua izango badute:

%token <izena> TID

   Analisi lexiko eta sintaktikorako atributurik EZ.
********************************   
   Declarar tokens. Esto debe coincidir con el
   fichero tokens.l
   Definir los atributos léxicos aquí.
   Por ejemplo, si los identificadores tienen el atributo 'nombre':

%token <nombre> TID
   Para el análisis léxico y sintáctico SIN atributos.
*/

%token RDO RFLOAT RINTEGER RDEF RLET RELSE
%token RREAD RPRINT RIN RNEXT RUNTIL RFOREVER RBREAK RIF

%token TID TINT_CNST TFLOAT_CNST

%token TSEMIC TASSIG TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TCOLON
%token TEQUAL TGT TLT TGE TLE TNE TPLUS TMINUS TMUL TDIV 
%token RMAIN TAMPERSAND TDIVINT


/* Hemen atributu sintetizatuak erazagutu. 
   Adibidez, var_id_array ez-bukaerakoak 'izena' atributua izango badu:

%type <izena> var_id_array

   Analisi lexiko eta sintaktikorako atributurik EZ.
********************************   
   Aquí declarar los atributos sintetizados.
   
   Por ejemplo, si el no-terminal var_id_array tiene el atributo 'nombre'

%type <nombre> var_id_array

   Para el análisis léxico y sintáctico SIN atributos.
*/

%start start
%%

start : RDEF RMAIN TLPAREN TRPAREN mblock ;

mblock : bl_decl TLBRACE subprogs statements TRBRACE ;

block : bl_decl TLBRACE statements TRBRACE ;

bl_decl : RLET decl RIN 
      | /* epsilon */
      ;

decl : decl TSEMIC id_list TCOLON type
      | id_list TCOLON type
      ;

id_list : id_list TCOMMA TID
      | TID
      ;

type : RINTEGER
     | RFLOAT
     ;

subprogs : subprogs subprog
      | /* epsilon */
      ;

subprog : RDEF TID arguments mblock ;

arguments : TLPAREN par_list TRPAREN
   | /* epsilon */
   ;

par_list : id_list TCOLON par_class type par_list_r ;

par_list_r : TSEMIC id_list TCOLON par_class type par_list_r
     | /* epsilon */
     ;

par_class : /* epsilon */
      | TAMPERSAND
      ;

statements : statements statement
    | /* epsilon */
    ;

statement : var_id_array TASSIG expression TSEMIC
   | RIF expression block
   | RFOREVER block
   | RDO block RUNTIL expression RELSE block
   | RBREAK RIF expression TSEMIC
   | RNEXT TSEMIC
   | RREAD TLPAREN var_id_array TRPAREN TSEMIC
   | RPRINT TLPAREN expression TRPAREN TSEMIC
   ;

var_id_array : TID ;

expression : expression TEQUAL expression
    | expression TGT expression
    | expression TLT expression
    | expression TGE expression
    | expression TLE expression
    | expression TNE expression
    | expression TPLUS expression
    | expression TMINUS expression
    | expression TMUL expression
    | expression TDIV expression
    | expression TDIVINT expression
    | TID
    | TINT_CNST
    | TFLOAT_CNST
    | TLPAREN expression TRPAREN
    ;