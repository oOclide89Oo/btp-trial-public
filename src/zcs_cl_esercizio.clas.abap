CLASS zcs_cl_esercizio DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_token,
             timeupdated   TYPE string,
             access_token  TYPE string,
             refresh_token TYPE string,
             token_type    TYPE string,
             scope         TYPE string,
             expires_in    TYPE  string,
           END OF ts_token.


    METHODS: ariba_token IMPORTING io_out          TYPE REF TO if_oo_adt_classrun_out "dati di input del metodo DATI NON MODIFICABILI (Usati solo in lettura)
                         EXPORTING ev_error        TYPE abap_boolean "dati di output farne sempre la clear all'inizio del metodo
                                   es_token        TYPE ts_token
                         CHANGING  cv_response     TYPE string "Valore di changing E' già valorizzato da
                         RETURNING VALUE(rv_value) TYPE abap_boolean,

      ariba_get_approvables IMPORTING iv_access_token TYPE ts_token-access_token
                                      iv_realm        TYPE string
                                      iv_user         TYPE string
                                      iv_password     TYPE string
                                      iv_api_key      TYPE string
                            EXPORTING ev_error        TYPE abap_boolean.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcs_cl_esercizio IMPLEMENTATION.

  METHOD ariba_token.

    DATA: lo_destination TYPE REF TO if_http_destination,
          lo_client      TYPE REF TO if_web_http_client,
          lo_request     TYPE REF TO if_web_http_request,
          lo_response    TYPE REF TO if_web_http_response,
          lx_exc         TYPE REF TO cx_static_check,
          ls_token       TYPE ts_token,
          lv_response    TYPE string.
* FARE SEMPRE LA CLEAR DELLE VARIABILI DI EXPORTING
    CLEAR: ev_error,es_token.


    TRY.

*       create destination
*       lo_destination = cl_http_destination_provider=>create_by_cloud_destination( i_name = 'ARIBA_API_AUTH' i_authn_mode = if_a4c_cp_service=>service_specific ).
        lo_destination = cl_http_destination_provider=>create_by_url( 'https://api-eu.ariba.com/v2/oauth/token' ).

*       create http client
        lo_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

*       get request
        lo_request = lo_client->get_http_request(  ).

*       set request headers
        IF lo_request IS BOUND.
          lo_request->set_header_field( i_name = 'Authorization' i_value = 'Basic NDA5ZmUyYmEtNDYwYi00NGU2LWEyYzktOGRiNThkNjQ1NDEzOlhiOVBqbndJUkhhb0hGNVZCbUZlUTU4TUs3VHdOZnZy' ).
          lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/x-www-form-urlencoded' ).
          lo_request->set_header_field( i_name = 'Accept' i_value = '*/*' ).
          lo_request->set_header_field( i_name = 'Connection' i_value = 'keep-alive' ).
          lo_request->set_header_field( i_name = 'Accept-Encoding' i_value = 'gzip, deflate, br' ).

*       set request body
          lo_request->set_text( 'grant_type=openapi_2lo' ).

*       execute with post
          lo_response = lo_client->execute( if_web_http_client=>post ).

*       get response body
          lv_response = lo_response->get_text(  ).
          cv_response = lv_response.

          IF lv_response CS 'OK' OR lv_response CS '200'.
            rv_value = abap_true.
            ev_error = abap_false.
            zcs_cl_log=>write_log( EXPORTING iv_log_id = 'ARIBA_TOKEN'
                                     iv_active_system  = sy-sysid
                                     iv_class_name     = 'ZCS_CL_ESERCIZIO'
                                     iv_method_name    = 'ARIBA_TOKEN'
                                     iv_type           = 'S'
                                     iv_message        = 'SONO RIUSCITO A CREARE IL TOKEN'
                                     io_http_request   = lo_request
                                     io_http_response  = lo_response ).
          ELSE.
            rv_value = abap_false.
            ev_error = abap_true.
            zcs_cl_log=>write_log( EXPORTING iv_log_id = 'ARIBA_TOKEN'
                                     iv_active_system  = sy-sysid
                                     iv_class_name     = 'ZCS_CL_ESERCIZIO'
                                     iv_method_name    = 'ARIBA_TOKEN'
                                     iv_type           = 'E'
                                     iv_message        = 'NON SONO RIUSCITO A CREARE IL TOKEN'
                                     io_http_request   = lo_request
                                     io_http_response  = lo_response ).
          ENDIF.


          IF ev_error EQ abap_false.

*       json into abap structure
            xco_cp_json=>data->from_string( lv_response )->write_to( REF #( es_token ) ).
**********************************************************************
* Access Token è il token da usare nelle succesive chiamate
*es_token-access_token
**********************************************************************

*       to console
            io_out->write( es_token ).
          ENDIF.

        ENDIF.

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO lx_exc.

        io_out->write( lx_exc->get_text( ) ).

    ENDTRY.
  ENDMETHOD.

  METHOD ariba_get_approvables.
    DATA: lo_destination TYPE REF TO if_http_destination,
          lo_client      TYPE REF TO if_web_http_client,
          lo_request     TYPE REF TO if_web_http_request,
          lo_response    TYPE REF TO if_web_http_response,
          lx_exc         TYPE REF TO cx_static_check,
          ls_token       TYPE ts_token,
          lv_response    TYPE string,
          lv_url         TYPE string.
* FARE SEMPRE LA CLEAR DELLE VARIABILI DI EXPORTING
    CLEAR: ev_error.
**********************************************************************
* Prendiamo l'url del servizio destinazione e sostituiamo le variabili che "cambiano"
    lv_url = 'https://openapi.ariba.com/api/sourcing-approval/v2/prod/pendingApprovables?realm=$REALM$&user=$USER$&passwordAdapter=$PASSWORD$'.
* Per sostituire una sottostringa nella stringa usiamo replace
    REPLACE ALL OCCURRENCES OF '$REALM$'    IN lv_url WITH iv_realm.
    REPLACE ALL OCCURRENCES OF '$USER$'     IN lv_url WITH iv_user.
    REPLACE ALL OCCURRENCES OF '$PASSWORD$' IN lv_url WITH iv_password.
**********************************************************************
    TRY.

*       create destination
*       lo_destination = cl_http_destination_provider=>create_by_cloud_destination( i_name = 'ARIBA_API_AUTH' i_authn_mode = if_a4c_cp_service=>service_specific ).
        lo_destination = cl_http_destination_provider=>create_by_url( lv_url ).

*       create http client
        lo_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

*       get request
        lo_request = lo_client->get_http_request(  ).

*       set request headers
        IF lo_request IS BOUND.
**********************************************************************
*  SET BAREAR TOKEN
**********************************************************************
          lo_request->set_authorization_bearer( EXPORTING i_bearer = iv_access_token ).

**********************************************************************
*  SET HEADERS

          lo_request->set_header_field( i_name = 'apiKey' i_value = iv_api_key ).
*          lo_request->set_header_field( i_name = 'Content-Type' i_value = 'application/x-www-form-urlencoded' ).
*          lo_request->set_header_field( i_name = 'Accept' i_value = '*/*' ).
*          lo_request->set_header_field( i_name = 'Connection' i_value = 'keep-alive' ).
*          lo_request->set_header_field( i_name = 'Accept-Encoding' i_value = 'gzip, deflate, br' ).

*       execute with post
          lo_response = lo_client->execute( if_web_http_client=>get ).

*       get response body
          lv_response = lo_response->get_text(  ).

          IF lv_response CS '200'.
            ev_error = abap_false.
          ELSE.
            ev_error = abap_true.
          ENDIF.

        ENDIF.

      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO lx_exc.


    ENDTRY.

  ENDMETHOD.

ENDCLASS.
