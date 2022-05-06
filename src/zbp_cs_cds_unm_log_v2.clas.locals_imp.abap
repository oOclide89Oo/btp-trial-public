CLASS lhc_ZCS_CDS_UNM_LOG_V2 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcs_cds_unm_log_v2 RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zcs_cds_unm_log_v2.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcs_cds_unm_log_v2.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcs_cds_unm_log_v2 RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zcs_cds_unm_log_v2.

ENDCLASS.

CLASS lhc_ZCS_CDS_UNM_LOG_V2 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
**********************************************************************
* Gestiamo la post
    DATA: lt_fail  TYPE if_abap_behv=>t_failinfo,
          ls_fail  LIKE LINE OF failed-zcs_cds_unm_log_v2,
          lv_error TYPE abap_boolean,
          lv_msgno TYPE symsgno VALUE 001.

    LOOP AT entities INTO DATA(log).
**        Log logic
      DATA(lv_class_name)  = cl_abap_classdescr=>get_class_name( me ).
      zcs_cl_log=>write_log_api( EXPORTING iv_log_id = log-logid
                                           iv_active_system = sy-sysid
                                           iv_message = log-msg
                                           iv_request_xml =  log-query_xml
                                           iv_response_xml = log-result_xml
                                           iv_type         = log-type
                                  IMPORTING ev_error = lv_error ).
      IF lv_error EQ abap_true.
        failed-zcs_cds_unm_log_v2 = VALUE #( ( %key = entities[ 1 ]-%key
                                                    %cid = entities[ 1 ]-%cid ) )  . "chiave della entry che è fallita

        reported-zcs_cds_unm_log_v2 =  VALUE #( (  %cid = entities[ 1 ]-%cid
                                                        %key = entities[ 1 ]-%key
                                                        %msg = new_message( id          = 'ZRAP_MSG_CS'
                                                                            number      = lv_msgno
                                                                            severity    = if_abap_behv_message=>severity-error ) ) ).


      endif.
    ENDLOOP.
**********************************************************************


  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCS_CDS_UNM_LOG_V2 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCS_CDS_UNM_LOG_V2 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
