CLASS zac_cl_single_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS: read_log_api  IMPORTING iv_log_id        TYPE zac_fname
                                           iv_active_system TYPE zac_actsys
                                 EXPORTING ev_error         TYPE abap_boolean
                                 RETURNING VALUE(rt_log)    TYPE zac_t_cds_log,
                   write_log_api IMPORTING iv_log_id        TYPE zac_fname
                                           iv_active_system TYPE zac_actsys
                                           iv_value         TYPE zac_fvalue
                                 EXPORTING ev_error         TYPE abap_boolean.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_single_log IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.

  METHOD read_log_api.
    DATA: lt_log_db TYPE STANDARD TABLE OF zac_db_single,
          ls_log_db TYPE zac_db_single,
          ls_log    TYPE zac_cds_single_log,
          lv_log_id TYPE zac_fname.
    CLEAR ev_error.

    lv_log_id = iv_log_id.
    TRANSLATE lv_log_id TO UPPER CASE.

*    SELECT * FROM zac_db_single WHERE fieldname    EQ @lv_log_id AND
*                                      activesystem EQ @iv_active_system
*                                      INTO CORRESPONDING fields of TABLE @rt_log.

    SELECT * FROM zac_db_single WHERE fieldname    EQ @lv_log_id AND
                                      activesystem EQ @iv_active_system
                                      INTO TABLE @lt_log_db.

    IF sy-subrc EQ 0.
      LOOP AT lt_log_db INTO ls_log_db.
        CLEAR: ls_log.
        ls_log-fieldname  = ls_log_db-fieldname.
        ls_log-fieldvalue = ls_log_db-fieldvalue.
        APPEND ls_log TO rt_log.
      ENDLOOP.
    ELSE.
      ev_error = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD write_log_api.
    DATA: ls_log   TYPE zac_db_single,
          lv_logid TYPE zac_fname,
          lv_value TYPE zac_fvalue.

    CLEAR ev_error.

    lv_logid = iv_log_id.
    lv_value = iv_value.

    TRANSLATE lv_logid TO UPPER CASE.

    SELECT SINGLE * FROM zac_db_single
    WHERE fieldname    = @lv_logid AND
          activesystem = @iv_active_system
    INTO @ls_log.

    IF sy-subrc EQ 0.
      ls_log-last_changed_by = sy-uname.
      GET TIME STAMP FIELD  ls_log-last_changed_at.
    ELSE.
      ls_log-fieldname    = lv_logid.
      ls_log-fieldvalue   = lv_value.
      ls_log-activesystem = iv_active_system.
      ls_log-created_by   = ls_log-last_changed_by = sy-uname.
      GET TIME STAMP FIELD  ls_log-created_at.
      ls_log-last_changed_at = ls_log-created_at.
    ENDIF.

    IF ev_error EQ abap_false.
      MODIFY zac_db_single FROM @ls_log.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
