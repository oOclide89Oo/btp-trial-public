CLASS zsu_es_http_server DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_es_http_server IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA: lo_class TYPE REF TO zsu_es_http_client,
          lv_error TYPE abap_boolean,
          ls_token TYPE  zsu_es_http_client=>ts_token,
          lv_response TYPE string,
          lv_return TYPE abap_boolean.

    CREATE OBJECT lo_class.
        "sempre meglio usare IS BOUND per vedere se l'oggetto è stato creato
        "quindi, se la classe esiste
        IF lo_class IS BOUND.

            "prende i valori del metodo ariba_token e gli metto nelle nuove variabili definite
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
