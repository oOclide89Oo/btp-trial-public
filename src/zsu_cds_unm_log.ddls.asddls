@EndUserText.label: 'Log WEB API Core Data Service'
@ObjectModel.query.implementedBy: 'ABAP:ZSU_CL_QUERY'
define root custom entity ZSU_CDS_UNM_LOG  
{
  key logid   : zrap_fieldname;
  type        : bapi_mtype;
  msg         : bapi_msg;
  query_xml   : zsu_jsonfile;
  result_xml  : zsu_jsonfile;
  
}

