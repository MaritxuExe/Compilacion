📌 Descripción general

Este proyecto consiste en la implementación del front-end de un compilador para un lenguaje de alto nivel hacia
código de tres direcciones, utilizando técnicas de análisis ascendente y Esquemas de Traducción Dirigida por 
la Sintaxis (ETDS). La implementación se realiza en C++ con Flex (analizador léxico) y Bison (analizador sintáctico)

🎯 Objetivos principales

* Diseñar e implementar un analizador léxico y sintáctico para el lenguaje fuente definido.
* Desarrollar un ETDS que especifique la traducción de los constructores del lenguaje.
* Generar código intermedio de tres direcciones a partir del código fuente.
* Manejar características avanzadas como control de flujo, subprogramas, expresiones booleanas y tablas multidimensionales (opcionales).

🏗️ Arquitectura del proyecto

1. Analizador léxico (tokens.l):
    * Define tokens para palabras reservadas, identificadores, constantes y operadores.
    * Incluye manejo de comentarios (línea y multilínea).
    * Implementa reglas para identificadores con restricciones específicas.
2. Analizador sintáctico (parser.y):
    * Gramática LALR(1) para el lenguaje fuente.
    * Acciones semánticas integradas para generar código intermedio.
    * Manejo de declaraciones, expresiones, estructuras de control y subprogramas.
3. Gestión de código (Codigo.hpp, Codigo.cpp):
    * Clase Codigo para almacenar y manipular instrucciones generadas.
    * Métodos para crear identificadores temporales, añadir instrucciones, completar referencias y escribir el código final.
4. Estructuras de datos (Exp.hpp):
    * Definiciones para listas de identificadores y referencias.
    * Estructuras para expresiones y sentencias con listas de saltos (trues, falses, breakB, nextB).

🔧 Características implementadas
    
  Lenguaje fuente soportado:
   * Declaraciones: Variables (int, float), listas de identificadores.
   * Estructuras de control:
       - if, if-elsif-else (extendido)
       - forever (bucle infinito)
       - do-until-else con break if y next
   * Operadores: Aritméticos (+, -, *, /, //), relacionales (==, >, <, etc.), booleanos (&&, ||, !)
   * Entrada/salida: read(), print()
   * Subprogramas: Definición, parámetros por valor/referencia, llamadas

  Lenguaje destino (código de tres direcciones):
   * Asignaciones: x := y op z
   * Saltos: goto L, if cond goto L
   * Declaraciones: int x, real x, proc nombre
   * Llamadas: param_val/ref, call
   * Entrada/salida: read x, write y, writeln

⚙️ Mecanismos clave implementados

  1. Generación de código con etiquetas dinámicas:
     * Uso de referencias numéricas (M, N) para manejar saltos pendientes.
     * Completado de instrucciones con completarInstrucciones().
  2. Evaluación de expresiones booleanas con cortocircuito:
     * Listas trues y falses para manejar saltos condicionales.
     * Optimización para && y || con evaluación perezosa.
  3. Manejo de bucles:
     * Listas breakB y nextB para gestionar rupturas y continuaciones.
     * Traducción correcta de break if y next.
  4. Gestión de memoria:
     * Uso de punteros para atributos sintetizados.
     * Liberación explícita de memoria en acciones semánticas.

🚀 Compilación y uso
  
  //Generar analizadores y compilar
  make

  //Limpiar archivos generados
  make clean
  

