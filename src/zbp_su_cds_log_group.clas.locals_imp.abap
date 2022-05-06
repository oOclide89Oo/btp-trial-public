CLASS lhc_ZSU_CDS_LOG_GROUP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsu_cds_log_group RESULT result.

ENDCLASS.

CLASS lhc_ZSU_CDS_LOG_GROUP IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
