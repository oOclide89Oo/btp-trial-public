CLASS zac_cl_application_job_creator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS: create_application_log_object,
                   create_job_entry_and_catalog.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_application_job_creator IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.

  METHOD create_application_log_object.

    DATA(lo_log_object) = cl_bali_object_handler=>get_instance( ).
    DATA: ls_subobject TYPE LINE OF if_bali_object_handler=>ty_tab_subobject,
          lt_subobject TYPE if_bali_object_handler=>ty_tab_subobject.
    DATA lt_subobj TYPE cl_bali_object_handler=>ty_tab_subobject.
    DATA ls_subobj LIKE LINE OF lt_subobj.

    TRY.

        ls_subobj-subobject = 'ZCS_SUBOBJ'.
        ls_subobj-subobject_text = 'Log di Claudio'.
        APPEND ls_subobj TO lt_subobj.

        CLEAR ls_subobj.

        ls_subobj-subobject = 'ZAC_SUBOBJ'.
        ls_subobj-subobject_text = 'Log di Andrea'.
        APPEND ls_subobj TO lt_subobj.

        CLEAR ls_subobj.

        ls_subobj-subobject = 'ZSU_SUBOBJ'.
        ls_subobj-subobject_text = 'Log di Silvio'.
        APPEND ls_subobj TO lt_subobj.

        lo_log_object->create_object( EXPORTING iv_object               = 'ZLOGOBJECT'
                                                iv_object_text          = 'Header del nostro log object'
                                                it_subobjects           = lt_subobj
                                                iv_package              = 'ZCS_RAP_NEW'
                                                iv_transport_request    = 'TRLK908961' ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

  METHOD create_job_entry_and_catalog.

    DATA(lo_dt) = cl_apj_dt_create_content=>get_instance( ).

    DATA: c_catalog_name      TYPE cl_apj_dt_create_content=>ty_catalog_name VALUE 'ZAC_APJ_CATALOG',

          c_catalog_text      TYPE cl_apj_dt_create_content=>ty_text VALUE 'Esempio Oggetto Catalog',

          c_class_name        TYPE cl_apj_dt_create_content=>ty_class_name VALUE 'ZAC_CL_APPLICATION_JOB',

          c_template_name     TYPE cl_apj_dt_create_content=>ty_template_name VALUE 'ZAC_APJ_TEMPLATE',

          c_template_text     TYPE cl_apj_dt_create_content=>ty_text VALUE 'Esempio Job Template',

          c_transport_request TYPE cl_apj_dt_create_content=>ty_transport_request VALUE 'TRLK908961',

          c_package           TYPE cl_apj_dt_create_content=>ty_package VALUE 'ZCS_RAP_NEW'.

    TRY.
        lo_dt->create_job_cat_entry(
            iv_catalog_name       = c_catalog_name
            iv_class_name         = c_class_name
            iv_text               = c_catalog_text
            iv_catalog_entry_type = cl_apj_dt_create_content=>class_based
            iv_transport_request  = c_transport_request
            iv_package            = c_package
        ).

      CATCH cx_apj_dt_content INTO DATA(lx_apj_dt_content).
    ENDTRY.

    DATA lt_parameters TYPE if_apj_dt_exec_object=>tt_templ_val.

    NEW zac_cl_application_job( )->if_apj_dt_exec_object~get_parameters(
      IMPORTING
        et_parameter_val = lt_parameters
    ).

    TRY.
        lo_dt->create_job_template_entry(
            iv_template_name     = c_template_name
            iv_catalog_name      = c_catalog_name
            iv_text              = c_template_text
            it_parameters        = lt_parameters
            iv_transport_request = c_transport_request
            iv_package           = c_package
        ).

      CATCH cx_apj_dt_content INTO lx_apj_dt_content.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
