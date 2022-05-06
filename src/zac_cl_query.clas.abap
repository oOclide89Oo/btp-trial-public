CLASS zac_cl_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_query IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA lv_entity_method   TYPE string.
    DATA lt_business_data   TYPE zac_t_cds_log.
    DATA ls_business_data   TYPE zac_s_cds_log.
    DATA(top)               = io_request->get_paging( )->get_page_size( ).
    DATA(skip)              = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)        = io_request->get_sort_elements( ).
    DATA lv_error           TYPE abap_boolean.
    DATA lv_numero_righe    TYPE int8.

    TRY.
        DATA(filter_condition) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    DATA(lv_logid)  = VALUE #( filter_condition[ 1 ]-range[ 1 ]-low DEFAULT space ).

    lt_business_data = zac_cl_log=>read_log_api( EXPORTING iv_log_id        = CONV zac_fieldname( lv_logid )
                                                           iv_active_system = sy-sysid
                                                 IMPORTING ev_error         = lv_error ).

    IF lv_error EQ abap_false.
      lv_numero_righe = lines( lt_business_data ).
      io_response->set_total_number_of_records( lv_numero_righe ).
      io_response->set_data( lt_business_data ).
    ELSE.
      RAISE EXCEPTION TYPE cx_aco_application_exception.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
