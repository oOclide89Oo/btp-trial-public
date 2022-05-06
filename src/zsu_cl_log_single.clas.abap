CLASS zsu_cl_log_single DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    CLASS-METHODS:  read_log_api    IMPORTING iv_log_id        TYPE zsu_es_hdr-fieldname
                                              iv_active_system TYPE zsu_es_hdr-activesystem
                                    EXPORTING ev_error         TYPE abap_boolean
                                    RETURNING VALUE(rt_log)    TYPE zsu_t_cds_log,

      write_log_api                 IMPORTING iv_log_id        TYPE zsu_es_hdr-fieldname
                                              iv_active_system TYPE zsu_es_hdr-activesystem
                                              iv_value         TYPE zsu_es_fieldvalue
                                    EXPORTING ev_error         TYPE abap_boolean.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_cl_log_single IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.

  METHOD read_log_api.

    DATA: lt_log_db TYPE STANDARD TABLE OF zsu_es_hdr,
          ls_log_db TYPE zsu_es_hdr,
          ls_log    TYPE zsu_cds_es_single_log,
          lv_log_id TYPE zsu_es_fieldname.
    CLEAR ev_error.

    lv_log_id = iv_log_id.
    TRANSLATE lv_log_id TO UPPER CASE.

    SELECT * FROM zsu_es_hdr    WHERE fieldname    EQ @lv_log_id AND
                                      activesystem EQ @iv_active_system
                                      INTO TABLE @lt_log_db.

    IF sy-subrc EQ 0.
      LOOP AT lt_log_db INTO ls_log_db.
        CLEAR: ls_log.
        ls_log-logid  = ls_log_db-fieldname.
        ls_log-fieldvalue = ls_log_db-fieldvalue.
        APPEND ls_log TO rt_log.
      ENDLOOP.
    ELSE.
      ev_error = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD write_log_api.
    DATA: ls_log   TYPE zsu_es_hdr,
          lv_logid TYPE zsu_es_fieldname,
          lv_value TYPE zsu_es_fieldvalue.

    CLEAR ev_error.

    lv_logid = iv_log_id.
    TRANSLATE lv_logid TO UPPER CASE.

    SELECT SINGLE * FROM zsu_es_hdr
    WHERE fieldname  = @lv_logid AND
          activesystem = @iv_active_system
    INTO @ls_log.

    IF sy-subrc EQ 0.
      ls_log-last_changed_by = sy-uname.
      GET TIME STAMP FIELD  ls_log-last_changed_at.
    ELSE.
      ls_log-fieldname    = lv_logid.
      ls_log-fieldvalue   = iv_value.
      ls_log-activesystem = iv_active_system.
      ls_log-created_by   = ls_log-last_changed_by = sy-uname.

      GET TIME STAMP FIELD  ls_log-created_at.
      ls_log-last_changed_at = ls_log-created_at.
    ENDIF.

    IF ev_error EQ abap_false.
      MODIFY zsu_es_hdr FROM @ls_log.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


ENDCLASS.
