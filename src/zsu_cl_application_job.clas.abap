CLASS zsu_cl_application_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*   Per scrivere i messaggi nell’oggetto log, è necessario definire la severity del messaggio (information, error, warnig etc)
*   il messaggio stesso e l’eventuale livello di dettaglio.
*   Un possibile code snippet per un metodo di scrittura log è il seguente:

      types: begin of ts_token,
             timeupdated   type string,
             access_token  type string,
             refresh_token type string,
             token_type    type string,
             scope         type string,
             expires_in    type  string,
             end of ts_token.

    METHODS: add_apj_free_text IMPORTING iv_type     TYPE cl_bali_free_text_setter=>ty_severity "S successo, W warning, E errore
                                         iv_text     TYPE cl_bali_free_text_setter=>ty_text " messaggio
                                         io_appl_log TYPE REF TO if_bali_log "oggetto che creaiamo nel nostro execute
                                         iv_save     TYPE abap_boolean DEFAULT abap_false " flag per dire se salvare o meno
                               RAISING   cx_bali_runtime,

             server_output
                              EXPORTING ev_error    TYPE abap_boolean
                                        es_token    TYPE ts_token
                              CHANGING  cv_response TYPE string
                              RETURNING VALUE(rv_value) TYPE abap_boolean.


    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_cl_application_job IMPLEMENTATION.



  METHOD if_apj_dt_exec_object~get_parameters. "tilde si usa per metodo interfaccia
    "L’interfaccia IF_APJ_DT_EXEC_OBJECT contiene, oltre alla definizione di alcuni data type, la definizione del metodo GET_PARAMETERS,
    "utilizzato per andare a definire i parametri di input del nostro JOB.

    "La prima tabella di exporting (et_parameter_def) definisce la tipologia dei parametri di input,
    "tra cui il selname (max 8 characters) il tipo (parameter/select option), datatype, lunghezza, testo del parametro ecc
        et_parameter_def = VALUE #(
      ( selname = 'S_ID'    kind = if_apj_dt_exec_object=>select_option datatype = 'C' length = 10 param_text = 'Task ID'                            changeable_ind = abap_true )
      ( selname = 'P_CLOSE' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Approve task at process ending'      checkbox_ind = abap_true  changeable_ind = abap_true )
      ( selname = 'P_MONIT' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Activate Monitoring for Companies'   checkbox_ind = abap_true  changeable_ind = abap_true )
      ( selname = 'P_MTIME' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Monitoring Period'                   changeable_ind = abap_true )
      ( selname = 'P_UPDT'  kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Update Report Request(in case of Active Monitoring)'               checkbox_ind = abap_true  changeable_ind = abap_true )
    ).

    "La seconda tabella invece (et_parameter_val) serve a definire i valori di default per i parametri definiti al punto prima.
    et_parameter_val = VALUE #(
      ( selname = 'P_CLOSE' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_true )
      ( selname = 'P_MONIT' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_true )
      ( selname = 'P_MTIME' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'U' )
      ( selname = 'P_UPDT' kind = if_apj_dt_exec_object=>parameter      sign = 'I' option = 'EQ' low = abap_true )
    ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
       "L’interfaccia IF_APJ_RT_EXEC_OBJECT, invece, contiene, oltre alla definizione di ulteriori data type,
       "la definizione del metodo EXECUTE, utilizzato per scrivere la business logic del nostro JOB.

      DATA: lv_approve_task           TYPE abap_boolean,
          lv_activate_monitoring      TYPE abap_boolean,
          lv_activate_monitoring_p    TYPE abap_boolean,
          lv_update_report            TYPE abap_boolean,
          lv_monitoring_period        TYPE string,
          lv_message                  TYPE cl_bali_free_text_setter=>ty_text,
          lv_report_name              TYPE string,
          lv_error                    TYPE abap_boolean,
          lv_qst_description          TYPE string,
          lv_composite_answer         TYPE string,
          lr_task_id                  TYPE RANGE OF string, "tabella che ha una struttura con SIGN, OPTION, LOW , HIGH. In particolare ha come "tipo" dei campi low e high il tipo definito, in questo caso string
          lo_class    TYPE REF TO zsu_es_http_client,
          ls_token    TYPE zsu_es_http_client=>ts_token ,
          lv_response TYPE string VALUE 'Pronto a ricevere una response!',
          lv_return   TYPE abap_boolean.

    " Getting the actual parameter values
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'S_ID'.
          APPEND VALUE #( sign   = ls_parameter-sign
                          option = ls_parameter-option
                          low    = ls_parameter-low
                          high   = ls_parameter-high ) TO lr_task_id.
        WHEN 'P_CLOSE'.   lv_approve_task      = ls_parameter-low.
        WHEN 'P_MONIT'.   lv_activate_monitoring_p  = ls_parameter-low.
        WHEN 'P_MTIME'.   lv_monitoring_period = ls_parameter-low.
        WHEN 'P_UPDT'.    lv_update_report     = ls_parameter-low.
      ENDCASE.
    ENDLOOP.
    TRY.
        DATA(lo_appl_log) = cl_bali_log=>create_with_header(    header = cl_bali_header_setter=>create( object      = 'ZCORSO_LOG'
                                                                                                        subobject   = 'ZCORSO_LOG_SUBJ1'
                                                                                                        external_id = 'External ID' ) ).
*
        IF lo_appl_log IS BOUND.

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

      server_output(             IMPORTING es_token   = ls_token
                                           ev_error   = lv_error
                                 CHANGING  cv_response = lv_response ).

      IF lv_error EQ abap_true.
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

        ENDIF.

    CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

  METHOD server_output.
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


             ENDIF.
        ENDIF.

      CATCH cx_http_dest_provider_error cx_web_http_client_error into lx_exc.

    ENDTRY.
  ENDMETHOD.

  METHOD add_apj_free_text.

    DATA lo_log_free_text TYPE REF TO if_bali_free_text_setter.

    lo_log_free_text = cl_bali_free_text_setter=>create( severity = iv_type text = iv_text ). "creo un oggetto testo, con tipo iv_type (S, W, E) e con messaggio iv_text
    lo_log_free_text->set_detail_level( detail_level = '1' ). "messaggio ha un solo livello
    io_appl_log->add_item( item = lo_log_free_text ). "aggiungo all'oggetto log l'oggetto text che ho creato nei 2 punti prima

    IF iv_save IS NOT INITIAL. " se voglio salvare -> iv_save a true
      cl_bali_log_db=>get_instance( )->save_log( log = io_appl_log assign_to_current_appl_job = abap_true ).
    ENDIF.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
*   Poiché successivamente allo scheduling il job lavora in background,
*   l’unico modo per debuggare è chiamare esplicitamente il metodo execute in una classe runnable:

    DATA: lt_param   TYPE if_apj_dt_exec_object=>tt_templ_val,
          ls_param   LIKE LINE OF lt_param,
          lx_root    TYPE REF TO cx_root.

*   1) prendo i parametri dal metodo get
    me->if_apj_dt_exec_object~get_parameters(   "me-> è equivalente al this->
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



ENDCLASS.
