@EndUserText.label: 'LOG Custom Core Data Service'
@ObjectModel.query.implementedBy: 'ABAP:ZCS_CL_QUERY_V2'
define root custom entity ZCS_CDS_UNM_LOG_V2 
{
  key logid   : zrap_fieldname;
  type        : bapi_mtype;
  msg         : bapi_msg;
  query_xml   : zac_jsonfile;
  result_xml  : zac_jsonfile;
}
