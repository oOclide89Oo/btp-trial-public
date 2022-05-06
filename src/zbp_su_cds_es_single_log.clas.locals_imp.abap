CLASS lhc_ZSU_CDS_ES_SINGLE_LOG DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsu_cds_es_single_log RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zsu_cds_es_single_log.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zsu_cds_es_single_log.

    METHODS read FOR READ
      IMPORTING keys FOR READ zsu_cds_es_single_log RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zsu_cds_es_single_log.

ENDCLASS.

CLASS lhc_ZSU_CDS_ES_SINGLE_LOG IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
* Gestiamo la post
    DATA: lt_fail  TYPE if_abap_behv=>t_failinfo,
          ls_fail  LIKE LINE OF failed-zsu_cds_es_single_log,
          lv_error TYPE abap_boolean,
          lv_msgno TYPE symsgno VALUE 001.

    LOOP AT entities INTO DATA(log).
**        Log logic
      DATA(lv_class_name)  = cl_abap_classdescr=>get_class_name( me ).
      zsu_cl_log_single=>write_log_api( EXPORTING iv_log_id = log-logid
                                           iv_active_system = sy-sysid
                                           iv_value   = log-fieldvalue
                                  IMPORTING ev_error = lv_error ).
       IF lv_error EQ abap_true.
        failed-zsu_cds_es_single_log = VALUE #( ( %key = entities[ 1 ]-%key
                                                    %cid = entities[ 1 ]-%cid ) )  . "chiave della entry che è fallita

        reported-zsu_cds_es_single_log =  VALUE #( (  %cid = entities[ 1 ]-%cid
                                                        %key = entities[ 1 ]-%key
                                                        %msg = new_message( id          = 'ZSU_MSG'
                                                                            number      = lv_msgno
                                                                            severity    = if_abap_behv_message=>severity-error ) ) ).


      endif.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZSU_CDS_ES_SINGLE_LOG DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZSU_CDS_ES_SINGLE_LOG IMPLEMENTATION.

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
