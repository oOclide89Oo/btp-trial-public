CLASS zac_cl_application_job2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: add_apj_free_text IMPORTING iv_type     TYPE cl_bali_free_text_setter=>ty_severity
                                         iv_text     TYPE cl_bali_free_text_setter=>ty_text
                                         io_appl_log TYPE REF TO if_bali_log
                                         iv_save     TYPE abap_boolean DEFAULT abap_false
                               RAISING   cx_bali_runtime.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_application_job2 IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    et_parameter_def = VALUE #(
      ( selname = 'S_ID'    kind = if_apj_dt_exec_object=>select_option datatype = 'C' length = 10 param_text = 'Task ID'                            changeable_ind = abap_true )
      ( selname = 'P_CLOSE' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Approve task at process ending'      checkbox_ind = abap_true  changeable_ind = abap_true )
      ( selname = 'P_MONIT' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Activate Monitoring for Companies'   checkbox_ind = abap_true  changeable_ind = abap_true )
      ( selname = 'P_MTIME' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Monitoring Period'                   changeable_ind = abap_true )
      ( selname = 'P_UPDT'  kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 1 param_text = 'Update Report Request(in case of Active Monitoring)'               checkbox_ind = abap_true  changeable_ind = abap_true )
    ).

    et_parameter_val = VALUE #(
      ( selname = 'P_CLOSE' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_true )
      ( selname = 'P_MONIT' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = abap_true )
      ( selname = 'P_MTIME' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'U' )
      ( selname = 'P_UPDT' kind = if_apj_dt_exec_object=>parameter      sign = 'I' option = 'EQ' low = abap_true )
    ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA: lv_approve_task             TYPE abap_boolean,
          lv_activate_monitoring      TYPE abap_boolean,
          lv_activate_monitoring_p    TYPE abap_boolean,
          lv_update_report            TYPE abap_boolean,
          lv_monitoring_period        TYPE string,
          lv_message                  TYPE cl_bali_free_text_setter=>ty_text,
          lv_report_name              TYPE string,
          lv_error                    TYPE abap_boolean,
          lv_qst_description          TYPE string,
          lv_composite_answer         TYPE string,
          lr_task_id                  TYPE RANGE OF string.

    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'S_ID'.
          APPEND VALUE #( sign   = ls_parameter-sign
                          option = ls_parameter-option
                          low    = ls_parameter-low
                          high   = ls_parameter-high ) TO lr_task_id.
        WHEN 'P_CLOSE'.   lv_approve_task          = ls_parameter-low.
        WHEN 'P_MONIT'.   lv_activate_monitoring_p = ls_parameter-low.
        WHEN 'P_MTIME'.   lv_monitoring_period     = ls_parameter-low.
        WHEN 'P_UPDT'.    lv_update_report         = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    TRY.
        DATA(lo_appl_log) = cl_bali_log=>create_with_header( header = cl_bali_header_setter=>create( object      = 'ZCORSO_LOG'
                                                                                                     subobject   = 'ZCORSO_LOG_ANDREA'
                                                                                                     external_id = '69420' ) ).

        CLEAR lv_message.
        lv_message = |**************************************************|.
        add_apj_free_text( iv_type     = if_bali_constants=>c_severity_information
                                                iv_text     = lv_message
                                                io_appl_log = lo_appl_log
                                                iv_save     = abap_true ).
        CLEAR lv_message.
        lv_message = |Execution starts - My first Example|.
        add_apj_free_text( iv_type     = if_bali_constants=>c_severity_information
                                                iv_text     = lv_message
                                                io_appl_log = lo_appl_log
                                                iv_save     = abap_true ).
        CLEAR lv_message.
        lv_message = |**************************************************|.
        add_apj_free_text( iv_type     = if_bali_constants=>c_severity_information
                                                iv_text     = lv_message
                                                io_appl_log = lo_appl_log
                                                iv_save     = abap_true ).
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA: lt_param TYPE if_apj_dt_exec_object=>tt_templ_val,
          ls_param LIKE LINE OF lt_param,
          lx_root  TYPE REF TO cx_root.

    me->if_apj_dt_exec_object~get_parameters( IMPORTING et_parameter_val = lt_param ).

    ls_param-kind = if_apj_dt_exec_object=>select_option.
    ls_param-selname = 'S_ID'.
    ls_param-sign   = 'I'.
    ls_param-option = 'EQ'.
    ls_param-low    = 'TSK3434386276'.
    APPEND ls_param TO lt_param.

    TRY.
        me->if_apj_rt_exec_object~execute( it_parameters = lt_param ).
      CATCH cx_root INTO lx_root.
        out->write( lx_root->get_text(  ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD add_apj_free_text.
    DATA lo_log_free_text TYPE REF TO if_bali_free_text_setter.

    lo_log_free_text = cl_bali_free_text_setter=>create( severity = iv_type text = iv_text ).
    lo_log_free_text->set_detail_level( detail_level = '1' ).
    io_appl_log->add_item( item = lo_log_free_text ).

    IF iv_save IS NOT INITIAL.
      cl_bali_log_db=>get_instance( )->save_log( log = io_appl_log assign_to_current_appl_job = abap_true ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
