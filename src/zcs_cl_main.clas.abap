CLASS zcs_cl_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS: test_variabile_statica,
      differenza_sezioni.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcs_cl_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    zcs_cl_main=>test_variabile_statica( ).
  ENDMETHOD.

  METHOD test_variabile_statica.
    DATA: lo_class TYPE REF TO zcs_cl_http_client,
          lv_dato  TYPE string.

    zcs_cl_http_client=>set_variabile_statica( 'TEST VARIABILE STATICA').

    CREATE OBJECT lo_class
      EXPORTING
        iv_name    = 'MY CLASS'
        iv_date    = CONV timestampl( cl_abap_context_info=>get_system_date( ) )
        iv_creator = sy-uname.
* Verifico che me lo abbia creato
    IF lo_class IS BOUND.
      lo_class->metodo_di_istanza( ).
    ENDIF.

    CLEAR lo_class.

    lv_dato = zcs_cl_http_client=>get_variabile_statica( ).


  ENDMETHOD.

  METHOD differenza_sezioni.
* Chiamare un metodo di istanza
* step 1
    DATA lo_class TYPE REF TO zcs_cl_http_client.
* Istanzio la class
    CREATE OBJECT lo_class
      EXPORTING
        iv_name    = 'MY CLASS'
        iv_date    = CONV timestampl( cl_abap_context_info=>get_system_date( ) )
        iv_creator = sy-uname.
* Verifico che me lo abbia creato
    IF lo_class IS BOUND.
      lo_class->metodo_di_istanza( ).
    ENDIF.
**********************************************************************
*  Chiamare un metodo di classe
    zcs_cl_http_client=>metodo_di_classe( ).
    CLEAR lo_class.
**********************************************************************
  ENDMETHOD.

ENDCLASS.
