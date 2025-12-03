%define parse.error verbose

%{
   #include <stdio.h>
   #include <iostream>
   #include <list>
   #include <string>
   #include <vector>

   using namespace std; 

   extern int yylex();
   extern int yylineno;
   extern char *yytext;
   extern int yyerrornum;
   void yyerror (const char *msg) {
     cout << "line " << yylineno <<": " << msg << " at token " << yytext << endl ;
     yyerrornum++;
   }
   #include "Codigo.hpp"
   #include "Exp.hpp"

   Codigo codigo;
%}

/* 

   Especifica todos los tipos de atributos que pueden tener los símbolos y sus nombres asociados.
   Nota: la estructura union solo acepta tipos básicos, enteros, reales, caracteres y punteros.
   Por ejemplo, si el atributo 'nombre' es una secuencia de caracteres, puntero a string:

*/

%union {
    string *nombre ; 
    IdLista *list ;
    expressionStruct *expr ;
    statementStruct *stat ; 
    int number ;
    RefLista *lent ;
}

/* 
   Declarar tokens. Esto debe coincidir con el fichero tokens.l
   Definir los atributos léxicos aquí.
   Por ejemplo, si los identificadores tienen el atributo 'nombre':

/* declaración de símbolos no terminales con atributos */

//Referencias
%type <number> M
%type <lent> N
//Palabras reservadas, que son de tipo 'nombre', es decir, un String
%token <nombre> RDEF RMAIN RLET RIF RELSIF RFOREVER RDO RUNTIL RELSE RBREAK RNEXT RREAD RPRINT RIN RFLOAT RINTEGER
//Terminales que tienen atributos de tipo 'nombre', es decir, un String 
%token <nombre> TID TINT_CNST TFLOAT_CNST
//Terminales sin atributos
%token TASSIG TLPAREN TRPAREN TLBRACE TRBRACE TCOLON TSEMIC TCOMMA TAMPERSAND TPLUS TMINUS TMUL TDIV TDIVINT TEQUAL TNE TGT TLT TGE TLE TOR TNOT TAND 



%nonassoc TEQUAL TNE TGT TLT TGE TLE TNOT
%left TPLUS TMINUS TOR TAND
%left TMUL TDIV TDIVINT 
%right TASSIG

/*  
   Aquí declarar los atributos sintetizados.
   Por ejemplo, si el no-terminal var_id_array tiene el atributo 'nombre'
   Para el análisis léxico y sintáctico SIN atributos.
*/

%type <nombre> var_id_array type par_class  
%type <list> par_list id_list 
%type <expr> expression
%type <stat> statement statements block

%start start
%%

start: RDEF RMAIN TLPAREN TRPAREN  
         {
            codigo.anadirInstruccion("prog main");
         } mblock 
            {
               codigo.anadirInstruccion("halt");
               codigo.escribir();  
            };

      // $1    $2 $3      $4       $5 $6        $7
mblock: bl_decl N TLBRACE subprogs M statements TRBRACE
         {
            codigo.completarInstrucciones(*$2, $5);
         };

block: TLBRACE statements TRBRACE
         { 
            $$ = new statementStruct;
            $$->nextB = $2->nextB;
            $$->breakB = $2->breakB;
            delete $2;
         };

bl_decl: RLET decl RIN 

      | %empty
;
   // $1   $2     $3      $4     $5
decl: decl TSEMIC id_list TCOLON type 
         {
            codigo.anadirDeclaraciones(*$3, *$5);
            delete $3;
            delete $5;
         }

         | id_list TCOLON type 
         {
            codigo.anadirDeclaraciones(*$1, *$3);
            delete $1;
            delete $3;
         };

id_list : id_list TCOMMA TID 
         {
            $$ = codigo.anadirALista(*$1, $3);

            delete $1;
            delete $3;
         }
            | TID 
         {
            $$ = codigo.inicializarLista($1);
            delete $1;
         };

type : RINTEGER 
         { 
            $$ = new string("int"); 
         }
     | RFLOAT 
         { 
            $$ = new string("real"); 
         };

subprogs : subprogs subprog

         |%empty
         ;

subprog: RDEF TID 
         {
            codigo.anadirInstruccion("proc " + *$2);
         } arguments mblock
            {  
               codigo.anadirInstruccion("endproc " + *$2); 
               delete $2;
            };

arguments : TLPAREN par_list TRPAREN

            |%empty
         ;
        //$1      $2     $3        $4
par_list: id_list TCOLON par_class type 
         {
            codigo.anadirParametros(*$1, *$3, *$4);
         } par_list_r 
         ;
          //$1      $2     $3     $4        $5
par_list_r: TSEMIC id_list TCOLON par_class type 
         {
            codigo.anadirParametros(*$2, *$4, *$5);
         } par_list_r 

         | %empty 
           ;

par_class : %empty 
         {
            $$ = new string("val");
         }
         | TAMPERSAND
         {
            $$ = new string("ref");
         };

statements : statements statement 
         {  
            $$ = new statementStruct;
            $$->breakB = codigo.unir($1->breakB, $2->breakB);
            $$->nextB = codigo.unir($1->nextB, $2->nextB);
            delete $1;
            delete $2;
         }
         |%empty 
         {
            $$ = new statementStruct;
            $$->breakB = codigo.listaVacia();
            $$->nextB = codigo.listaVacia();
         };
         // $1           $2     $3         $4
statement : var_id_array TASSIG expression TSEMIC   
         {
            $$ = new statementStruct;
            $$->breakB = codigo.listaVacia();
            $$->nextB = codigo.listaVacia();
            codigo.anadirInstruccion(*$1 + " := " + $3->nombre);
            delete $1;
            delete $3;
         }
         //$1  $2        $3 $4    $5
         | RIF expression M block M
         {
            codigo.completarInstrucciones($2->trues, $3);
            codigo.completarInstrucciones($2->falses, $5);     
            $$ = new statementStruct;
            $$->breakB = $4->breakB;
            $$->nextB = $4->nextB;
            delete $2;
            delete $4;
         }
         //$1  $2        $3 $4   $5 $6 $7    $8
         | RIF expression M block N M elseif M
         {
            codigo.completarInstrucciones($2->trues, $3);
            codigo.completarInstrucciones($2->falses, $6);     
            codigo.completarInstrucciones(*$5, $8);
            $$ = new statementStruct;
            $$->breakB = $4->breakB;
            $$->nextB = $4->nextB;
            delete $2;
            delete $4;
         }
         //$1      $2 $3   $4
         | RFOREVER M block M
         {
            $$ = new statementStruct;
            codigo.anadirInstruccion("goto " + to_string($2));
            codigo.completarInstrucciones($3->breakB, $4 +1);
            $$->nextB = $3->nextB;
            delete $3;
         }
         //$1  $2 $3   $4     $5        $6 $7    $8   $9  
         | RDO M block RUNTIL expression M RELSE block M
         {
            $$ = new statementStruct;
            codigo.completarInstrucciones($5->falses, $2); 
            codigo.completarInstrucciones($5->trues, $9); 
            codigo.completarInstrucciones($3->nextB, $6); 
            codigo.completarInstrucciones($3->breakB, $9); 
            delete $8;
            delete $3;
            delete $5;
         }
         //$1     $2  $3         $4     $5
         | RBREAK RIF expression TSEMIC M 
         {
            $$ = new statementStruct;
            codigo.completarInstrucciones($3->falses, $5);
            $$->breakB = $3->trues;
            $$->nextB = codigo.listaVacia();
            delete $3;
         }

         | RNEXT TSEMIC M
         {
            $$ = new statementStruct;
            $$->breakB = codigo.listaVacia();
            $$->nextB = codigo.inicializarListaRef($3);
            codigo.anadirInstruccion("goto");
         }
         | RREAD TLPAREN var_id_array TRPAREN TSEMIC
         {
            codigo.anadirInstruccion("read " + *$3);
            $$ = new statementStruct;
            $$->nextB = codigo.listaVacia();
            $$->breakB = codigo.listaVacia();
            delete $3;
         }
         | RPRINT TLPAREN expression TRPAREN TSEMIC
         {
            codigo.anadirInstruccion("write " + $3->nombre);
            $$ = new statementStruct;
            $$->nextB = codigo.listaVacia();
            $$->breakB = codigo.listaVacia();
            delete $3;
         };

       //$1     $2         $3 $4  $5 $6 $7   $8    
elseif : RELSIF expression M block N M elseif M
         {
            codigo.completarInstrucciones($2->trues, $3);
            codigo.completarInstrucciones($2->falses, $6);     
            codigo.completarInstrucciones(*$5, $8);
         }

         | RELSE block
      ;

var_id_array: TID 
         {
            $$ = new string(*$1); 
            delete $1;
         }

expression : expression TEQUAL expression 
         { 
		      $$ = new expressionStruct;
            $$->trues = codigo.inicializarListaRef(codigo.obtenRef());
            $$->falses = codigo.inicializarListaRef(codigo.obtenRef() + 1);
	 		   codigo.anadirInstruccion("if " + $1->nombre + " = " + $3->nombre  + " goto") ;
	  		   codigo.anadirInstruccion("goto") ;
	  		   delete $1; 
            delete $3; 
         }
         | expression TGT expression 
         { 
		      $$ = new expressionStruct;
            $$->trues = codigo.inicializarListaRef(codigo.obtenRef());
            $$->falses = codigo.inicializarListaRef(codigo.obtenRef() + 1);
	 		   codigo.anadirInstruccion("if " + $1->nombre + " > " + $3->nombre  + " goto") ;
	  		   codigo.anadirInstruccion("goto") ;
	  		   delete $1; 
            delete $3; 
         }
         | expression TLT expression 
         { 
            $$ = new expressionStruct;
            $$->trues = codigo.inicializarListaRef(codigo.obtenRef());
            $$->falses = codigo.inicializarListaRef(codigo.obtenRef() + 1);
            codigo.anadirInstruccion("if " + $1->nombre + " < " + $3->nombre  + " goto") ;
            codigo.anadirInstruccion("goto") ;
            delete $1; 
            delete $3; 
         }
         | expression TGE expression 
         { 
            $$ = new expressionStruct;
            $$->trues = codigo.inicializarListaRef(codigo.obtenRef());
            $$->falses = codigo.inicializarListaRef(codigo.obtenRef() + 1);
            codigo.anadirInstruccion("if " + $1->nombre + " >= " + $3->nombre  + " goto") ;
            codigo.anadirInstruccion("goto") ;
            delete $1; 
            delete $3; 
         }
         | expression TLE expression 
         { 
            $$ = new expressionStruct;
            $$->trues = codigo.inicializarListaRef(codigo.obtenRef());
            $$->falses = codigo.inicializarListaRef(codigo.obtenRef() + 1);
            codigo.anadirInstruccion("if " + $1->nombre + " <= " + $3->nombre  + " goto") ;
            codigo.anadirInstruccion("goto") ;
            delete $1; 
            delete $3; 
            }
         | expression TNE expression 
         { 
            $$ = new expressionStruct;
            $$->trues = codigo.inicializarListaRef(codigo.obtenRef());
            $$->falses = codigo.inicializarListaRef(codigo.obtenRef() + 1);
            codigo.anadirInstruccion("if " + $1->nombre + " != " + $3->nombre  + " goto") ;
            codigo.anadirInstruccion("goto") ;
            delete $1;	
            delete $3; 
         }

         | expression TOR M expression 
         {
            $$ = new expressionStruct;
            codigo.completarInstrucciones($1->falses, $3);
            $$->trues = codigo.unir($1->trues, $4->trues);
            $$->falses = $4->falses;
         }

         | expression TAND M expression
         {
            $$ = new expressionStruct;
            codigo.completarInstrucciones($1->trues, $3);
            $$->trues = $4->trues;
            $$->falses = codigo.unir($1->falses, $4->falses);
         }

         | TNOT expression
         {
            $$ = new expressionStruct;
            $$->trues = $2->falses;
            $$->falses = $2->trues;
         }

         | expression TPLUS expression  
         { 
            $$ = new expressionStruct;
            $$->nombre = codigo.nuevoId();
            $$->trues = codigo.listaVacia();
            $$->falses = codigo.listaVacia();
            codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " + " + $3->nombre) ;
            delete $1; 
            delete $3; 
         }

         | expression TMINUS expression  
         { 
            $$ = new expressionStruct;
            $$->nombre = codigo.nuevoId();
            $$->trues = codigo.listaVacia();
            $$->falses = codigo.listaVacia();
            codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " - " + $3->nombre) ;
            delete $1; 
            delete $3; 
         }
         | expression TMUL expression 
         { 
            $$ = new expressionStruct;
            $$->nombre = codigo.nuevoId();
            $$->trues = codigo.listaVacia();
            $$->falses = codigo.listaVacia();
            codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " * " + $3->nombre) ;
            delete $1; 
            delete $3; 
         }
         | expression TDIV expression 
         { 
            $$ = new expressionStruct;
            $$->nombre = codigo.nuevoId();
            $$->trues = codigo.listaVacia();
            $$->falses = codigo.listaVacia();
            codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " / " + $3->nombre) ;
            delete $1; 
            delete $3; 
         }
         | expression TDIVINT expression 
         { 
            $$ = new expressionStruct;
            $$->nombre = codigo.nuevoId();
            $$->trues = codigo.listaVacia();
            $$->falses = codigo.listaVacia();
            codigo.anadirInstruccion($$->nombre + " := " + $1->nombre + " div " + $3->nombre) ;
            delete $1; 
            delete $3; 
         }
         | TID 
         {
            $$ = new expressionStruct;
            $$->nombre = *$1;
            $$->trues = codigo.listaVacia();
            $$->falses = codigo.listaVacia();
            delete $1;
         }
         | TINT_CNST 
         { 
            $$ = new expressionStruct();
            $$->nombre = *$1;
            $$->trues = codigo.listaVacia();
            $$->falses = codigo.listaVacia();
         }
         | TFLOAT_CNST 
         { 
            $$ = new expressionStruct();
            $$->nombre = *$1; 
            $$->trues = codigo.listaVacia();
            $$->falses = codigo.listaVacia();
         }
         | TLPAREN expression TRPAREN 
         { 
            $$ = $2; 
         };


M:  %empty 
         { 
            $$ = codigo.obtenRef() ; 
         };

N:  %empty 
         { 
            $$ = new list<int>;
            $$->push_back(codigo.obtenRef()) ;
            codigo.anadirInstruccion("goto"); 
         };

%%