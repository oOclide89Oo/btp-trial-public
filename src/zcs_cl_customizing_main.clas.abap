CLASS zcs_cl_customizing_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS: create_master_and_detail IMPORTING io_out              TYPE REF TO if_oo_adt_classrun_out
                                                iv_group_name       TYPE zrap_c_master-fieldname
                                                iv_system           TYPE zrap_c_master-activesystem
                                                iv_configurationID  TYPE zrap_c_detail-configurationid
                                                iv_customizingvalue TYPE zrap_c_detail-customizingvalue.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcs_cl_customizing_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
**********************************************************************
    DATA: lo_handler TYPE REF TO zcs_cl_customizing_handler,
          lt_group   TYPE zcs_t_customizing_detail.

    CREATE OBJECT lo_handler. "chiama il costruttore della classe -> va a popolare i buffer

    IF lo_handler IS BOUND.
      lt_group = lo_handler->get_detail_group( EXPORTING iv_group_name = zcs_if_constants=>c_custom_grp_apikey iv_system = sy-sysid ).
    ENDIF.

**********************************************************************
*        DATA lo_main TYPE REF TO zcs_cl_customizing_main.
*
*        CREATE OBJECT lo_main.
*        IF lo_main IS BOUND.
*            lo_main->create_master_and_detail( ).
*        ENDIF.
***********************************************************************
**Tutto il lavoro di prima non lo faccio perchè per usare il metodo if_oo_adt_classrun~main
**eclipse ha già chiamato il costruttore anonimo della classe e sono già in una sua istanza
*        create_master_and_detail( EXPORTING io_out = out
*                                            iv_group_name       = zcs_if_constants=>c_custom_grp_apikey
*                                            iv_system           = sy-sysid
*                                            iv_configurationid  = zcs_if_constants=>c_custom_dtl_ariba_api_key
*                                            iv_customizingvalue = zcs_if_constants=>c_custom_dtl_auth ).
  ENDMETHOD.
  METHOD create_master_and_detail.
    DATA: lt_detail TYPE zcs_t_customizing_detail,
          ls_detail TYPE zrap_c_detail,
          lv_error  TYPE abap_boolean,
          lv_riga   TYPE string,
          ls_master TYPE zrap_c_master.

    ls_master-activesystem = iv_system.
    ls_master-fieldname    = iv_group_name.

    zcs_cl_customizing_handler=>write_master_group( EXPORTING is_master = ls_master
                                                    IMPORTING ev_error  = lv_error ).

    IF lv_error EQ abap_false.
      ls_detail-configurationid  = iv_configurationid.
      ls_detail-activesystem     = iv_system.
      ls_detail-fieldname        = iv_group_name.
      ls_detail-customizingvalue = iv_customizingvalue.

      zcs_cl_customizing_handler=>write_detail_group( EXPORTING is_detail = ls_detail
                                                      IMPORTING ev_error  = lv_error ).
      IF lv_error IS INITIAL.
        io_out->write( 'Scrittura completata!').
        lt_detail = zcs_cl_customizing_handler=>read_detail( ).
        LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_detail>).
          CLEAR lv_riga.
          lv_riga = | { <fs_detail>-configurationid } { <fs_detail>-fieldname } { <fs_detail>-activesystem  } |.
          io_out->write( lv_riga ).
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
