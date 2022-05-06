CLASS zac_cl_http_server DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  types: begin of ts_token,
           timeupdated   type string,
           access_token  type string,
           refresh_token type string,
           token_type    type string,
           scope         type string,
           expires_in    type string,
         end of ts_token.

    METHODS server_output IMPORTING       io_out     TYPE REF TO if_oo_adt_classrun_out
                          EXPORTING       es_token   TYPE ts_token
                                          ev_error   TYPE abap_boolean
                          CHANGING        cv_request TYPE string
                          RETURNING VALUE(rv_value)  TYPE abap_boolean.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: set_request IMPORTING io_request        TYPE REF TO if_web_http_request
                                  iv_auth           TYPE string
                                  iv_content        TYPE string
                                  iv_accept         TYPE string
                                  iv_connection     TYPE string
                                  iv_encoding       TYPE string
                                  iv_body           TYPE string
                        RETURNING VALUE(ro_request) TYPE REF TO if_web_http_request,

             set_request_changing IMPORTING iv_auth       TYPE string
                                            iv_content    TYPE string
                                            iv_accept     TYPE string
                                            iv_connection TYPE string
                                            iv_encoding   TYPE string
                                            iv_body       TYPE string
                                   CHANGING co_request TYPE REF TO if_web_http_request.

ENDCLASS.



CLASS zac_cl_http_server IMPLEMENTATION.

  METHOD server_output.

    data: lo_destination type ref to if_http_destination,
          lo_client      type ref to if_web_http_client,
          lo_request     type ref to if_web_http_request,
          lo_response    type ref to if_web_http_response,
          lx_exc         type ref to cx_static_check,
          lo_api         type ref to zac_cl_customizing_handler,
          ls_token       type ts_token,
          lv_response    type string,
          lv_url         type string,
          lv_auth        type string,
          lv_content     type string,
          lv_accept      type string,
          lv_encoding    type string,
          lv_connect     type string,
          lv_body        type string,
          lv_error       type abap_boolean.

    create object lo_api.

    if lo_api is bound.
      lv_url = lo_api->get_detail_value( exporting iv_customizingid = zac_if_constant=>c_custom_dtl_ariba_token
                                                   iv_group_name    = zac_if_constant=>c_custom_grp_endpoint
                                                   iv_system        = sy-sysid
                                         importing ev_error         = lv_error ).

      lv_auth = lo_api->get_detail_value( exporting iv_customizingid = zac_if_constant=>c_custom_dtl_ariba_api_key
                                                    iv_group_name    = zac_if_constant=>c_custom_grp_apikey
                                                    iv_system        = sy-sysid
                                          importing ev_error         = lv_error ).

      lv_accept = lo_api->get_detail_value( exporting iv_customizingid = zac_if_constant=>c_custom_acceptkey
                                                      iv_group_name    = zac_if_constant=>c_custom_grp_apikey
                                                      iv_system        = sy-sysid
                                            importing ev_error         = lv_error ).

      lv_connect = lo_api->get_detail_value( exporting iv_customizingid = zac_if_constant=>c_custom_connkey
                                                       iv_group_name    = zac_if_constant=>c_custom_grp_apikey
                                                       iv_system        = sy-sysid
                                             importing ev_error         = lv_error ).

      lv_content = lo_api->get_detail_value( exporting iv_customizingid = zac_if_constant=>c_custom_contentkey
                                                       iv_group_name    = zac_if_constant=>c_custom_grp_apikey
                                                       iv_system        = sy-sysid
                                             importing ev_error         = lv_error ).

      lv_encoding = lo_api->get_detail_value( exporting iv_customizingid = zac_if_constant=>c_custom_encodekey
                                                        iv_group_name    = zac_if_constant=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                              importing ev_error         = lv_error ).

      lv_body = lo_api->get_detail_value( exporting iv_customizingid = zac_if_constant=>c_custom_bodykey
                                                    iv_group_name    = zac_if_constant=>c_custom_grp_apikey
                                                    iv_system        = sy-sysid
                                          importing ev_error         = lv_error ).
*      LV_AUTH
*LV_ENCODING
    endif.

    check lv_error is initial.

    try.

        CLEAR: ev_error, es_token.

*       create destination
*       lo_destination = cl_http_destination_provider=>create_by_cloud_destination( i_name = 'ARIBA_API_AUTH' i_authn_mode = if_a4c_cp_service=>service_specific ).
        lo_destination = cl_http_destination_provider=>create_by_url( lv_url ).

*       create http client
        lo_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

*       get request
        lo_request = lo_client->get_http_request(  ).

        IF lo_request IS BOUND.

*          lo_request = set_request( EXPORTING io_request    = lo_request
*                                              iv_auth       = zac_if_constant=>c_custom_auth
*                                              iv_accept     = zac_if_constant=>c_custom_accept
*                                              iv_body       = zac_if_constant=>c_custom_body
*                                              iv_connection = zac_if_constant=>c_custom_connection
*                                              iv_content    = zac_if_constant=>c_custom_content
*                                              iv_encoding   = zac_if_constant=>c_custom_encoding ).
          set_request_changing( EXPORTING     iv_auth       = lv_auth "LV_AUTH
                                              iv_accept     = lv_accept "LV_ACCEPT
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
          ELSE.
            ev_error = abap_true.
            rv_value = abap_false.
          ENDIF.

          IF ev_error EQ abap_false AND cv_request IS NOT INITIAL.
            xco_cp_json=>data->from_string( cv_request )->write_to( ref #( es_token ) ).
            io_out->write( es_token ).
          ENDIF.

        ENDIF.

      catch cx_http_dest_provider_error cx_web_http_client_error into lx_exc.

        io_out->write( lx_exc->get_text( ) ).

    endtry.

  ENDMETHOD.

  METHOD set_request.
    DATA lo_request_tmp TYPE REF TO if_web_http_request.

    lo_request_tmp = io_request.

    lo_request_tmp->set_header_field( i_name = 'Authorization'   i_value = iv_auth ).
    lo_request_tmp->set_header_field( i_name = 'Content-Type'    i_value = iv_content ).
    lo_request_tmp->set_header_field( i_name = 'Accept'          i_value = iv_accept ).
    lo_request_tmp->set_header_field( i_name = 'Connection'      i_value = iv_connection ).
    lo_request_tmp->set_header_field( i_name = 'Accept-Encoding' i_value = iv_encoding ).

    lo_request_tmp->set_text( iv_body ).

    ro_request = lo_request_tmp.
  ENDMETHOD.

  METHOD set_request_changing.
    CHECK co_request IS BOUND.

    co_request->set_header_field( i_name = 'Authorization'   i_value = iv_auth ).
    co_request->set_header_field( i_name = 'Content-Type'    i_value = iv_content ).
    co_request->set_header_field( i_name = 'Accept'          i_value = iv_accept ).
    co_request->set_header_field( i_name = 'Connection'      i_value = iv_connection ).
    co_request->set_header_field( i_name = 'Accept-Encoding' i_value = iv_encoding ).

    co_request->set_text( iv_body ).

  ENDMETHOD.

ENDCLASS.
