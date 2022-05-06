CLASS zcs_cl_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
* Potremmo usare un metodo nella classe stessa per la lettura. Ma poichè abbiamo una classe dedicata ai log, andiamo a scrivere in quella classe il metodo
*    METHODS: read_log IMPORTING iv_log_id TYPE zrap_fieldname
*                      EXPORTING ev_error  TYPE abap_boolean
*                      RETURNING VALUE(rt_business_data) TYPE zcs_t_cds_log. "NEI PARAMETRI DEI METODI, USATE SEMPRE TABLE TYPE
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcs_cl_query IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

**********************************************************************
* Logica...
    DATA lv_entity_method   TYPE string.
*    DATA lt_business_data   TYPE STANDARD TABLE OF zcs_cds_unm_log. "EQUIVALENTE A TYPE TABLETYPE
*    DATA ls_business_data   TYPE zcs_cds_unm_log.
    DATA lt_business_data TYPE zcs_t_cds_log.
    DATA ls_business_data TYPE zcs_s_cds_log.
    DATA(top)               = io_request->get_paging( )->get_page_size( ).
    DATA(skip)              = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)        = io_request->get_sort_elements( ).
    DATA lv_error TYPE abap_boolean.
    DATA lv_numero_righe TYPE int8.
*    DATA lo_exec TYPE REF TO cx_rap_query_provider.

    TRY.
        DATA(filter_condition) = io_request->get_filter( )->get_as_ranges( ). "SERVE A PRENDERE QUESTO PEZZO DALL' URL -> $filter=logid%20eq%20%27rfq_1230%27
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    DATA(lv_logid)  = VALUE #( filter_condition[ 1 ]-range[ 1 ]-low DEFAULT space ).

**********************************************************************
*    LOGICA DI LETTURA
    lt_business_data = zcs_cl_log=>read_log_api( EXPORTING iv_log_id = CONV zrap_fieldname( lv_logid )
                                        iv_active_system = sy-sysid
                              IMPORTING ev_error  = lv_error ).
**********************************************************************

    IF lv_error EQ abap_false.
      lv_numero_righe = lines( lt_business_data ).
      io_response->set_total_number_of_records( lv_numero_righe ). "setta il numero di linee della tabella
      io_response->set_data( lt_business_data ). "setta i dati tabella
    ELSE.
      RAISE EXCEPTION TYPE cx_aco_application_exception.
    ENDIF.



**********************************************************************

  ENDMETHOD.


ENDCLASS.
