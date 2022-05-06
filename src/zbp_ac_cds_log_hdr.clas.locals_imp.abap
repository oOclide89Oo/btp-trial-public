CLASS lhc_ZAC_CDS_LOG_HDR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zac_cds_log_hdr RESULT result.

ENDCLASS.

CLASS lhc_ZAC_CDS_LOG_HDR IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
