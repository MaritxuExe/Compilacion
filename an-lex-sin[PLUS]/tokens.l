%{
 #include <string>
  using namespace std ;
 #include "Exp.hpp"
 #include "parser.h"

 #define TOKEN(t) yylval.nombre = new std::string(yytext, yyleng) ; return t 
 extern "C" int yywrap() { return(1) ; }  

 extern int yyerror(const char *); 
%}

%%
"def"	                TOKEN(RDEF) ;
"main"	                TOKEN(RMAIN) ;
"let"                   TOKEN(RLET) ;

"if"                    TOKEN(RIF);
"elsif"                 TOKEN(RELSIF);
"else"                  TOKEN(RELSE);
"break"                 TOKEN(RBREAK);
"forever"               TOKEN(RFOREVER);
"until"                 TOKEN(RUNTIL);
"next"                  TOKEN(RNEXT);

"in"                    TOKEN(RIN);

"read"                  TOKEN(RREAD);
"print"                 TOKEN(RPRINT);

"int"                   TOKEN(RINTEGER);   
"float"                 TOKEN(RFLOAT);
"do"                    TOKEN(RDO);    

"="                     TOKEN(TASSIG);
"("                     TOKEN(TLPAREN);
")"                     TOKEN(TRPAREN);
"{"                     TOKEN(TLBRACE); 
"}"                     TOKEN(TRBRACE); 
":"                     TOKEN(TCOLON);
";"                     TOKEN(TSEMIC);
","                     TOKEN(TCOMMA);
"&"                     TOKEN(TAMPERSAND);


[ \t\n]+                 ; /* Ignora espacios en blanco, tabs y saltos de línea */

"||"                    TOKEN(TOR);  
"&&"                    TOKEN(TAND); 
"!"                     TOKEN(TNOT);
"=="                     TOKEN(TEQUAL);
"/="                     TOKEN(TNE);
">"                      TOKEN(TGT);
"<"                      TOKEN(TLT);
">="                     TOKEN(TGE);
"<="                     TOKEN(TLE);
"+"                      TOKEN(TPLUS); 
"-"                      TOKEN(TMINUS);    
"/"                      TOKEN(TDIV);
"\/\/"                   TOKEN(TDIVINT);
"*"	                     TOKEN(TMUL) ;

\#[^\n]*     ;    // Ignora todo lo que empiece por # hasta el salto de línea

'''([^']|'[^']|''[^'])*'''('*) { /* Ignorar comentarios multilínea */ }

[a-zA-Z$]_{0,2}([a-zA-Z0-9]+_{0,2})*                     TOKEN(TID) ; 
-?(0|([1-9][0-9]*))\.(0|[0-9]+[E|e]?[+|-]?[0-9]*)        TOKEN(TFLOAT_CNST); 
-?(0|([1-9][0-9]*))                                      TOKEN(TINT_CNST); 

.                       { yyerror("Unknown token");}
%%

