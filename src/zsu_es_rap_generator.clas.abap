CLASS zsu_es_rap_generator DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS main REDEFINITION.
    METHODS get_json_string
      RETURNING VALUE(json_string) TYPE string.
  PRIVATE SECTION.

ENDCLASS.



CLASS zsu_es_rap_generator IMPLEMENTATION.


  METHOD get_json_string.


*Master Detail Model Example
json_string = ' { ' && |\r\n| &&
    ' "$schema": "https://raw.githubusercontent.com/SAP-samples/cloud-abap-rap/main/json_schemas/RAPGenerator-schema-all.json", ' && |\r\n| &&
    ' "namespace": "Z", ' && |\r\n| &&
    ' "package": "ZCS_RAP_NEW", ' && |\r\n| &&
    ' "dataSourceType": "table", ' && |\r\n| &&
    ' "multiInlineEdit": true, ' && |\r\n| &&
    ' "isCustomizingTable": true, ' && |\r\n| &&
    ' "addBusinessConfigurationRegistration": false, ' && |\r\n| &&
    ' "implementationtype": "managed_semantic", ' && |\r\n| &&
    ' "bindingType": "odata_v4_ui", ' && |\r\n| &&
    ' "prefix": "SIL", ' && |\r\n| &&
    ' "suffix": "", ' && |\r\n| &&
    ' "transportrequest": "TRLK908961", ' && |\r\n| &&
    ' "draftenabled": true, ' && |\r\n| &&
    ' "hierarchy": { ' && |\r\n| &&
    '    "entityName": "ES_MASTER", ' && |\r\n| &&
    '    "dataSource": "ZSU_ES_MASTER", ' && |\r\n| &&
    '    "objectId": "fieldname", ' && |\r\n| &&
    '    "localInstanceLastChangedAt": "local_last_changed_at", ' && |\r\n| &&
    '    "etagMaster": "local_last_changed_at", ' && |\r\n| &&
    '    "totalEtag" : "last_changed_at", ' && |\r\n| &&
    '         "children": [ ' && |\r\n| &&
    '            { ' && |\r\n| &&
    '                "entityName": "ES_DETAIL", ' && |\r\n| &&
    '                "dataSource": "ZSU_ES_DETAIL", ' && |\r\n| &&
    '                "objectId": "configurationid" , ' && |\r\n| &&
    '                "localInstanceLastChangedAt": "local_last_changed_at", ' && |\r\n| &&
    '                "etagMaster": "local_last_changed_at", ' && |\r\n| &&
    '                "totalEtag" : "last_changed_at" ' && |\r\n| &&
    '            } ' && |\r\n| &&
    '        ] ' && |\r\n| &&
    ' } ' && |\r\n| &&
' } ' .

  ENDMETHOD.


  METHOD main.
    TRY.
        DATA(json_string) = get_json_string(  ).
        DATA(rap_generator) = /dmo/cl_rap_generator=>create_for_cloud_development( json_string ).
        "DATA(rap_generator) = /dmo/cl_rap_generator=>create_for_S4_2020_development( json_string ).
        DATA(framework_messages) = rap_generator->generate_bo( ).
        IF rap_generator->exception_occured( ).
          out->write( |Caution: Exception occured | ) .
          out->write( |Check repository objects of RAP BO { rap_generator->get_rap_bo_name(  ) }.| ) .
        ELSE.
          out->write( |RAP BO { rap_generator->get_rap_bo_name(  ) }  generated successfully| ) .
        ENDIF.
        out->write( |Messages from framework:| ) .
        LOOP AT framework_messages INTO DATA(framework_message).
          out->write( framework_message ).
        ENDLOOP.
      CATCH /dmo/cx_rap_generator INTO DATA(rap_generator_exception).
        out->write( 'RAP Generator has raised the following exception:' ) .
        out->write( rap_generator_exception->get_text(  ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
