@EndUserText.label: 'Log WEB API Core Data Service'
@ObjectModel.query.implementedBy: 'ABAP:ZAC_CL_QUERY2'
define root custom entity ZAC_CDS_UNMAN_LOG 
{
  key logid   : zac_fieldname;
  type        : bapi_mtype;
  msg         : bapi_msg;
  query_xml   : zac_jsonfile;
  result_xml  : zac_jsonfile;
}
