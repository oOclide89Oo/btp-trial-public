CLASS zsu_cl_customizing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  class-data:  mt_customizing TYPE ZSU_DETAIL_TT.

  METHODS:constructor.
  CLASS-METHODS:    variabile_statica RETURNING VALUE(rt_customizing) TYPE ZSU_DETAIL_TT.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zsu_cl_customizing IMPLEMENTATION.
  METHOD constructor .
    SELECT * FROM ZRAP_SU_DETAIL INTO TABLE @mt_customizing.
  ENDMETHOD.

  METHOD variabile_statica.
    rt_customizing = mt_customizing.
  ENDMETHOD.

ENDCLASS.
