CLASS zac_cl_customizing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-DATA: mt_customizing TYPE zac_detail_tt.
    METHODS constructor.
    CLASS-METHODS return_method RETURNING VALUE(return_val) TYPE zac_detail_tt.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zac_cl_customizing IMPLEMENTATION.

  METHOD constructor.
    SELECT * FROM zrap_ac_detail INTO TABLE @mt_customizing.
  ENDMETHOD.

  METHOD return_method.
    return_val = mt_customizing.
  ENDMETHOD.

ENDCLASS.
