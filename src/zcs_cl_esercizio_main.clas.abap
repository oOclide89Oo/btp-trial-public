CLASS zcs_cl_esercizio_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcs_cl_esercizio_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

* Richiamiamo il metodo della classe ZCS_CL_ESERCIZIO
    DATA: lo_class    TYPE REF TO zcs_cl_esercizio,
          lv_error    TYPE abap_boolean,
          ls_token    TYPE zcs_cl_esercizio=>ts_token,
          lv_response TYPE string VALUE 'Scrivimi la response',
          lv_return   TYPE abap_boolean.

    CREATE OBJECT lo_class.
    IF lo_class IS BOUND.
      lv_return = lo_class->ariba_token( EXPORTING io_out = out
                           IMPORTING ev_error = lv_error
                                     es_token = ls_token
                           CHANGING  cv_response = lv_response
                            ).
      IF lv_return EQ abap_true.
        out->write( 'TUTTO OK').
        lo_class->ariba_get_approvables( EXPORTING iv_access_token = ls_token-access_token
                                                 iv_realm        = 'TechedgeDSAP-T'
                                                 iv_user         = 'utente.extapprover'
                                                 iv_password     = 'PasswordAdapter1'
                                                 iv_api_key      = 'DAGRdq2i8OoApie1F6F7iYUNQn1IySZH' ).
      ELSE.
        out->write( 'QUALCOSA è ANDATO STORTO').
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
