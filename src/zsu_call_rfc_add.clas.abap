CLASS zsu_call_rfc_add DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_call_rfc_add IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lv_error TYPE abap_boolean,
          lv_result TYPE int8.

    CALL FUNCTION 'Z_ADD_MODULE' EXPORTING iv_termine1 = 2 iv_termine2 = 3
                                  IMPORTING ev_error = lv_error
                                            ev_result = lv_result.

    IF lv_error is initial.
        out->write( lv_result ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
