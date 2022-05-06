CLASS zcs_cl_http_client DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************
* Metodi di ISTANZA
    METHODS: metodo_di_istanza,
      constructor IMPORTING iv_name    TYPE string
                            iv_creator TYPE sy-uname
                            iv_date    TYPE timestampl.
**********************************************************************
* Metodo di CLASSE O STATICO
    CLASS-METHODS: metodo_di_classe,
                   get_variabile_statica RETURNING VALUE(rv_value) TYPE string,
                   set_variabile_statica IMPORTING iv_value TYPE string.
**********************************************************************
* Attributi di ISTANZA
    DATA: mv_attributo_istanza TYPE string.

* Attributi di CLASSE O STATICO
**********************************************************************
    CLASS-DATA: mv_attributo_classe TYPE string.
**********************************************************************

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: mv_name    TYPE string,
          mv_creator TYPE sy-uname,
          mv_date    TYPE timestampl.
    CLASS-DATA: mv_dato_statico TYPE string.
**********************************************************************
* Metodo di ISTANZA PRIVATO
    METHODS: metodo_privato_di_istanza.





ENDCLASS.



CLASS zcs_cl_http_client IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.
  METHOD metodo_di_istanza.
    metodo_privato_di_istanza( ).
  ENDMETHOD.

  METHOD metodo_di_classe.

  ENDMETHOD.

  METHOD metodo_privato_di_istanza.

  ENDMETHOD.

  METHOD constructor.

    mv_name    = iv_name.
    mv_creator = iv_creator.
    mv_date    = iv_date.

  ENDMETHOD.

  METHOD get_variabile_statica.
    rv_value = mv_dato_statico.
  ENDMETHOD.

  METHOD set_variabile_statica.
     mv_dato_statico = iv_value.
  ENDMETHOD.

ENDCLASS.
