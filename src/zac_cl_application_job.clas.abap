CLASS zac_cl_application_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ts_token,
             timeupdated   TYPE string,
             access_token  TYPE string,
             refresh_token TYPE string,
             token_TYPE    TYPE string,
             scope         TYPE string,
             expires_in    TYPE string,
           END OF ts_token.

    METHODS: add_apj_free_text IMPORTING iv_type     TYPE cl_bali_free_text_setter=>ty_severity
                                         iv_text     TYPE cl_bali_free_text_setter=>ty_text
                                         io_appl_log TYPE REF TO if_bali_log
                                         iv_save     TYPE abap_boolean DEFAULT abap_false
                               RAISING   cx_bali_runtime,
             server_output     EXPORTING es_token    TYPE ts_token
                                         ev_error    TYPE abap_boolean
                               CHANGING  cv_request  TYPE string.

    INTERFACES if_oo_adt_classrun.
    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_application_job IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    et_parameter_def = VALUE #(
      ( selname = 'S_ID'    kind = if_apj_dt_exec_object=>select_option datatype = 'C' length = 10 param_text = 'Task ID'                            changeable_ind = abap_true )
      ( selname = 'P_CLOSE' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Approve task at process ending'      checkbox_ind = abap_true  changeable_ind = abap_true )
      ( selname = 'P_MONIT' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Activate Monitoring for Companies'   checkbox_ind = abap_true  changeable_ind = abap_true )
      ( selname = 'P_MTIME' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Monitoring Period'                   changeable_ind = abap_true )
      ( selname = 'P_UPDT'  kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Update Report Request(in case of Active Monitoring)'               checkbox_ind = abap_true  changeable_ind = abap_true )
    ).

    et_parameter_val = VALUE #(
      ( selname = 'P_CLOSE' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_true )
      ( selname = 'P_MONIT' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_true )
      ( selname = 'P_MTIME' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'U' )
      ( selname = 'P_UPDT' kind = if_apj_dt_exec_object=>parameter      sign = 'I' option = 'EQ' low = abap_true )
    ).
  ENDMETHOD.

  METHOD if_apj_rt_exec_object~execute.
    DATA: lv_approve_task             TYPE abap_boolean,
          lv_activate_monitoring      TYPE abap_boolean,
          lv_activate_monitoring_p    TYPE abap_boolean,
          lv_update_report            TYPE abap_boolean,
          lv_monitoring_period        TYPE string,
          lv_message                  TYPE cl_bali_free_text_setter=>ty_text,
          lv_report_name              TYPE string,
          lv_error                    TYPE abap_boolean,
          lv_qst_description          TYPE string,
          lv_composite_answer         TYPE string,
          lr_task_id                  TYPE RANGE OF string,
          lo_class    TYPE REF TO zac_cl_httpsrvr,
          ls_token    TYPE zac_cl_httpsrvr=>ts_token,
          lv_response TYPE string VALUE 'Pronto a ricevere una response!',
          lv_return   TYPE abap_boolean.

    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'S_ID'.
          APPEND VALUE #( sign   = ls_parameter-sign
                          option = ls_parameter-option
                          low    = ls_parameter-low
                          high   = ls_parameter-high ) TO lr_task_id.
        WHEN 'P_CLOSE'.   lv_approve_task          = ls_parameter-low.
        WHEN 'P_MONIT'.   lv_activate_monitoring_p = ls_parameter-low.
        WHEN 'P_MTIME'.   lv_monitoring_period     = ls_parameter-low.
        WHEN 'P_UPDT'.    lv_update_report         = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    TRY.
        DATA(lo_appl_log) = cl_bali_log=>create_with_header( header = cl_bali_header_setter=>create( object      = 'ZLOGOBJECT2'
                                                                                                     subobject   = 'ZAC_SUBOBJ2'
                                                                                                     external_id = '69420' ) ).

        CLEAR lv_message.
        lv_message = |**************************************************|.
        add_apj_free_text( iv_type     = if_bali_constants=>c_severity_information
                                                iv_text     = lv_message
                                                io_appl_log = lo_appl_log
                                                iv_save     = abap_true ).
        CLEAR lv_message.
        lv_message = |Execution starts - My first Example|.
        add_apj_free_text( iv_type     = if_bali_constants=>c_severity_information
                                                iv_text     = lv_message
                                                io_appl_log = lo_appl_log
                                                iv_save     = abap_true ).
        CLEAR lv_message.
        lv_message = |**************************************************|.
        add_apj_free_text( iv_type     = if_bali_constants=>c_severity_information
                                                iv_text     = lv_message
                                                io_appl_log = lo_appl_log
                                                iv_save     = abap_true ).

        server_output( IMPORTING es_token = ls_token
                                 ev_error = lv_error
                       CHANGING  cv_request = lv_response ).

       IF lv_error = abap_true.
         CLEAR lv_message.
         lv_message = |**************************************************|.
         add_apj_free_text( iv_type     = if_bali_constants=>c_severity_error
                                                  iv_text     = 'Errore'
                                                  io_appl_log = lo_appl_log
                                                  iv_save     = abap_true ).
       ELSE.
         CLEAR lv_message.
         lv_message = |**************************************************|.
         add_apj_free_text( iv_type     = if_bali_constants=>c_severity_status
                                                  iv_text     = 'Successo'
                                                  io_appl_log = lo_appl_log
                                                  iv_save     = abap_true ).
       ENDIF.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD add_apj_free_text.

    DATA lo_log_free_text TYPE REF TO if_bali_free_text_setter.

    lo_log_free_text = cl_bali_free_text_setter=>create( severity = iv_type text = iv_text ).
    lo_log_free_text->set_detail_level( detail_level = '1' ).
    io_appl_log->add_item( item = lo_log_free_text ).

    IF iv_save IS NOT INITIAL.
      cl_bali_log_db=>get_instance( )->save_log( log = io_appl_log assign_to_current_appl_job = abap_true ).
    ENDIF.

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    DATA: lt_param TYPE if_apj_dt_exec_object=>tt_templ_val,
          ls_param LIKE LINE OF lt_param,
          lx_root  TYPE REF TO cx_root.

    me->if_apj_dt_exec_object~get_parameters(
   IMPORTING
     et_parameter_val = lt_param
 ).
    ls_param-kind = if_apj_dt_exec_object=>select_option.
    ls_param-selname = 'S_ID'.
    ls_param-sign   = 'I'.
    ls_param-option = 'EQ'.
    ls_param-low    = 'TSK3434386276'.
    APPEND ls_param TO lt_param.

    TRY.
        me->if_apj_rt_exec_object~execute( it_parameters = lt_param ).
      CATCH cx_root INTO lx_root.
        out->write( lx_root->get_text(  ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD server_output.
    DATA: lo_destination TYPE REF TO if_http_destination,
          lo_client      TYPE REF TO if_web_http_client,
          lo_request     TYPE REF TO if_web_http_request,
          lo_response    TYPE REF TO if_web_http_response,
          lx_exc         TYPE REF TO cx_static_check,
          lo_api         TYPE REF TO zac_cl_customsmd_handler,
          ls_token       TYPE ts_token,
          lv_response    TYPE string,
          lv_url         TYPE string,
          lv_auth        TYPE string,
          lv_content     TYPE string,
          lv_accept      TYPE string,
          lv_encoding    TYPE string,
          lv_connect     TYPE string,
          lv_body        TYPE string,
          lv_error       TYPE abap_boolean.

    CREATE OBJECT lo_api.

    IF lo_api IS BOUND.
      lv_url = lo_api->get_detail_value( EXPORTING iv_customizingid = zac_if_constants_smd=>c_custom_urlkey
                                                   iv_group_name    = zac_if_constants_smd=>c_custom_grp_apikey
                                                   iv_system        = sy-sysid
                                         IMPORTING ev_error         = lv_error ).

      lv_auth = lo_api->get_detail_value( EXPORTING iv_customizingid = zac_if_constants_smd=>c_custom_dtl_ariba_api_key
                                                    iv_group_name    = zac_if_constants_smd=>c_custom_grp_apikey
                                                    iv_system        = sy-sysid
                                          IMPORTING ev_error         = lv_error ).

      lv_accept = lo_api->get_detail_value( EXPORTING iv_customizingid = zac_if_constants_smd=>c_custom_acceptkey
                                                      iv_group_name    = zac_if_constants_smd=>c_custom_grp_apikey
                                                      iv_system        = sy-sysid
                                            IMPORTING ev_error         = lv_error ).

      lv_connect = lo_api->get_detail_value( EXPORTING iv_customizingid = zac_if_constants_smd=>c_custom_connkey
                                                       iv_group_name    = zac_if_constants_smd=>c_custom_grp_apikey
                                                       iv_system        = sy-sysid
                                             IMPORTING ev_error         = lv_error ).

      lv_content = lo_api->get_detail_value( EXPORTING iv_customizingid = zac_if_constants_smd=>c_custom_contentkey
                                                       iv_group_name    = zac_if_constants_smd=>c_custom_grp_apikey
                                                       iv_system        = sy-sysid
                                             IMPORTING ev_error         = lv_error ).

      lv_encoding = lo_api->get_detail_value( EXPORTING iv_customizingid = zac_if_constants_smd=>c_custom_encodekey
                                                        iv_group_name    = zac_if_constants_smd=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                              IMPORTING ev_error         = lv_error ).

      lv_body = lo_api->get_detail_value( EXPORTING iv_customizingid = zac_if_constants_smd=>c_custom_bodykey
                                                    iv_group_name    = zac_if_constants_smd=>c_custom_grp_apikey
                                                    iv_system        = sy-sysid
                                          IMPORTING ev_error         = lv_error ).
    ENDIF.

    CHECK lv_error IS INITIAL.

    TRY.
      CLEAR: ev_error, es_token.

      lo_destination = cl_http_destination_provider=>create_by_url( lv_url ).

      lo_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

      lo_request = lo_client->get_http_request(  ).

      IF lo_request IS BOUND.
    lo_request->set_header_field( i_name = 'Authorization'   i_value = lv_auth ).
    lo_request->set_header_field( i_name = 'Content-Type'    i_value = lv_content ).
    lo_request->set_header_field( i_name = 'Accept'          i_value = lv_accept ).
    lo_request->set_header_field( i_name = 'Connection'      i_value = lv_connect ).
    lo_request->set_header_field( i_name = 'Accept-Encoding' i_value = lv_encoding ).

    lo_request->set_text( lv_body ).

        lo_response = lo_client->execute( if_web_http_client=>post ).

        cv_request = lo_response->get_text(  ).

        IF cv_request CS 'OK' OR cv_request CS '200'.
          ev_error = abap_false.
          zac_cl_log=>write_log( EXPORTING iv_log_id        = 'TEST_SUCCESSO'
                                           iv_active_system = sy-sysid
                                           iv_class_name    = 'ZAC_CL_LOG'
                                           iv_method_name   = 'MAIN'
                                           iv_type          = 'S'
                                           iv_message       = 'SUCCESSO!' ).
        ELSE.
          ev_error = abap_true.
        ENDIF.

        IF ev_error EQ abap_false AND cv_request IS NOT INITIAL.
          xco_cp_json=>data->from_string( cv_request )->write_to( ref #( es_token ) ).
        ENDIF.
      ENDIF.

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO lx_exc.
        zac_cl_log=>write_log( EXPORTING iv_log_id        = 'TEST_FALLITO'
                                         iv_active_system = sy-sysid
                                         iv_class_name    = 'ZAC_CL_LOG'
                                         iv_method_name   = 'MAIN'
                                         iv_type          = 'E'
                                         iv_message       = Conv bapi_msg( lx_exc->get_text( ) ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
