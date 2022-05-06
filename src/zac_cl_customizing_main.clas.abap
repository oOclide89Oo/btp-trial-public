CLASS zac_cl_customizing_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    METHODS: create_master_and_detail IMPORTING io_out              TYPE REF TO if_oo_adt_classrun_out
                                                iv_groupname        TYPE zrap_ac_master-fieldname
                                                iv_system           TYPE zrap_ac_master-activesystem
                                                iv_configurationid  TYPE zrap_ac_detail-configurationid
                                                iv_customizingvalue TYPE zrap_ac_detail-customizingvalue.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: detail_initialize IMPORTING is_detail_config TYPE zrap_ac_detail-configurationid
                                         is_detail_sys    TYPE zrap_ac_detail-activesystem
                                         is_detail_name   TYPE zrap_ac_detail-fieldname
                                         is_detail_value  TYPE zrap_ac_detail-customizingvalue
                               RETURNING VALUE(rs_detail) TYPE zrap_ac_detail,
             master_initialize IMPORTING is_master_name   TYPE zrap_ac_master-fieldname
                                         is_master_sys    TYPE zrap_ac_master-activesystem
                               RETURNING VALUE(rs_master) TYPE zrap_ac_master.
ENDCLASS.



CLASS zac_cl_customizing_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    create_master_and_detail( EXPORTING io_out              = out
                                        iv_groupname        = zac_if_constant=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zac_if_constant=>c_custom_dtl_ariba_api_key
                                        iv_customizingvalue = zac_if_constant=>c_custom_auth ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_groupname        = zac_if_constant=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zac_if_constant=>c_custom_acceptkey
                                        iv_customizingvalue = zac_if_constant=>c_custom_accept ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_groupname        = zac_if_constant=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zac_if_constant=>c_custom_connkey
                                        iv_customizingvalue = zac_if_constant=>c_custom_connection ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_groupname        = zac_if_constant=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zac_if_constant=>c_custom_contentkey
                                        iv_customizingvalue = zac_if_constant=>c_custom_content ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_groupname        = zac_if_constant=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zac_if_constant=>c_custom_encodekey
                                        iv_customizingvalue = zac_if_constant=>c_custom_encoding ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_groupname        = zac_if_constant=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zac_if_constant=>c_custom_bodykey
                                        iv_customizingvalue = zac_if_constant=>c_custom_body ).
  ENDMETHOD.

  METHOD detail_initialize.
    DATA: ls_detail TYPE zrap_ac_detail.

    ls_detail-configurationid  = is_detail_config.
    ls_detail-activesystem     = is_detail_sys.
    ls_detail-fieldname        = is_detail_name.
    ls_detail-customizingvalue = is_detail_value.

    rs_detail = ls_detail.
  ENDMETHOD.

  METHOD master_initialize.
    DATA: ls_master TYPE zrap_ac_master.

    ls_master-fieldname    = is_master_name.
    ls_master-activesystem = is_master_sys.

    rs_master = ls_master.
  ENDMETHOD.

  METHOD create_master_and_detail.
    DATA: lt_detail TYPE zac_detail_tt,
          ls_detail TYPE zrap_ac_detail,
          lv_error  TYPE abap_boolean,
          lv_riga   TYPE string,
          ls_master TYPE zrap_ac_master.

    ls_master = master_initialize( EXPORTING is_master_sys   = iv_system
                                             is_master_name  = iv_groupname ).

    zac_cl_customizing_handler=>write_master_group( EXPORTING is_master = ls_master
                                                    IMPORTING ev_error  = lv_error ).

    IF lv_error EQ abap_false.

      ls_detail = detail_initialize( EXPORTING is_detail_config = iv_configurationid
                                               is_detail_name   = iv_groupname
                                               is_detail_sys    = iv_system
                                               is_detail_value  = iv_customizingvalue ).

      zac_cl_customizing_handler=>write_detail_group( EXPORTING is_detail = ls_detail
                                                      IMPORTING ev_error  = lv_error ).

      IF lv_error EQ abap_false.
        io_out->write( 'Scrittura completata!').
        lt_detail = zac_cl_customizing_handler=>read_detail( ).
        LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_detail>).
          CLEAR lv_riga.
          lv_riga = | { <fs_detail>-configurationid } { <fs_detail>-fieldname } { <fs_detail>-activesystem  } |.
          io_out->write( lv_riga ).
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
