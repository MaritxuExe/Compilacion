#include "Codigo.hpp"

using namespace std;

/****************/
/* Constructora */
/****************/

Codigo::Codigo() {
  siguienteId = 1;
}

/***********/
/* nuevoId */
/***********/

string Codigo::nuevoId() {
  string nId("%T");
  nId += to_string(siguienteId++);
  return nId;
}

/*********************/
/* anadirInstruccion */
/*********************/

void Codigo::anadirInstruccion(const string &stringInst) {
  string instruccion;
  instruccion = to_string(obtenRef()) + ": " + stringInst;
  instrucciones.push_back(instruccion);
}


/***********************/
/* anadirDeclaraciones */
/***********************/

void Codigo::anadirDeclaraciones(const IdLista &idNombres, const string &tipoNombre) {
  IdLista::const_iterator iter;
  for (iter=idNombres.begin(); iter!=idNombres.end(); iter++) {
    anadirInstruccion(tipoNombre + " " + *iter);
  }
}


/*********************/
/* anadirParametros  */
/*********************/

void Codigo::anadirParametros(const IdLista &idNombres, const string &parTipoNombre, const string &tipoNombre){ 
  IdLista::const_iterator iter;
  for (iter=idNombres.begin(); iter!=idNombres.end(); iter++) {
    anadirInstruccion(parTipoNombre + "_" + tipoNombre + " " + *iter);
  }
}


/**************************/
/* completarInstrucciones */
/**************************/

void Codigo::completarInstrucciones(RefLista &numInstrucciones, const int valor) {
  string referencia = " " + to_string(valor) ;
  list<int>::iterator iter;
 
  for (iter = numInstrucciones.begin(); iter != numInstrucciones.end(); iter++) {
    instrucciones[*iter-1].append(referencia);
  }
}


/************/
/* escribir */
/************/

void Codigo::escribir() const {
  vector<string>::const_iterator iter;
  for (iter = instrucciones.begin(); iter != instrucciones.end(); iter++) {
    cout << *iter << endl;
  }
}


/************/
/* obtenRef */
/************/

int Codigo::obtenRef() const {
	return instrucciones.size() + 1;
}


/****************/
/* anadirALista */
/****************/
IdLista* Codigo::anadirALista(const IdLista &lista, const string* elemento) {
  IdLista* nueva = new IdLista(lista);
  nueva->push_back(*elemento);
  return nueva;
}

/*************************/
/* inicializarLista      */
/*************************/
IdLista* Codigo::inicializarLista(const string* referencia) {
  IdLista* nueva = new IdLista();
  nueva->push_back(*referencia);
  return nueva;
}

  /**********************/
 /* inicializarListaRef*/
/**********************/

// Modificar esta función para que devuelva una referencia, no un puntero
RefLista Codigo::inicializarListaRef(int referencia) {
  RefLista nueva;
  nueva.push_back(referencia);  // Usamos el valor directo (int), no un puntero
  return nueva;
}

/************/
/* listaVacia */
/************/
RefLista Codigo::listaVacia() {
  return std::list<int>();
}


/********/
/* unir */
/********/

RefLista Codigo::unir(const RefLista &lista1, const RefLista &lista2) {
  RefLista nueva = lista1;  // Copia lista1
  nueva.insert(nueva.end(), lista2.begin(), lista2.end());
  return nueva;
}



