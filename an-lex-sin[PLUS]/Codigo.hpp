#ifndef CODIGO_HPP_
#define CODIGO_HPP_
#include <iostream>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <string>
   using namespace std; 

#include "Exp.hpp"

/* Estructura de datos para el código generado. El código, en vez de escribirlo directamente,
 * se guarda en esta estructura y, al final, se escribirán en un fichero.
 */
class Codigo {

private:

    /**************************/
    /* REPRESENTACION INTERNA */
    /**************************/

    /* Instrucciones que forman el código. */
    vector<string> instrucciones;

    /* Clave para generar identificaciones nuevos. Cada vez que se crea un id se incrementa. */
    int siguienteId;

    
public:

    /************************************/
    /* METODOS PARA GESTIONAR EL CODIGO */
    /************************************/

    /* Constructora */
    Codigo();

    /* Crea un nuevo identificador del tipo "%T1, %T2, ...", siempre diferente. */
    string nuevoId() ;

    /* Añade una nueva instrucción a la estructura. */
    void anadirInstruccion(const string &instruccion);

    /* Dada una lista de variables y su tipo, crea y añade las instrucciones de declaración */
    void anadirDeclaraciones(const IdLista &idNombres, const string &tipoNombre);

    /* Dados una lista de parámetros, el modo de paso y su tipo, crea y añade las instrucciones de declaración de parámetros */
    void anadirParametros(const IdLista &idNombres, const string &parTipoNombre, const string &tipoNombre) ;

    /* Añade a las instrucciones que se especifican la referencia que les falta.
     * Por ejemplo: "goto" => "goto 20" */
    void completarInstrucciones(RefLista &numInstrucciones, const int valor);

    /* Escribe las instrucciones acumuladas en la estructura en el fichero de salida, con su punto y coma al final. */
    void escribir() const;

    /* Devuelve el número de la siguiente instrucción. */
    int obtenRef() const;

    //Añade un elemento a una lista de identificadores (IdLista) y devuelve una nueva lista con el elemento añadido.
    IdLista *anadirALista(const IdLista &lista, const string *elemento);

    //Crea una nueva lista de identificadores y agrega un único identificador a la lista.
    IdLista *inicializarLista(const string *referencia);

    //Devuelve una lista vacía de tipo RefLista
    RefLista listaVacia();

    //Crea una nueva lista de referencias (RefLista) y agrega un único entero a la lista.
    RefLista inicializarListaRef(int referencia);

    //Une dos listas de referencias (RefLista) en una nueva lista.
    RefLista unir(const RefLista &lista1, const RefLista &lista2);
    
};

#endif /* CODIGO_HPP_ */
