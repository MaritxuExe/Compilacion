#ifndef EXP_HPP_
#define EXP_HPP_

#include <list>
#include <string>
  using namespace std; 

/*  using std::list;
  using std::string; */

typedef list<string> IdLista;
typedef list<int> RefLista;


struct expressionStruct {
  std::string nombre;
  std::string tipo; //int / float /error
  RefLista trues ;
  RefLista falses ;
};

struct statementStruct{
  //Lista de referencias para las instrucciones de ruptura (break).
  RefLista breakB;
  //Lista de referencias para las instrucciones de continuación (next).
  RefLista nextB;
};

#endif /* EXP_HPP_ */


