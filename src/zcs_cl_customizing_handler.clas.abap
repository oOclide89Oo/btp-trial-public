CLASS zcs_cl_customizing_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    CLASS-DATA: mt_customizing_group  TYPE zcs_t_customizing_master, "Tabella master dei gruppi
                mt_customizing_detail TYPE zcs_t_customizing_detail. "Tabella dei dettagli


    CLASS-METHODS:
      read_master_group RETURNING VALUE(rt_master_group) TYPE zcs_t_customizing_master, "in una variabile di uscita va a mettere la lettura della master

      read_detail       RETURNING VALUE(rt_detail) TYPE zcs_t_customizing_detail,

      write_master_group IMPORTING it_master TYPE zcs_t_customizing_master OPTIONAL
                                   is_master TYPE zrap_c_master OPTIONAL
                         EXPORTING ev_error  TYPE abap_boolean,
      write_detail_group IMPORTING it_detail TYPE zcs_t_customizing_detail OPTIONAL
                                   is_detail TYPE zrap_c_detail OPTIONAL
                         EXPORTING ev_error  TYPE abap_boolean. "in una variabile di uscita va a mettere la lettura della detail.



    METHODS: constructor,
      get_detail_group IMPORTING iv_group_name   TYPE zrap_c_detail-fieldname
                                 iv_system       TYPE zrap_c_detail-activesystem
                       EXPORTING ev_error        TYPE abap_boolean
                       RETURNING VALUE(rt_group) TYPE zcs_t_customizing_detail,
      get_detail_value IMPORTING iv_group_name    TYPE zrap_c_detail-fieldname
                                 iv_system        TYPE zrap_c_detail-activesystem
                                 iv_customizingid TYPE zrap_c_detail-configurationid
                       EXPORTING ev_error         TYPE abap_boolean
                       RETURNING VALUE(rv_value)  TYPE zrap_c_detail-customizingvalue.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcs_cl_customizing_handler IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.
  METHOD constructor.

    mt_customizing_group  = read_master_group( ).
    mt_customizing_detail = read_detail( ).

  ENDMETHOD.

  METHOD read_detail.
    SELECT * FROM zrap_c_detail "prendi tutte le linee
    WHERE activesystem EQ @sy-sysid AND inactive EQ @abap_false " che hanno questa condizione
    INTO TABLE @rt_detail. " mettile in questa

  ENDMETHOD.

  METHOD read_master_group.
    SELECT * FROM zrap_c_master "prendi tutte le linee
    WHERE activesystem EQ @sy-sysid AND inactive EQ @abap_false " che hanno questa condizione
    INTO TABLE @rt_master_group. " mettile in questa

  ENDMETHOD.


  METHOD write_detail_group.
    DATA: lt_detail_db TYPE zcs_t_customizing_detail,
          ls_detail_db TYPE zrap_c_detail.

    FIELD-SYMBOLS: <fs_detail_db> TYPE zrap_c_detail. "Sono il riferimento a db della linea/o della variabile che sto usando

    IF is_detail IS NOT INITIAL.
      MOVE-CORRESPONDING is_detail TO ls_detail_db.
**********************************************************************
* Gestisco i parametri di edit
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
      MODIFY zrap_c_detail FROM TABLE @lt_detail_db.
      IF sy-subrc NE 0. "QUALCOSA NON VA
        ev_error = abap_true.
      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD write_master_group.
    DATA: lt_master_db TYPE zcs_t_customizing_master,
          ls_master_db TYPE zrap_c_master.

    FIELD-SYMBOLS: <fs_master_db> TYPE zrap_c_master.

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
      MODIFY zrap_c_master FROM TABLE @lt_master_db.
      IF sy-subrc NE 0.
        ev_error = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_detail_group.

***
*  per prestazioni, carichiamo il buffer
**
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
    DATA: lt_detail TYPE zcs_t_customizing_detail,
          ls_detail TYPE zrap_c_detail.
***
*  per prestazioni, carichiamo il buffer
**
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
