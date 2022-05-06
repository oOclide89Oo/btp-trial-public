CLASS zac_cl_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: if_oo_adt_classrun.

    CLASS-METHODS: write_log IMPORTING iv_log_id        TYPE zac_fieldname
                                       iv_active_system TYPE zac_system
                                       iv_class_name    TYPE zac_classname
                                       iv_method_name   TYPE zac_methodname
                                       io_http_request  TYPE REF TO if_web_http_request  OPTIONAL
                                       io_http_response TYPE REF TO if_web_http_response OPTIONAL
                                       iv_message       TYPE bapi_msg                    OPTIONAL
                                       iv_type          TYPE bapi_mtype                  OPTIONAL
                             EXPORTING ev_error         TYPE abap_boolean,
                   read_log_api IMPORTING iv_log_id        TYPE zac_fieldname
                                          iv_active_system TYPE zac_db_log_hdr-activesystem
                                EXPORTING ev_error         TYPE abap_boolean
                                RETURNING VALUE(rt_log)    TYPE zac_t_cds_log,
                   write_log_api IMPORTING iv_log_id        TYPE zac_fieldname
                                           iv_active_system TYPE zac_system
                                           iv_request_xml   TYPE zac_jsonfile OPTIONAL
                                           iv_response_xml  TYPE zac_jsonfile OPTIONAL
                                           iv_message       TYPE bapi_msg     OPTIONAL
                                           iv_type          TYPE bapi_mtype   OPTIONAL
                                 EXPORTING ev_error         TYPE abap_boolean.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_log IMPLEMENTATION.

  METHOD write_log.
    DATA: ls_log_hdr     TYPE zac_db_log_hdr,
          ls_log_itm     TYPE zac_db_log_itm,
          lv_json_strlen TYPE i,
          lv_json        TYPE string.

    CLEAR ev_error.

    SELECT SINGLE  * FROM zac_db_log_hdr
    WHERE logid        = @iv_log_id AND
          activesystem = @iv_active_system
    INTO  @ls_log_hdr.

    IF sy-subrc EQ 0.
      ls_log_hdr-last_changed_by = sy-uname.
      GET TIME STAMP FIELD  ls_log_hdr-last_changed_at.     "salva un timestamp all'interno dell'attributo
    ELSE.
      ls_log_hdr-logid        = iv_log_id.
      ls_log_hdr-activesystem = iv_active_system.
      ls_log_hdr-created_by   = ls_log_hdr-last_changed_by = sy-uname.
      GET TIME STAMP FIELD  ls_log_hdr-created_at.
      ls_log_hdr-last_changed_at = ls_log_hdr-created_at.
    ENDIF.

    MOVE-CORRESPONDING ls_log_hdr   TO ls_log_itm.
    ls_log_itm-created_by = sy-uname.
    GET TIME STAMP FIELD ls_log_itm-created_at.

    ls_log_itm-class_name  = iv_class_name.
    ls_log_itm-method_name = iv_method_name.
    IF io_http_request IS BOUND.
      CLEAR: lv_json_strlen.
      lv_json = io_http_request->get_text( ).
      lv_json_strlen = strlen( lv_json ).
      IF lv_json_strlen GT 1000. "GT = greater than
        lv_json_strlen = 1000. "tronca ai primi 1000 caratteri
      ENDIF.
      ls_log_itm-query_xml = lv_json(lv_json_strlen).
    ENDIF.

    IF io_http_response IS BOUND.
      CLEAR: lv_json_strlen.
      lv_json = io_http_response->get_text( ).
      lv_json_strlen = strlen( lv_json ).
      IF lv_json_strlen GT 1000.
        lv_json_strlen = 1000.
      ENDIF.
      ls_log_itm-result_xml = lv_json(lv_json_strlen).
      ls_log_itm-msg        = | { io_http_response->get_status( )-code } { io_http_response->get_status( )-reason } |.
      CASE io_http_response->get_status( )-code.
        WHEN '200' OR '201'.
          ls_log_itm-type = if_abap_behv_message=>severity-success.
        WHEN OTHERS.
          ls_log_itm-type = if_abap_behv_message=>severity-error.
      ENDCASE.
    ENDIF.

    IF iv_message IS NOT INITIAL.
      ls_log_itm-msg = iv_message.
    ENDIF.
    IF iv_type    IS NOT INITIAL.
      ls_log_itm-type = iv_type.
    ENDIF.

    TRY.
        ls_log_itm-loguuid = cl_system_uuid=>create_uuid_x16_static( ). "istruzione di sistema che crea un identificativo univoco di 16 caratteri
      CATCH cx_uuid_error.
        ev_error = abap_true.
    ENDTRY.

    IF ev_error EQ abap_false.
      MODIFY zac_db_log_hdr FROM @ls_log_hdr.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
      MODIFY zac_db_log_itm FROM @ls_log_itm.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    zac_cl_log=>write_log( EXPORTING iv_log_id        = 'TEST_ANDREA'
                                     iv_active_system = sy-sysid
                                     iv_class_name    = 'ZAC_CL_LOG'
                                     iv_method_name   = 'MAIN'
                                     iv_type          = 'S'
                                     iv_message       = 'SUCCESSO!' ).

  ENDMETHOD.

  METHOD read_log_api.
    DATA: lt_log_db TYPE STANDARD TABLE OF zac_db_log_itm, "TYPE zac_t_log_itm,
          ls_log_db TYPE zac_db_log_itm,                   "TYPE zac_s_log_itm,
          ls_log    TYPE zac_cds_unm_log,
          lv_log_id TYPE zac_fieldname.
    CLEAR ev_error.

    lv_log_id = iv_log_id.
    TRANSLATE lv_log_id TO UPPER CASE.

    SELECT * FROM zac_db_log_itm WHERE logid        EQ @lv_log_id AND
                                       activesystem EQ @iv_active_system
                                       INTO TABLE @lt_log_db.

    IF sy-subrc EQ 0.
      LOOP AT lt_log_db INTO ls_log_db.
        CLEAR: ls_log.
        ls_log-logid      = ls_log_db-logid.
        ls_log-type       = ls_log_db-type.
        ls_log-msg        = ls_log_db-msg.
        ls_log-result_xml = ls_log_db-result_xml.
        ls_log-query_xml  = ls_log_db-query_xml.
        APPEND ls_log TO rt_log.
      ENDLOOP.
    ELSE.
      ev_error = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD write_log_api.
    DATA: ls_log_hdr     TYPE zac_db_log_hdr,
          ls_log_itm     TYPE zac_db_log_itm,
          lv_json_strlen TYPE i,
          lv_json        TYPE string,
          lv_logid       TYPE zac_fieldname.

    CLEAR ev_error.

    lv_logid = iv_log_id.
    TRANSLATE lv_logid TO UPPER CASE.

    SELECT SINGLE * FROM zac_db_log_hdr
    WHERE logid        = @lv_logid AND
          activesystem = @iv_active_system
    INTO @ls_log_hdr.

    IF sy-subrc EQ 0.
      ls_log_hdr-last_changed_by = sy-uname.
      GET TIME STAMP FIELD  ls_log_hdr-last_changed_at.
    ELSE.
      ls_log_hdr-logid        = lv_logid.
      ls_log_hdr-activesystem = iv_active_system.
      ls_log_hdr-created_by   = ls_log_hdr-last_changed_by = sy-uname.
      GET TIME STAMP FIELD  ls_log_hdr-created_at.
      ls_log_hdr-last_changed_at = ls_log_hdr-created_at.
    ENDIF.

    MOVE-CORRESPONDING ls_log_hdr TO ls_log_itm.
    ls_log_itm-created_by = sy-uname.
    GET TIME STAMP FIELD ls_log_itm-created_at.

    ls_log_itm-class_name  = 'ZAC_CL_LOG'.
    ls_log_itm-method_name = 'WRITE_LOG_API'.

    IF iv_request_xml IS SUPPLIED.
      CLEAR: lv_json_strlen.
      lv_json = iv_request_xml.
      lv_json_strlen = strlen( lv_json ).
      IF lv_json_strlen GT 1000.
        lv_json_strlen = 1000.
      ENDIF.
      ls_log_itm-query_xml = lv_json(lv_json_strlen).
    ENDIF.
    IF iv_response_xml IS SUPPLIED.
      CLEAR: lv_json_strlen.
      lv_json = iv_response_xml.
      lv_json_strlen = strlen( lv_json ).
      IF lv_json_strlen GT 1000.
        lv_json_strlen = 1000.
      ENDIF.
      ls_log_itm-result_xml = lv_json(lv_json_strlen).
    ENDIF.
    IF iv_message IS NOT INITIAL.
      ls_log_itm-msg = iv_message.
    ENDIF.
    IF iv_type    IS NOT INITIAL.
      ls_log_itm-type = iv_type.
    ENDIF.

    TRY.
        ls_log_itm-loguuid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
        ev_error = abap_true.
    ENDTRY.

    IF ev_error EQ abap_false.
      MODIFY zac_db_log_hdr FROM @ls_log_hdr.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
      MODIFY zac_db_log_itm FROM @ls_log_itm.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
