CLASS zac_cl_customsmd_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    METHODS: create_master_detail IMPORTING io_out              TYPE REF TO if_oo_adt_classrun_out
                                            iv_groupname        TYPE zac_fname_master
                                            iv_system           TYPE zac_actsys
                                            iv_configurationid  TYPE zac_configurationid
                                            iv_customizingvalue TYPE zac_customvalue,

             create_single        IMPORTING iv_singlename       TYPE zac_fname
                                            iv_system           TYPE zac_actsys.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: detail_initialize IMPORTING is_detail_config TYPE zac_configurationid
                                         is_detail_sys    TYPE zac_actsys
                                         is_detail_name   TYPE zac_fname_master
                                         is_detail_value  TYPE zac_customvalue
                               RETURNING VALUE(rs_detail) TYPE zac_rap_detail,
             master_initialize IMPORTING is_master_name   TYPE zac_fname_master
                                         is_master_sys    TYPE zac_actsys
                               RETURNING VALUE(rs_master) TYPE zac_rap_master,
             single_initialize IMPORTING is_single_name   TYPE zac_fname
                                         is_single_sys    TYPE zac_actsys
                               RETURNING VALUE(rs_single) TYPE zac_db_single.
ENDCLASS.



CLASS zac_cl_customsmd_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    create_single( EXPORTING iv_singlename = zac_if_constants_smd=>c_custom_single
                             iv_system     = sy-sysid ).

    create_master_detail( EXPORTING io_out              = out
                                    iv_groupname        = zac_if_constants_smd=>c_custom_grp_apikey
                                    iv_system           = sy-sysid
                                    iv_configurationid  = zac_if_constants_smd=>c_custom_dtl_ariba_api_key
                                    iv_customizingvalue = zac_if_constants_smd=>c_custom_auth ).

    create_master_detail( EXPORTING io_out              = out
                                    iv_groupname        = zac_if_constants_smd=>c_custom_grp_apikey
                                    iv_system           = sy-sysid
                                    iv_configurationid  = zac_if_constants_smd=>c_custom_urlkey
                                    iv_customizingvalue = zac_if_constants_smd=>c_custom_url ).

    create_master_detail( EXPORTING io_out              = out
                                    iv_groupname        = zac_if_constants_smd=>c_custom_grp_apikey
                                    iv_system           = sy-sysid
                                    iv_configurationid  = zac_if_constants_smd=>c_custom_acceptkey
                                    iv_customizingvalue = zac_if_constants_smd=>c_custom_accept ).

    create_master_detail( EXPORTING io_out              = out
                                    iv_groupname        = zac_if_constants_smd=>c_custom_grp_apikey
                                    iv_system           = sy-sysid
                                    iv_configurationid  = zac_if_constants_smd=>c_custom_connkey
                                    iv_customizingvalue = zac_if_constants_smd=>c_custom_connection ).

    create_master_detail( EXPORTING io_out              = out
                                    iv_groupname        = zac_if_constants_smd=>c_custom_grp_apikey
                                    iv_system           = sy-sysid
                                    iv_configurationid  = zac_if_constants_smd=>c_custom_contentkey
                                    iv_customizingvalue = zac_if_constants_smd=>c_custom_content ).

    create_master_detail( EXPORTING io_out              = out
                                    iv_groupname        = zac_if_constants_smd=>c_custom_grp_apikey
                                    iv_system           = sy-sysid
                                    iv_configurationid  = zac_if_constants_smd=>c_custom_encodekey
                                    iv_customizingvalue = zac_if_constants_smd=>c_custom_encoding ).

    create_master_detail( EXPORTING io_out              = out
                                    iv_groupname        = zac_if_constants_smd=>c_custom_grp_apikey
                                    iv_system           = sy-sysid
                                    iv_configurationid  = zac_if_constants_smd=>c_custom_bodykey
                                    iv_customizingvalue = zac_if_constants_smd=>c_custom_body ).
  ENDMETHOD.

  METHOD create_master_detail.
    DATA: lt_detail TYPE zac_t_detail,
          ls_detail TYPE zac_rap_detail,
          lv_error  TYPE abap_boolean,
          lv_riga   TYPE string,
          ls_master TYPE zac_rap_master.

    ls_master = master_initialize( EXPORTING is_master_sys   = iv_system
                                             is_master_name  = iv_groupname ).

    zac_cl_customsmd_handler=>write_master( EXPORTING is_master = ls_master
                                            IMPORTING ev_error  = lv_error ).

    IF lv_error EQ abap_false.

      ls_detail = detail_initialize( EXPORTING is_detail_config = iv_configurationid
                                               is_detail_name   = iv_groupname
                                               is_detail_sys    = iv_system
                                               is_detail_value  = iv_customizingvalue ).

      zac_cl_customsmd_handler=>write_detail( EXPORTING is_detail = ls_detail
                                              IMPORTING ev_error  = lv_error ).

      IF lv_error EQ abap_false.
        io_out->write( 'Scrittura completata!').
        lt_detail = zac_cl_customsmd_handler=>read_detail( ).
        LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_detail>).
          CLEAR lv_riga.
          lv_riga = | { <fs_detail>-configurationid } { <fs_detail>-fieldname } { <fs_detail>-activesystem  } |.
          io_out->write( lv_riga ).
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD detail_initialize.
    DATA: ls_detail TYPE zac_rap_detail.

    ls_detail-configurationid  = is_detail_config.
    ls_detail-activesystem     = is_detail_sys.
    ls_detail-fieldname        = is_detail_name.
    ls_detail-customizingvalue = is_detail_value.

    rs_detail = ls_detail.
  ENDMETHOD.

  METHOD master_initialize.
    DATA: ls_master TYPE zac_rap_master.

    ls_master-fieldname    = is_master_name.
    ls_master-activesystem = is_master_sys.

    rs_master = ls_master.
  ENDMETHOD.

  METHOD single_initialize.
    DATA: ls_single TYPE zac_db_single.

    ls_single-fieldname    = is_single_name.
    ls_single-activesystem = is_single_sys.

    rs_single = ls_single.
  ENDMETHOD.

  METHOD create_single.
    DATA: ls_single TYPE zac_db_single,
          lv_error  TYPE abap_boolean.

    ls_single = single_initialize( EXPORTING is_single_sys  = iv_system
                                             is_single_name = iv_singlename ).

    zac_cl_customsmd_handler=>write_single( EXPORTING is_single = ls_single
                                            IMPORTING ev_error  = lv_error ).
  ENDMETHOD.

ENDCLASS.
