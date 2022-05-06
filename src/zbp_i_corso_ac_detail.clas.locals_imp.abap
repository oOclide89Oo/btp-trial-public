CLASS LHC_AC_DETAIL DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VAL_TRANSPORT FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR  AC_DETAIL~val_transport .
ENDCLASS.

CLASS LHC_AC_DETAIL IMPLEMENTATION.
  METHOD VAL_TRANSPORT.
  DATA change TYPE REQUEST FOR CHANGE ZI_CORSO_AC_MASTER_S.
  SELECT SINGLE request FROM ZCORSO_AC_MAS01D INTO @DATA(request).
  DATA(rap_transport_api) = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                               ( entity = 'AC_MASTER' table = 'ZRAP_AC_MASTER' )
                                               ( entity = 'AC_DETAIL' table = 'ZRAP_AC_DETAIL' )
                                                                         ) ).
  rap_transport_api->validate_changes(
      transport_request = request
      table             = 'ZRAP_AC_DETAIL'
      keys              = REF #( keys )
      reported          = REF #( reported )
      failed            = REF #( failed )
      change            = REF #( change-AC_DETAIL ) ).
  ENDMETHOD.
ENDCLASS.
