CLASS zsu_es_http_client DEFINITION
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
             expires_in    type  string,
             end of ts_token.

  METHODS:   ariba_token   IMPORTING io_out      TYPE REF TO if_oo_adt_classrun_out "IMPORTING SONO I DATI DI INPUT (GLI POSSO USARE SOLO IN LETTURA O SE E UN OGGETTO POSSO USARE SOLO I METODI MA NON MODIFICARLI
                           EXPORTING ev_error    TYPE abap_boolean                  "QUELLO CHE MI SERVE PER CREARE DELLE VARIABILI DI OUTPUT. GLIELE PASSO NELLA CHIAMATA E VENGONO VALORIZZATE NELL'EXPORTING
                                     es_token    TYPE ts_token
                           CHANGING  cv_response TYPE string                        "UN MISTO TRA IMPORTING E EXPORTING. HO UN VALORE CHE PUO ESSERE VALORIZZATO IN INGRESSO MA PUO ESSERE MODIFICABILE IN USCITA RISPETTO AL METODO
                           RETURNING VALUE(rv_value) TYPE abap_boolean.             "IL RITORNO DI UN VALORE

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_es_http_client IMPLEMENTATION.

  METHOD ariba_token.

    DATA: lo_api          type ref to zsu_es_cust_handler,
          lo_destination  type ref to if_http_destination,
          lo_client       type ref to if_web_http_client,
          lo_request      type ref to if_web_http_request,
          lo_response     type ref to if_web_http_response,
          lx_exc          type ref to cx_static_check,
          ls_token        type ts_token,
          lv_response     type string,
          lv_url          type string,
          lv_auth         type string,
          lv_cont         type string,
          lv_accept       type string,
          lv_connection   type string,
          lv_content      type string,
          lv_encoding     type string,
          lv_body         type string,
          lv_error        type abap_boolean.

    CREATE OBJECT lo_api.

    IF lo_api IS BOUND.

        lv_url = lo_api->get_detail_value( EXPORTING    iv_group_name    = zsu_es_constants=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                                        iv_customizingid = zsu_es_constants=>c_custom_urlkey
                                           IMPORTING    ev_error         = lv_error ).

       lv_auth = lo_api->get_detail_value( EXPORTING    iv_group_name    = zsu_es_constants=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                                        iv_customizingid = CONV zsu_es_detail-configurationid( zsu_es_constants=>c_custom_dtl_ariba_api_key )
                                           IMPORTING    ev_error         = lv_error ).


       lv_accept = lo_api->get_detail_value( EXPORTING    iv_group_name    = zsu_es_constants=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                                        iv_customizingid = CONV zsu_es_detail-configurationid( zsu_es_constants=>c_custom_acceptkey )
                                           IMPORTING    ev_error         = lv_error ).

       lv_connection = lo_api->get_detail_value( EXPORTING    iv_group_name    = zsu_es_constants=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                                        iv_customizingid = CONV zsu_es_detail-configurationid( zsu_es_constants=>c_custom_connkey  )
                                           IMPORTING    ev_error         = lv_error ).

       lv_content = lo_api->get_detail_value( EXPORTING    iv_group_name    = zsu_es_constants=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                                        iv_customizingid = CONV zsu_es_detail-configurationid( zsu_es_constants=>c_custom_contentkey )
                                           IMPORTING    ev_error         = lv_error ).

       lv_encoding = lo_api->get_detail_value( EXPORTING    iv_group_name    = zsu_es_constants=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                                        iv_customizingid = CONV zsu_es_detail-configurationid( zsu_es_constants=>c_custom_encodekey )
                                           IMPORTING    ev_error         = lv_error ).

       lv_body = lo_api->get_detail_value( EXPORTING    iv_group_name    = zsu_es_constants=>c_custom_grp_apikey
                                                        iv_system        = sy-sysid
                                                        iv_customizingid = CONV zsu_es_detail-configurationid( zsu_es_constants=>c_custom_bodykey )
                                           IMPORTING    ev_error         = lv_error ).

    ENDIF.

    check lv_error is initial.

*     "FACCIO UN CLEAR DELLE VARIABILI DI EXPORTING, IN modo che il metodo se lo uso in un loop al primo giro lo valorizzo e al secondo giro lo trovo gia valorizzato
    CLEAR: ev_error,es_token.

    try.

*       create destination
*       lo_destination = cl_http_destination_provider=>create_by_cloud_destination( i_name = 'ARIBA_API_AUTH' i_authn_mode = if_a4c_cp_service=>service_specific ).
*       lo_destination = cl_http_destination_provider=>create_by_url( 'https://api-eu.ariba.com/v2/oauth/token' ).
        lo_destination = cl_http_destination_provider=>create_by_url( lv_url ).

*       create http client
        lo_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

*       get request
        lo_request = lo_client->get_http_request(  ).

*       set request headers
        "sempre meglio usare IS BOUND per vedere se l'oggetto è stato creato
        IF lo_request IS BOUND.
        lo_request->set_header_field( i_name = 'Authorization' i_value = lv_auth ). "lv_auth
        lo_request->set_header_field( i_name = 'Content-Type' i_value = lv_content ). "lv_cont
        lo_request->set_header_field( i_name = 'Accept' i_value = lv_accept ).
        lo_request->set_header_field( i_name = 'Connection' i_value = lv_connection ).
        lo_request->set_header_field( i_name = 'Accept-Encoding' i_value = lv_encoding ).

*       set request body
        lo_request->set_text( lv_body ).

*       execute with post
        lo_response = lo_client->execute( if_web_http_client=>post ).
        IF lo_response IS BOUND. "sempre meglio usare IS BOUND per vedere se l'oggetto è stato creato

*       get response body
        lv_response = lo_response->get_text(  ).
        cv_response = lv_response.

        "se la richiesta post ha una risposta positiva:
                IF cv_response CS 'ok' OR cv_response CS '200'.
            "il valore di return è vero e l'errore è falso
                    rv_value = abap_true.
                    ev_error = abap_false.

        "se la richiesta post ha una risposta negativa
                ELSE.
                    rv_value = abap_false.
                    ev_error = abap_true.

                ENDIF.
*           json into abap structure
            xco_cp_json=>data->from_string( lv_response )->write_to( ref #( ls_token ) ).

*           to console
            io_out->write( ls_token ).

             ENDIF.
        ENDIF.



      CATCH cx_http_dest_provider_error cx_web_http_client_error into lx_exc.

        io_out->write( lx_exc->get_text( ) ).

    ENDTRY.



  ENDMETHOD.

ENDCLASS.
