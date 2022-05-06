CLASS zsu_es_cust_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS: create_master_and_detail IMPORTING io_out              TYPE REF TO if_oo_adt_classrun_out
                                                iv_group_name       TYPE zsu_es_master-fieldname
                                                iv_system           TYPE zsu_es_master-activesystem
                                                iv_configurationid  TYPE zsu_es_detail-configurationid
                                                iv_customizingvalue TYPE zsu_es_detail-customizingvalue,

             create_hdr                IMPORTING iv_hdr_name        TYPE zsu_es_hdr-fieldname
                                                 iv_system          TYPE zsu_es_hdr-activesystem.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_es_cust_main IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_group_name       = zsu_es_constants=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zsu_es_constants=>c_custom_urlkey
                                        iv_customizingvalue = zsu_es_constants=>c_custom_url ).


    create_master_and_detail( EXPORTING io_out              = out
                                        iv_group_name        = zsu_es_constants=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zsu_es_constants=>c_custom_dtl_ariba_api_key
                                        iv_customizingvalue = zsu_es_constants=>c_custom_dtl_auth ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_group_name        = zsu_es_constants=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zsu_es_constants=>c_custom_acceptkey
                                        iv_customizingvalue = zsu_es_constants=>c_custom_accept ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_group_name        = zsu_es_constants=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zsu_es_constants=>c_custom_connkey
                                        iv_customizingvalue = zsu_es_constants=>c_custom_connection ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_group_name        = zsu_es_constants=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zsu_es_constants=>c_custom_contentkey
                                        iv_customizingvalue = zsu_es_constants=>c_custom_content ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_group_name        = zsu_es_constants=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zsu_es_constants=>c_custom_encodekey
                                        iv_customizingvalue = zsu_es_constants=>c_custom_encoding ).

    create_master_and_detail( EXPORTING io_out              = out
                                        iv_group_name        = zsu_es_constants=>c_custom_grp_apikey
                                        iv_system           = sy-sysid
                                        iv_configurationid  = zsu_es_constants=>c_custom_bodykey
                                        iv_customizingvalue = zsu_es_constants=>c_custom_body ).

  ENDMETHOD.

  METHOD create_master_and_detail.

    DATA: lt_detail TYPE zsu_es_detail_tt,
          ls_detail TYPE zsu_es_detail,
          lv_error  TYPE abap_boolean,
          lv_riga   TYPE string,
          ls_master TYPE zsu_es_master.


    ls_master-activesystem = iv_system.
    ls_master-fieldname    = iv_group_name.

    zsu_es_cust_handler=>write_master( EXPORTING is_master = ls_master
                                       IMPORTING ev_error  = lv_error ).



    IF lv_error EQ abap_false.
      ls_detail-configurationid  = iv_configurationid.
      ls_detail-activesystem     = iv_system.
      ls_detail-fieldname        = iv_group_name.
      ls_detail-customizingvalue = iv_customizingvalue.

      zsu_es_cust_handler=>write_detail( EXPORTING is_detail = ls_detail
                                         IMPORTING ev_error  = lv_error ).
      IF lv_error IS INITIAL.
        io_out->write( 'Scrittura completata!').
        lt_detail = zsu_es_cust_handler=>read_detail( ).

        LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_detail>).
          CLEAR lv_riga.
          lv_riga = | { <fs_detail>-configurationid } { <fs_detail>-fieldname } { <fs_detail>-activesystem  } |.
          io_out->write( lv_riga ).
        ENDLOOP.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD create_hdr.

    DATA: ls_hdr TYPE zsu_es_hdr,
          lv_error  TYPE abap_boolean.

    ls_hdr-activesystem = iv_system.
    ls_hdr-fieldname    = iv_hdr_name.

    zsu_es_cust_handler=>write_hdr( EXPORTING is_hdr = ls_hdr
                                    IMPORTING ev_error  = lv_error ).

  ENDMETHOD.

ENDCLASS.
