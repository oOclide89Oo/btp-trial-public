CLASS zac_cl_main_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_main_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA:
    ls_business_data TYPE zac_s_cds_log,
    lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
    lo_request       TYPE REF TO /iwbep/if_cp_request_create,
    lo_response      TYPE REF TO /iwbep/if_cp_response_create.

    TRY.
      lo_client_proxy = cl_web_odata_client_factory=>create_v2_local_proxy( EXPORTING is_service_key = VALUE #( service_id      = 'ZAC_SB_UNM_LOG'
                                                                                                                service_version = '0001' ) ).
* Prepare business data
      ls_business_data = VALUE #( logid         = 'LOGAPI'
                                  type          = 'S'
                                  msg           = 'Test di WEB API'
                                  query_xml     = 'test query'
                                  result_xml    = 'test result' ).

" Navigate to the resource and create a request for the create operation
      lo_request = lo_client_proxy->create_resource_for_entity_set( 'ZAC_CDS_UNM_LOG' )->create_request_for_create( ).

" Set the business data for the created entity
      lo_request->set_business_data( ls_business_data ).

" Execute the request
      lo_response = lo_request->execute( ).

      cl_abap_unit_assert=>fail( 'Implement your assertions' ).
    CATCH cx_root.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
