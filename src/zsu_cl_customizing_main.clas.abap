CLASS zsu_cl_customizing_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

    METHODS: create_master_and_detail  IMPORTING io_out               TYPE REF TO if_oo_adt_classrun_out
                                                 iv_group_name        TYPE  zrap_su_detail-fieldname
                                                 iv_activesystem      TYPE  zrap_su_detail-activesystem
                                                 iv_configurationID   TYPE  zrap_su_detail-configurationid
                                                 iv_customizingvalue  TYPE  zrap_su_detail-customizingvalue.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zsu_cl_customizing_main IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
*        DATA lo_main TYPE REF TO zcs_cl_customizing_main.
*
*        CREATE OBJECT lo_main.
*        IF lo_main IS BOUND.
*            lo_main->create_master_and_detail( ).
*        ENDIF.
**********************************************************************
*Tutto il lavoro di prima non lo faccio perchè per usare il metodo if_oo_adt_classrun~main
*eclipse ha già chiamato il costruttore anonimo della classe e sono già in una sua istanza
        create_master_and_detail( EXPORTING io_out = out
                                            iv_group_name       = zsu_if_constants=>c_custom_grp_apikey
                                            iv_activesystem     = sy-sysid
                                            iv_configurationID  = zsu_if_constants=>c_custom_bodykey
                                            iv_customizingvalue = zsu_if_constants=>c_custom_body
                                                 ).

  ENDMETHOD.


  METHOD create_master_and_detail.

    DATA: lt_detail TYPE zsu_detail_tt,
          ls_detail TYPE zrap_su_detail,
          lv_error  TYPE abap_boolean,
          lv_riga   TYPE string,
          ls_master TYPE zrap_su_db.

    ls_master-activesystem = iv_activesystem.
    ls_master-fieldname = iv_group_name.

    zsu_cl_customizing_handler=>write_master_group( EXPORTING is_master = ls_master
                                                    IMPORTING ev_error  = lv_error ).

    IF lv_error EQ  abap_false.

*        ls_detail-configurationid  = zsu_if_constants=>c_custom_dtl_ariba_token.
*        ls_detail-activesystem     = sy-sysid.
*        ls_detail-fieldname        = zsu_if_constants=>c_custom_grp_endpoint.
*        ls_detail-customizingvalue = 'https://api-eu.ariba.com/v2/oauth/token'.

         ls_detail-configurationid  = iv_configurationID.
         ls_detail-activesystem     = iv_activesystem.
         ls_detail-fieldname        = iv_group_name.
         ls_detail-customizingvalue = iv_customizingvalue.


        zsu_cl_customizing_handler=>write_detail_group( EXPORTING is_detail = ls_detail
                                                        IMPORTING ev_error  = lv_error ).


        IF lv_error IS INITIAL.
            io_out->write( 'scrittura completata' ).
            lt_detail = zsu_cl_customizing_handler=>read_detail(  ).

            LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_detail>).
                CLEAR lv_riga.
                lv_riga = | { <fs_detail>-configurationid } { <fs_detail>-fieldname } { <fs_detail>-activesystem  } |.
                io_out->write( lv_riga ).
            ENDLOOP.
        ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
