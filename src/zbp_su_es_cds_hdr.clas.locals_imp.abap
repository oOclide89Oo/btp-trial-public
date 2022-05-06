CLASS lhc_ZSU_ES_CDS_HDR DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsu_es_cds_hdr RESULT result.

ENDCLASS.

CLASS lhc_ZSU_ES_CDS_HDR IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
