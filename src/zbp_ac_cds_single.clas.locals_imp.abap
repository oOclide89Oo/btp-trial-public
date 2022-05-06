CLASS lhc_ZAC_CDS_SINGLE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zac_cds_single RESULT result.

ENDCLASS.

CLASS lhc_ZAC_CDS_SINGLE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
