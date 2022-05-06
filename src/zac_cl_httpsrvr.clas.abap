CLASS zac_cl_httpsrvr DEFINITION
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

    METHODS server_output IMPORTING       io_out     TYPE REF TO if_oo_adt_classrun_out
                          EXPORTING       es_token   TYPE ts_token
                                          ev_error   TYPE abap_boolean
                          CHANGING        cv_request TYPE string
                          RETURNING VALUE(rv_value)  TYPE abap_boolean.
    METHODS: set_request IMPORTING iv_auth       TYPE string
                                   iv_content    TYPE string
                                   iv_accept     TYPE string
                                   iv_connection TYPE string
                                   iv_encoding   TYPE string
                                   iv_body       TYPE string
                         CHANGING co_request TYPE REF TO if_web_http_request.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_httpsrvr IMPLEMENTATION.
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
        set_request( EXPORTING     iv_auth       = lv_auth
                                   iv_accept     = lv_accept
                                   iv_body       = lv_body
                                   iv_connection = lv_connect
                                   iv_content    = lv_content
                                   iv_encoding   = lv_encoding
                     CHANGING      co_request    = lo_request ).

        lo_response = lo_client->execute( if_web_http_client=>post ).

        cv_request = lo_response->get_text(  ).

        IF cv_request CS 'OK' OR cv_request CS '200'.
          rv_value = abap_true.
          ev_error = abap_false.
          zac_cl_log=>write_log( EXPORTING iv_log_id        = 'TEST_SUCCESSO'
                                           iv_active_system = sy-sysid
                                           iv_class_name    = 'ZAC_CL_LOG'
                                           iv_method_name   = 'MAIN'
                                           iv_type          = 'S'
                                           iv_message       = 'SUCCESSO!' ). "-> add_apj_free_text()
        ELSE.
          ev_error = abap_true.
          rv_value = abap_false.
        ENDIF.

        IF ev_error EQ abap_false AND cv_request IS NOT INITIAL.
          xco_cp_json=>data->from_string( cv_request )->write_to( ref #( es_token ) ).
          io_out->write( es_token ).
        ENDIF.
      ENDIF.

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO lx_exc.
        io_out->write( lx_exc->get_text( ) ). "cancellate
        zac_cl_log=>write_log( EXPORTING iv_log_id        = 'TEST_FALLITO'
                                         iv_active_system = sy-sysid
                                         iv_class_name    = 'ZAC_CL_LOG'
                                         iv_method_name   = 'MAIN'
                                         iv_type          = 'E'
                                         iv_message       = Conv bapi_msg( lx_exc->get_text( ) ) ). "-> add_apj_free_text()
    ENDTRY.
  ENDMETHOD.

  METHOD set_request.
    CHECK co_request IS BOUND.

    co_request->set_header_field( i_name = 'Authorization'   i_value = iv_auth ).
    co_request->set_header_field( i_name = 'Content-Type'    i_value = iv_content ).
    co_request->set_header_field( i_name = 'Accept'          i_value = iv_accept ).
    co_request->set_header_field( i_name = 'Connection'      i_value = iv_connection ).
    co_request->set_header_field( i_name = 'Accept-Encoding' i_value = iv_encoding ).

    co_request->set_text( iv_body ).
  ENDMETHOD.

ENDCLASS.
