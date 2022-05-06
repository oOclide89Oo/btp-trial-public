CLASS zsu_es_cds_unm_log_test_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_es_cds_unm_log_test_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA:
      ls_business_data TYPE ZSU_S_CDS_LOG,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_create,
      lo_response      TYPE REF TO /iwbep/if_cp_response_create.

    TRY.
    lo_client_proxy = CL_WEB_ODATA_CLIENT_FACTORY=>create_v2_local_proxy(
                        EXPORTING
                          is_service_key = VALUE #( service_id      = 'ZSU_ES_SB_UNM_LOG'
                                                    service_version = '0001' ) ).
*     Prepare business data
    ls_business_data = VALUE #(
              logid         = 'test_su_1'
              type          = 'S'
              msg           = 'first message silvio post'
              query_xml     = 'QueryTest'
              result_xml    = 'ResultTest' ).

        " Navigate to the resource and create a request for the create operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'ZSU_CDS_ES_UNM_LOG' )->create_request_for_create( ).

        " Set the business data for the created entity
        lo_request->set_business_data( ls_business_data ).

        " Execute the request
        lo_response = lo_request->execute( ).

        cl_abap_unit_assert=>fail( 'Implement your assertions' ).


    CATCH cx_root.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
