CLASS LHC_AC_MSTR DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VAL_TRANSPORT FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR  AC_MSTR~val_transport .
ENDCLASS.

CLASS LHC_AC_MSTR IMPLEMENTATION.
  METHOD VAL_TRANSPORT.
  DATA change TYPE REQUEST FOR CHANGE ZI_CORSO_AC_MSTR_S.
  SELECT SINGLE request FROM ZCORSO_AC_MST01D INTO @DATA(request).
  DATA(rap_transport_api) = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                               ( entity = 'AC_MSTR' table = 'ZAC_RAP_MASTER' )
                                               ( entity = 'AC_DTL' table = 'ZAC_RAP_DETAIL' )
                                                                         ) ).
  rap_transport_api->validate_changes(
      transport_request = request
      table             = 'ZAC_RAP_MASTER'
      keys              = REF #( keys )
      reported          = REF #( reported )
      failed            = REF #( failed )
      change            = REF #( change-AC_MSTR ) ).
  ENDMETHOD.
ENDCLASS.
