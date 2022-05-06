CLASS LHC_ES_MASTER DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VAL_TRANSPORT FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR  ES_MASTER~val_transport .
ENDCLASS.

CLASS LHC_ES_MASTER IMPLEMENTATION.
  METHOD VAL_TRANSPORT.
  DATA change TYPE REQUEST FOR CHANGE ZI_SILES_MASTER_S.
  SELECT SINGLE request FROM ZSILES_MASTER01D INTO @DATA(request).
  DATA(rap_transport_api) = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                               ( entity = 'ES_MASTER' table = 'ZSU_ES_MASTER' )
                                               ( entity = 'ES_DETAIL' table = 'ZSU_ES_DETAIL' )
                                                                         ) ).
  rap_transport_api->validate_changes(
      transport_request = request
      table             = 'ZSU_ES_MASTER'
      keys              = REF #( keys )
      reported          = REF #( reported )
      failed            = REF #( failed )
      change            = REF #( change-ES_MASTER ) ).
  ENDMETHOD.
ENDCLASS.
