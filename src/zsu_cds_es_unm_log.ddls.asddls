@EndUserText.label: 'log web api esercizio silvio'
@ObjectModel.query.implementedBy: 'ABAP:ZSU_ES_CL_QUERY'
define root custom entity ZSU_CDS_ES_UNM_LOG 
{
  key logid   : zsu_es_fieldname;
  type        : bapi_mtype;
  msg         : bapi_msg;
  query_xml   : zsu_jsonfile;
  result_xml  : zsu_jsonfile;
}
