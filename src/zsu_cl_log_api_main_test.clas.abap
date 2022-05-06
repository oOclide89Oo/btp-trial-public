CLASS zsu_cl_log_api_main_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_cl_log_api_main_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA:
      ls_business_data TYPE zcs_s_cds_log,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_create,
      lo_response      TYPE REF TO /iwbep/if_cp_response_create.
********************************************************************
* SIMULIAMO UNA POST
    TRY. "crea il servizio in locale
        lo_client_proxy = cl_web_odata_client_factory=>create_v2_local_proxy(
                            EXPORTING
                              is_service_key = VALUE #( service_id      = 'ZCS_SB_UNM_LOG'
                                                        service_version = '0001' ) ).
* Prepare business data
* setta i dati
        ls_business_data = VALUE #(
          logid         = 'Logid'
          type          = 's'
          msg           = 'primo test web api'
          query_xml     = 'Query test'
          result_xml    = 'Result test'
             ).
**********************************************************************
* Mette i dati nella request
        " Navigate to the resource and create a request for the create operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'ZCS_CDS_UNM_LOG' )->create_request_for_create( ).

        " Set the business data for the created entity
        lo_request->set_business_data( ls_business_data ).
**********************************************************************
* Esegue la chiamata al servizio. Per intercettarla mettiamo un breakpoint nel create del behavior
        " Execute the request
        lo_response = lo_request->execute( ).

        cl_abap_unit_assert=>fail( 'Implement your assertions' ).
      CATCH cx_root.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
