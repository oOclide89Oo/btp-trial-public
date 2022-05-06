CLASS zcs_cl_call_rfc_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcs_cl_call_rfc_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
     DATA: lv_result TYPE int8,
           lv_error  TYPE abap_boolean.

     CALL FUNCTION 'Y_CS_FUNCTION_MODULE' EXPORTING iv_termine1 = 3 iv_termine2 = 4
                                          IMPORTING ev_error    = lv_error
                                                    ev_result   = lv_result.
     IF lv_error IS INITIAL.
        out->write( lv_result ).
     ENDIF.
                   .


  ENDMETHOD.
ENDCLASS.
