CLASS zsu_cl_log DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: if_oo_adt_classrun.

    CLASS-METHODS: write_log IMPORTING iv_log_id        TYPE zsu_fieldname "Gruppo Log
                                       iv_active_system TYPE zsu_system " Systema -> variabile
                                       iv_class_name    TYPE zsu_classname  "Nome della classe in cui è stato scritto il log
                                       iv_method_name   TYPE zsu_methodname " metodo all'interno della class in cui è stato scritto il log
                                       io_http_request  TYPE REF TO if_web_http_request  OPTIONAL "oggetto request
                                       io_http_response TYPE REF TO if_web_http_response OPTIONAL "oggetto response
                                       iv_message       TYPE bapi_msg   OPTIONAL "messaggio
                                       iv_type          TYPE bapi_mtype OPTIONAL
                             EXPORTING ev_error         TYPE abap_boolean,

      read_log_api IMPORTING iv_log_id       TYPE zrap_fieldname
                             iv_activesystem TYPE zsu_system
                   EXPORTING ev_error        TYPE abap_boolean
                   RETURNING VALUE(rt_log)   TYPE zsu_t_cds_log,

      write_log_api IMPORTING iv_log_id        TYPE zsu_es_fieldname
                              iv_activesystem  TYPE zsu_system
                              iv_request_xml   TYPE zsu_jsonfile    OPTIONAL
                              iv_response_xml  TYPE zsu_jsonfile     OPTIONAL
                              iv_message       TYPE bapi_msg   OPTIONAL
                              iv_type          TYPE bapi_mtype OPTIONAL
                    EXPORTING ev_error         TYPE abap_boolean.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_cl_log IMPLEMENTATION.

  METHOD write_log.

    DATA: ls_log_hdr     TYPE zsu_log_group,
          ls_log_itm     TYPE zsu_log_item,
          lv_json_strlen TYPE i,
          lv_json        TYPE string.

    CLEAR ev_error.
**********************************************************************
* Manage Edit Info

    "controllo che il log esiste nel db

    SELECT SINGLE * FROM zsu_log_group "in questo modo prende la singola riga dal db (rispetto a SELECT *)
    WHERE logid        = @iv_log_id AND
          activesystem = @iv_active_system
    INTO @ls_log_hdr.

    IF sy-subrc EQ 0.                               "controllo che la variabile sy-subrc sia uguale a 0, in questo modo l'operazione è andata a buon fine.

      ls_log_hdr-last_changed_by = sy-uname.                               "chi è che ha modificato il db ( sy-uname prende l'utenza tecnica di quel momento )
      GET TIME STAMP FIELD ls_log_hdr-last_changed_at.                     "prendi la data e ora di modifica

    ELSE.                                                                "Se diverso da zero, non è riuscito a leggere a db quella riga, quindi va creata
      ls_log_hdr-logid = iv_log_id.                                        "chiave1
      ls_log_hdr-activesystem = iv_active_system.                          "chiave2
      ls_log_hdr-created_by = ls_log_hdr-last_changed_by = sy-uname.       "chi ha creato = chi ha cambiato = utenza tecnica
      GET TIME STAMP FIELD ls_log_hdr-created_at.                          "prendo il tempo di creazione
      ls_log_hdr-last_changed_at = ls_log_hdr-created_at.                  "metto nel tempo di modifica il tempo di creazione

      MOVE-CORRESPONDING ls_log_hdr   TO ls_log_itm. "sposta dalla struttura 1 alla 2 i valori dei campi che hanno lo stesso nome
      ls_log_itm-created_by = sy-uname.               "chi ha creato
      GET TIME STAMP FIELD ls_log_itm-created_at.     "tempo di creazione

**********************************************************************
* Andiamo a creare la struttura di dettaglio

      ls_log_itm-class_name  = iv_class_name. "nome classe
      ls_log_itm-method_name = iv_method_name. " nome metodo
      IF io_http_request IS BOUND. "controllo che mi passano l'oggetto
        CLEAR: lv_json_strlen, lv_json_strlen.
        lv_json = io_http_request->get_text( ). " mi prendo il testo
        lv_json_strlen = strlen( lv_json ). "mi conta il numero di caratteri
        IF lv_json_strlen GT 1000. "se la lunghezza della stringa è superiore alla lunghezza massima del db
          lv_json_strlen = 1000. "tronco a 1000 caratteri
        ENDIF.
        ls_log_itm-query_xml = lv_json(lv_json_strlen). "prendi della stringa, i primi 1000 caratteri
      ENDIF.
      IF io_http_response IS BOUND.
        CLEAR: lv_json_strlen, lv_json_strlen.
        lv_json = io_http_response->get_text( ).
        lv_json_strlen = strlen( lv_json ).
        IF lv_json_strlen GT 1000.
          lv_json_strlen = 1000.
        ENDIF.

        ls_log_itm-result_xml = lv_json(lv_json_strlen).
        ls_log_itm-msg        = | { io_http_response->get_status( )-code } { io_http_response->get_status( )-reason } |. "200 OK / 201 CREATED "
        CASE io_http_response->get_status( )-code. "controllo sul codice http
          WHEN '200' OR '201'.
            ls_log_itm-type = if_abap_behv_message=>severity-success. " successo
          WHEN OTHERS.
            ls_log_itm-type = if_abap_behv_message=>severity-error. " error
        ENDCASE.
      ENDIF.
      IF iv_message IS NOT INITIAL.
        ls_log_itm-msg = iv_message.
      ENDIF.
      IF iv_type    IS NOT INITIAL.
        ls_log_itm-type = iv_type.
      ENDIF.

*********************************************************************
* Write Log to DB
      TRY.
          ls_log_itm-loguuid = cl_system_uuid=>create_uuid_x16_static( ). "istruzione di sistema che crea un identificativo univoco di 16 caratteri
        CATCH cx_uuid_error.
          ev_error = abap_true.
      ENDTRY.

      IF ev_error EQ abap_false.
        MODIFY zsu_log_group FROM @ls_log_hdr.
        IF sy-subrc NE 0.
          ev_error = abap_true.
        ENDIF.
        MODIFY zsu_log_item FROM @ls_log_itm.
        IF sy-subrc NE 0.
          ev_error = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    zsu_cl_log=>write_log( EXPORTING iv_log_id        = 'TEST_SILVIO'
                                     iv_active_system = sy-sysid
                                     iv_class_name    = 'ZSU_CL_LOG'
                                     iv_method_name   = 'MAIN'
                                     iv_type          = 'E'
                                     iv_message       = 'TEST SCRITTURA ERRORE' ).

  ENDMETHOD.

  METHOD read_log_api.

    DATA: lt_log_db TYPE STANDARD TABLE OF zsu_log_item,
          ls_log_db TYPE zsu_log_item,
          ls_log    TYPE zsu_cds_unm_log,
          lv_log_id TYPE zrap_fieldname.
    CLEAR ev_error.

*   Mi salvo la chiave di lettura
    lv_log_id = iv_log_id.
    TRANSLATE lv_log_id TO UPPER CASE. " trasformo la stringa in maiuscolo

*   Prendo i dati dalla tabella, (Tutte le entries del gruppo)
    SELECT *  FROM zsu_log_item WHERE    logid        EQ @lv_log_id AND "leggo tutte le entries di quel gruppo
                                        activesystem  EQ @iv_activesystem
                                        INTO TABLE @lt_log_db.

*   Riempio la tabella di tipo cds
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

    DATA: ls_log_hdr     TYPE zsu_log_group,
          ls_log_itm     TYPE zsu_log_item,
          lv_json_strlen TYPE i,
          lv_json        TYPE string,
          lv_logid       TYPE zsu_es_fieldname.

    CLEAR ev_error.
**********************************************************************
* Manage Edit Info

    lv_logid = iv_log_id.
    TRANSLATE lv_logid TO UPPER CASE.

*   Il gruppo logid esiste già, e quindi aggiungo entries e cambio il changed at e by
*   Oppure devo crearlo?
    SELECT SINGLE * FROM zsu_log_group
    WHERE logid        = @lv_logid AND
          activesystem = @iv_activesystem
    INTO @ls_log_hdr.

    IF sy-subrc EQ 0.
      ls_log_hdr-last_changed_by = sy-uname.
      GET TIME STAMP FIELD  ls_log_hdr-last_changed_at.
    ELSE. " se il gruppo non esiste, lo creo
      ls_log_hdr-logid        = lv_logid. " nome gruppo
      ls_log_hdr-activesystem = iv_activesystem. "sistema
      ls_log_hdr-created_by   = ls_log_hdr-last_changed_by = sy-uname. "dati di edit
      GET TIME STAMP FIELD  ls_log_hdr-created_at.
      ls_log_hdr-last_changed_at = ls_log_hdr-created_at.
    ENDIF.

*   Una volta creato il master, vado a scrivere la nuova entry

    MOVE-CORRESPONDING ls_log_hdr   TO ls_log_itm.
    ls_log_itm-created_by = sy-uname.
    GET TIME STAMP FIELD ls_log_itm-created_at.

**********************************************************************
* Compose Log Item Data

    ls_log_itm-class_name  = 'ZSU_CL_LOG'.
    ls_log_itm-method_name = 'WRITE_LOG_API'.
    IF iv_request_xml IS SUPPLIED.
      CLEAR: lv_json_strlen, lv_json_strlen.
      lv_json = iv_request_xml.
      lv_json_strlen = strlen( lv_json ).
      IF lv_json_strlen GT 1000.
        lv_json_strlen = 1000.
      ENDIF.
      ls_log_itm-query_xml = lv_json(lv_json_strlen).
    ENDIF.
    IF iv_response_xml IS SUPPLIED.
      CLEAR: lv_json_strlen, lv_json_strlen.
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

**********************************************************************
* Write Log to DB
    TRY.
        ls_log_itm-loguuid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
        ev_error = abap_true.
    ENDTRY.

    IF ev_error EQ abap_false.
      MODIFY zsu_log_group FROM @ls_log_hdr.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
      MODIFY zsu_log_item FROM @ls_log_itm.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
