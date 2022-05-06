CLASS zac_cl_http_client DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    METHODS: client_output IMPORTING io_output TYPE REF TO if_oo_adt_classrun_out.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_http_client IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    client_output( EXPORTING io_output = out ).

  ENDMETHOD.

  METHOD client_output.
    DATA: lo_class    TYPE REF TO zac_cl_http_server,
          lv_error    TYPE abap_boolean,
          ls_token    TYPE zac_cl_http_server=>ts_token,
          lv_response TYPE string VALUE 'Pronto a ricevere una response!',
          lv_return   TYPE abap_boolean.

    CREATE OBJECT lo_class.

    IF lo_class IS BOUND.
      lv_return = lo_class->server_output( EXPORTING io_out = io_output
                                           IMPORTING es_token = ls_token
                                                     ev_error = lv_error
                                           CHANGING cv_request = lv_response
                                           ).

      IF lv_return EQ abap_true.
        io_output->write( 'Tutto OK!' ).
      ELSE.
        io_output->write( 'Qualcosa è andato storto').
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
