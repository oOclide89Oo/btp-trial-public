CLASS zac_cl_customsmd_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-DATA: mt_customizing_single TYPE zac_t_single,
                mt_customizing_master TYPE zac_t_master,
                mt_customizing_detail TYPE zac_t_detail.

    CLASS-METHODS: read_single  RETURNING VALUE(rt_single) TYPE zac_t_single,
                   write_single IMPORTING it_single TYPE zac_t_single  OPTIONAL
                                          is_single TYPE zac_db_single OPTIONAL
                                EXPORTING ev_error  TYPE abap_boolean,
                   read_master  RETURNING VALUE(rt_master) TYPE zac_t_master,
                   read_detail  RETURNING VALUE(rt_detail) TYPE zac_t_detail,
                   write_master IMPORTING it_master TYPE zac_t_master   OPTIONAL
                                          is_master TYPE zac_rap_master OPTIONAL
                                EXPORTING ev_error  TYPE abap_boolean,
                   write_detail IMPORTING it_detail TYPE zac_t_detail   OPTIONAL
                                          is_detail TYPE zac_rap_detail OPTIONAL
                                EXPORTING ev_error  TYPE abap_boolean.
    METHODS: constructor,
             get_detail_group IMPORTING iv_group_name   TYPE zac_fname_master
                                        iv_system       TYPE zac_actsys
                              EXPORTING ev_error        TYPE abap_boolean
                              RETURNING VALUE(rt_group) TYPE zac_t_detail,
             get_detail_value IMPORTING iv_group_name    TYPE zac_fname_master
                                        iv_system        TYPE zac_actsys
                                        iv_customizingid TYPE zac_configurationid
                              EXPORTING ev_error         TYPE abap_boolean
                              RETURNING VALUE(rv_value)  TYPE zac_customvalue.

    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_customsmd_handler IMPLEMENTATION.
  METHOD read_single.
    SELECT * FROM zac_db_single WHERE activesystem EQ @sy-sysid AND inactive EQ @abap_false INTO TABLE @rt_single.
  ENDMETHOD.

  METHOD write_single.
    DATA: lt_single TYPE zac_t_single,
          ls_single TYPE zac_db_single.

    FIELD-SYMBOLS: <fs_single> TYPE zac_db_single.

    IF is_single IS NOT INITIAL.
      MOVE-CORRESPONDING is_single TO ls_single.

      ls_single-last_changed_by = sy-uname.
      GET TIME STAMP FIELD ls_single-last_changed_at.

      IF ls_single-created_by IS INITIAL.
        ls_single-created_by = ls_single-last_changed_by.
        ls_single-created_at = ls_single-last_changed_at.
      ENDIF.

      APPEND ls_single TO lt_single.
    ELSEIF it_single IS NOT INITIAL.
      MOVE-CORRESPONDING it_single TO lt_single.

      LOOP AT lt_single ASSIGNING <fs_single>.
        <fs_single>-last_changed_by = sy-uname.
        GET TIME STAMP FIELD <fs_single>-last_changed_at.

        IF <fs_single> IS INITIAL.
          <fs_single>-created_by = <fs_single>-last_changed_by.
          <fs_single>-created_at = <fs_single>-last_changed_at.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF lt_single IS NOT INITIAL.
      MODIFY zac_db_single FROM TABLE @lt_single.

      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    mt_customizing_single = read_single( ).
    mt_customizing_detail = read_detail( ).
    mt_customizing_master = read_master( ).
  ENDMETHOD.

  METHOD read_detail.
    SELECT * FROM zac_rap_detail WHERE activesystem EQ @sy-sysid AND inactive EQ @abap_false INTO TABLE @rt_detail.
  ENDMETHOD.

  METHOD read_master.
    SELECT * FROM zac_rap_master WHERE activesystem EQ @sy-sysid AND inactive EQ @abap_false INTO TABLE @rt_master.
  ENDMETHOD.

  METHOD write_detail.
    DATA: lt_detail_db TYPE zac_t_detail,
          ls_detail_db TYPE zac_rap_detail.

    FIELD-SYMBOLS: <fs_detail_db> TYPE zac_rap_detail.

    IF is_detail IS NOT INITIAL.
      MOVE-CORRESPONDING is_detail TO ls_detail_db.

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
          <fs_detail_db>-created_at = <fs_detail_db>-last_changed_at.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF lt_detail_db IS NOT INITIAL.
      MODIFY zac_rap_detail FROM TABLE @lt_detail_db.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD write_master.
    DATA: lt_master_db TYPE zac_t_master,
          ls_master_db TYPE zac_rap_master.

    FIELD-SYMBOLS: <fs_master_db> TYPE zac_rap_master.

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
      MODIFY zac_rap_master FROM TABLE @lt_master_db.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_detail_group.
    IF mt_customizing_detail IS INITIAL.
      mt_customizing_detail = read_detail( ).
    ENDIF.

    rt_group = mt_customizing_detail.

    DELETE rt_group WHERE activesystem NE iv_system.
    DELETE rt_group WHERE fieldname NE iv_group_name.
  ENDMETHOD.

  METHOD get_detail_value.
    DATA: lt_detail TYPE zac_t_detail,
          ls_detail TYPE zac_rap_detail.

    IF mt_customizing_detail IS INITIAL.
      mt_customizing_detail = read_detail( ).
    ENDIF.

    lt_detail = mt_customizing_detail.

    READ TABLE lt_detail INTO ls_detail WITH KEY fieldname       = iv_group_name
                                                 activesystem    = iv_system
                                                 configurationid = iv_customizingid.

    IF sy-subrc EQ 0.
      rv_value = ls_detail-customizingvalue.
    ENDIF.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.

ENDCLASS.
