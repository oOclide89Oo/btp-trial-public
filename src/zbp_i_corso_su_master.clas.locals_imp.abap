CLASS LHC_SU_MASTER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VAL_TRANSPORT FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR  SU_MASTER~val_transport .
ENDCLASS.

CLASS LHC_SU_MASTER IMPLEMENTATION.
  METHOD VAL_TRANSPORT.
  DATA change TYPE REQUEST FOR CHANGE ZI_CORSO_SU_MASTER_S.
  SELECT SINGLE request FROM ZCORSO_SU_MAS01D INTO @DATA(request).
  DATA(rap_transport_api) = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                               ( entity = 'SU_MASTER' table = 'ZRAP_SU_DB' )
                                               ( entity = 'SU_DETAIL' table = 'ZRAP_SU_DETAIL' )
                                                                         ) ).
  rap_transport_api->validate_changes(
      transport_request = request
      table             = 'ZRAP_SU_DB'
      keys              = REF #( keys )
      reported          = REF #( reported )
      failed            = REF #( failed )
      change            = REF #( change-SU_MASTER ) ).
  ENDMETHOD.
ENDCLASS.
