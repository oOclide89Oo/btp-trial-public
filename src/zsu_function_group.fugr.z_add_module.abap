FUNCTION Z_ADD_MODULE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_TERMINE1) TYPE  INT4
*"     VALUE(IV_TERMINE2) TYPE  INT4
*"  EXPORTING
*"     VALUE(EV_ERROR) TYPE  ABAP_BOOLEAN
*"     VALUE(EV_RESULT) TYPE  INT8
*"----------------------------------------------------------------------
"logica

    ev_result = iv_termine1 + iv_termine2.

    IF ev_result = 0.

        ev_error = abap_true.

    ENDIF.
.






ENDFUNCTION.
