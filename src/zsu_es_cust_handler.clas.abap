CLASS zsu_es_cust_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_oo_adt_classrun .

  CLASS-DATA: mt_customizing_master TYPE zsu_es_master_tt, "tabella master
              mt_customizing_detail TYPE zsu_es_detail_tt, "tabella detail
              mt_customizing_hdr    TYPE zsu_es_hdr_tt.    "tabella hdr single

  CLASS-METHODS: read_master RETURNING VALUE(rt_master) TYPE zsu_es_master_tt,

                 read_detail RETURNING VALUE(rt_detail) TYPE zsu_es_detail_tt,

                 read_hdr    RETURNING VALUE(rt_hdr)    TYPE zsu_es_hdr_tt,

                 write_master IMPORTING it_master TYPE zsu_es_master_tt OPTIONAL
                                        is_master TYPE zsu_es_master OPTIONAL
                              EXPORTING ev_error  TYPE abap_boolean,

                 write_detail IMPORTING it_detail TYPE zsu_es_detail_tt OPTIONAL
                                        is_detail TYPE zsu_es_detail OPTIONAL
                              EXPORTING ev_error  TYPE abap_boolean,

                 write_hdr    IMPORTING it_hdr TYPE zsu_es_hdr_tt OPTIONAL
                                        is_hdr TYPE zsu_es_hdr OPTIONAL
                              EXPORTING ev_error  TYPE abap_boolean.

   METHODS: constructor,
            get_detail_group IMPORTING iv_group_name   TYPE zsumaster_es_fieldname
                                       iv_system       TYPE zsu_es_detail-activesystem
                             EXPORTING ev_error        TYPE abap_boolean
                             RETURNING VALUE(rt_group) TYPE zsu_es_detail_tt,

            get_detail_value IMPORTING iv_group_name    TYPE zsumaster_es_fieldname
                                       iv_system        TYPE zsu_es_detail-activesystem
                                       iv_customizingid TYPE zsu_es_detail-configurationid
                             EXPORTING ev_error         TYPE abap_boolean
                             RETURNING VALUE(rv_value)  TYPE zsu_es_detail-customizingvalue.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_es_cust_handler IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.

  METHOD constructor.

    mt_customizing_master = read_master(  ).
    mt_customizing_detail = read_detail( ).
    mt_customizing_hdr    = read_hdr(  ).

  ENDMETHOD.

  METHOD read_master.

    SELECT * FROM zsu_es_master "prendi tutte le linee
    WHERE activesystem EQ @sy-sysid AND inactive EQ @abap_false " che hanno questa condizione
    INTO TABLE @rt_master. " mettile in questa

  ENDMETHOD.

  METHOD read_detail.

    SELECT * FROM zsu_es_detail "prendi tutte le linee
    WHERE activesystem EQ @sy-sysid AND inactive EQ @abap_false " che hanno questa condizione
    INTO TABLE @rt_detail. " mettile in questa

  ENDMETHOD.

  METHOD read_hdr.

    SELECT * FROM zsu_es_hdr "prendi tutte le linee
    WHERE activesystem EQ @sy-sysid AND inactive EQ @abap_false " che hanno questa condizione
    INTO TABLE @rt_hdr. " mettile in questa

  ENDMETHOD.

  METHOD write_detail.

      DATA: lt_detail_db TYPE zsu_es_detail_tt,
            ls_detail_db TYPE zsu_es_detail.

      FIELD-SYMBOLS: <fs_detail_db> TYPE zsu_es_detail. "Sono il riferimento a db della linea/o della variabile che sto usando

      IF is_detail IS NOT INITIAL.

          MOVE-CORRESPONDING is_detail TO ls_detail_db.

*         Gestisco i parametri di edit

          ls_detail_db-last_changed_by = sy-uname.
          GET TIME STAMP FIELD ls_detail_db-last_changed_at.

          IF ls_detail_db-created_by IS INITIAL.
            ls_detail_db-created_by = ls_detail_db-last_changed_by.
            ls_detail_db-created_at = ls_detail_db-last_changed_at.
          ENDIF.

          APPEND ls_detail_db TO lt_detail_db.

          ELSEIF it_detail IS NOT INITIAL.

          MOVE-CORRESPONDING it_detail TO lt_detail_db.

          LOOP AT lt_detail_db ASSIGNING <fs_detail_db>.
            <fs_detail_db>-last_changed_by = sy-uname.
            GET TIME STAMP FIELD <fs_detail_db>-last_changed_at.

            IF <fs_detail_db>-created_by IS INITIAL.
              <fs_detail_db>-created_by = <fs_detail_db>-last_changed_by.
              <fs_detail_db>-created_at = <fs_detail_db>-last_changed_by.
            ENDIF.
          ENDLOOP.
    ENDIF.

    IF lt_detail_db IS NOT INITIAL.
      MODIFY zsu_es_detail FROM TABLE @lt_detail_db.
      IF sy-subrc NE 0. "QUALCOSA NON VA
        ev_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD write_master.
 DATA:    lt_master_db TYPE zsu_es_master_tt,
          ls_master_db TYPE zsu_es_master.

    FIELD-SYMBOLS: <fs_master_db> TYPE zsu_es_master.

    IF is_master IS NOT INITIAL.
      MOVE-CORRESPONDING is_master TO ls_master_db.

      ls_master_db-last_changed_by = sy-uname.
      GET TIME STAMP FIELD ls_master_db-last_changed_at.

      IF ls_master_db-created_by IS INITIAL.
        ls_master_db-created_by = ls_master_db-last_changed_by.
        ls_master_db-created_at = ls_master_db-last_changed_at.
      ENDIF.

      APPEND ls_master_db TO lt_master_db.

    ELSEIF it_master IS NOT INITIAL.
      MOVE-CORRESPONDING it_master TO lt_master_db.

      LOOP AT lt_master_db ASSIGNING <fs_master_db>.

        <fs_master_db>-last_changed_by = sy-uname.
        GET TIME STAMP FIELD <fs_master_db>-last_changed_at.
        IF <fs_master_db>-created_by IS INITIAL.
          <fs_master_db>-created_by = <fs_master_db>-last_changed_by.
          <fs_master_db>-created_at = <fs_master_db>-last_changed_at.
        ENDIF.

      ENDLOOP.
    ENDIF.

    IF lt_master_db IS NOT INITIAL.
      MODIFY zsu_es_master FROM TABLE @lt_master_db.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD write_hdr.

    DATA:    lt_hdr_db TYPE zsu_es_hdr_tt,
             ls_hdr_db TYPE zsu_es_hdr.

    FIELD-SYMBOLS: <fs_hdr_db> TYPE zsu_es_hdr.

    IF is_hdr IS NOT INITIAL.
      MOVE-CORRESPONDING is_hdr TO ls_hdr_db.

      ls_hdr_db-last_changed_by = sy-uname.
      GET TIME STAMP FIELD ls_hdr_db-last_changed_at.

      IF ls_hdr_db-created_by IS INITIAL.
        ls_hdr_db-created_by = ls_hdr_db-last_changed_by.
        ls_hdr_db-created_at = ls_hdr_db-last_changed_at.
      ENDIF.

      APPEND ls_hdr_db TO lt_hdr_db.

    ELSEIF it_hdr IS NOT INITIAL.
      MOVE-CORRESPONDING it_hdr TO lt_hdr_db.

      LOOP AT lt_hdr_db ASSIGNING <fs_hdr_db>.

        <fs_hdr_db>-last_changed_by = sy-uname.
        GET TIME STAMP FIELD <fs_hdr_db>-last_changed_at.
        IF <fs_hdr_db>-created_by IS INITIAL.
          <fs_hdr_db>-created_by = <fs_hdr_db>-last_changed_by.
          <fs_hdr_db>-created_at = <fs_hdr_db>-last_changed_at.
        ENDIF.

      ENDLOOP.
    ENDIF.

    IF lt_hdr_db IS NOT INITIAL.
      MODIFY zsu_es_hdr FROM TABLE @lt_hdr_db.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD get_detail_group.

*  per prestazioni, carichiamo il buffer

    IF mt_customizing_detail IS INITIAL.
      mt_customizing_detail = read_detail( ).
    ENDIF.

    rt_group = mt_customizing_detail.

**********************************************************************
* Togliamo gli active system diversi dall'input'

    DELETE rt_group WHERE activesystem NE iv_system.
**********************************************************************
* Togliamo i gruppi diversi dall'input'
    DELETE rt_group WHERE fieldname NE iv_group_name.

  ENDMETHOD.


  METHOD get_detail_value.

    DATA: lt_detail TYPE zsu_es_detail_tt,
          ls_detail TYPE zsu_es_detail.

*  per prestazioni, carichiamo il buffer

    IF mt_customizing_detail IS INITIAL.
      mt_customizing_detail = read_detail( ).
    ENDIF.

    lt_detail = mt_customizing_detail.

    READ TABLE lt_detail INTO ls_detail WITH KEY fieldname         = iv_group_name
                                                 activesystem      = iv_system
                                                 configurationid   = iv_customizingid.
    IF sy-subrc EQ 0.
      rv_value = ls_detail-customizingvalue.
    ENDIF.

  ENDMETHOD.



ENDCLASS.
