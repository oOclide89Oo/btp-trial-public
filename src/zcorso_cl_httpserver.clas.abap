* 2)  creare un altra classe che abbia un interfaccia runnable (if_oo_adt_classrun).
*     nel metodo main di questa classe creare un oggetto di tipo classe definito prima
*     e chiamare il metodo di istanza creato.
CLASS zcorso_cl_httpserver DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun. "VEDERE BENE INTERFACCE
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcorso_cl_httpserver IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lo_class TYPE REF TO zcorso_cl_httpclient,
          lv_error TYPE abap_boolean,
          ls_token TYPE  zcorso_cl_httpclient=>ts_token,
          lv_response TYPE string,
          lv_return TYPE abap_boolean.

  CREATE OBJECT lo_class.
        "sempre meglio usare IS BOUND per vedere se l'oggetto è stato creato
        "quindi, se la classe esiste
        IF lo_class IS BOUND.

            "prende i valori del metodo_silvio e gli metto nelle nuove variabili definite
            lv_return = lo_class->ariba_token( EXPORTING io_out = out
                                                 IMPORTING ev_error = lv_error
                                                           es_token = ls_token
                                                 CHANGING cv_response = lv_response
                                               ).
            "se lv_return è vero, l'outpit dara un messaggio a console
            IF lv_return = abap_true.
                out->write( 'GOOD :)' ).
            ELSE.
                out->write( 'BAD!' ).

            ENDIF.
        ENDIF.


  ENDMETHOD.

ENDCLASS.
