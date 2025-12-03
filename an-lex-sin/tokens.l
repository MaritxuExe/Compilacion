%{
 #include <iostream>  
 using namespace std;
 #include "parser.h" 

 #define TOKEN(t) return t

 extern int yyerror(const char *); 

%}

%%
def	                  TOKEN(RDEF) ;
main	                  TOKEN(RMAIN) ;
let                     TOKEN(RLET) ;

if                      TOKEN(RIF);
else                    TOKEN(RELSE);
break                   TOKEN(RBREAK);
forever                 TOKEN(RFOREVER);
until                   TOKEN(RUNTIL);
next                    TOKEN(RNEXT);
in                      TOKEN(RIN);

read                    TOKEN(RREAD);
print                   TOKEN(RPRINT);

int                     TOKEN(RINTEGER);   
float                   TOKEN(RFLOAT);
do                      TOKEN(RDO);    

\=                     TOKEN(TASSIG);
\(                     TOKEN(TLPAREN);
\)                     TOKEN(TRPAREN);
\{                     TOKEN(TLBRACE); 
\}                     TOKEN(TRBRACE); 
\:                     TOKEN(TCOLON);
\;                     TOKEN(TSEMIC);
\,                     TOKEN(TCOMMA);
\&                      TOKEN(TAMPERSAND);

[ \t\n]+                 ; /* Ignora espacios en blanco, tabs y saltos de línea */

==                    TOKEN(TEQUAL);
\/=                    TOKEN(TNE);
\>                     TOKEN(TGT);
\<                     TOKEN(TLT);
>=                    TOKEN(TGE);
\<=                    TOKEN(TLE);
\+                     TOKEN(TPLUS); 
-                     TOKEN(TMINUS);    
\/                     TOKEN(TDIV);
\/\/                    TOKEN(TDIVINT);
\*	                  TOKEN(TMUL) ;

   /*** HAUEK EZ DIRA TOKENEN ADIERAZPEN ZUZENAK, ZUEN ADIERAZPENAK JARRI ETA PROBATU */
   /*** ESTAS NO SON LAS EXPRESIONES CORRECTAS, PONED Y PROBAD LAS VUESTRAS */



[a-zA-Z$]_{0,2}([a-zA-Z0-9]+_{0,2})*                           TOKEN(TID) ; 
-?(0|([1-9][0-9]*))\.(0|[0-9]+[E|e]?[+|-]?[0-9]*)              TOKEN(TFLOAT_CNST); //CORREGIR
-?(0|([1-9][0-9]*))                                            TOKEN(TINT_CNST); 

#[^#\n]*\n                ;        /* Ignora comentarios de una línea */
'''('?'?[^#'])*'?'?'''         ;     /* Ignorar comentarios multilínea */

.                       { yyerror("Unknown token");}
%%