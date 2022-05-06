CLASS LHC_AC_MSTR_S DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR AC_MSTR_S
        RESULT result,
      SELECTTRANSPORT FOR MODIFY
        IMPORTING
          KEYS FOR ACTION AC_MSTR_S~selectTransport
        RESULT result.
ENDCLASS.

CLASS LHC_AC_MSTR_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
  READ ENTITIES OF ZI_CORSO_AC_MSTR_S IN LOCAL MODE
  ENTITY AC_MSTR_S
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(all).
  result = VALUE #( ( %tky = all[ 1 ]-%tky
                      %action-selecttransport = COND #( WHEN all[ 1 ]-%is_draft = if_abap_behv=>mk-on THEN if_abap_behv=>mk-off
                                                        ELSE if_abap_behv=>mk-on  )   ) ).
  ENDMETHOD.
  METHOD SELECTTRANSPORT.
  MODIFY ENTITIES OF ZI_CORSO_AC_MSTR_S IN LOCAL MODE
  ENTITY AC_MSTR_S
  UPDATE FIELDS ( request hidetransport )
  WITH VALUE #( FOR key IN keys
                 ( %tky         = key-%tky
                   request = key-%param-transportrequestid
                   hidetransport = abap_false ) )
      FAILED failed
      REPORTED reported.


      READ ENTITIES OF ZI_CORSO_AC_MSTR_S  IN LOCAL MODE
        ENTITY AC_MSTR_S
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(singletons).
      result = VALUE #( FOR singleton IN singletons
                          ( %tky   = singleton-%tky
                            %param = singleton ) ).
  ENDMETHOD.
ENDCLASS.
CLASS LCL_SAVER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      CLEANUP_FINALIZE REDEFINITION,
      SAVE_MODIFIED REDEFINITION.
ENDCLASS.

CLASS LCL_SAVER IMPLEMENTATION.
  METHOD CLEANUP_FINALIZE.
  ENDMETHOD.
  METHOD SAVE_MODIFIED.
  READ TABLE update-AC_MSTR_S INDEX 1 INTO DATA(all).
  SELECT SINGLE request FROM ZCORSO_AC_MST01D INTO @DATA(request).
  DATA(result) = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                                                          ( entity = 'AC_MSTR' table = 'ZAC_RAP_MASTER' )
                                                                          ( entity = 'AC_DTL' table = 'ZAC_RAP_DETAIL' )
                                                                            ) ).
  IF all-request IS NOT INITIAL.
    result->record_changes(
      EXPORTING
        transport_request = request
        create            = REF #( create )
        update            = REF #( update )
        delete            = REF #( delete )
    ).
  ENDIF.
  ENDMETHOD.
ENDCLASS.
