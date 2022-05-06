@EndUserText.label: 'Log WEB API Core Data Service'
@ObjectModel.query.implementedBy: 'ABAP:ZAC_CL_QUERY'
define root custom entity ZAC_CDS_UNM_LOG 
{
  key logid   : zac_fieldname;
  type        : bapi_mtype;
  msg         : bapi_msg;
  query_xml   : zac_jsonfile;
  result_xml  : zac_jsonfile;
  
}
