@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Log Group Core Data Service'
define root view entity ZAC_CDS_LOG_HDR 
as select from zac_db_log_hdr as Log
composition [0..*] of ZAC_CDS_LOG_ITM as _LogItem {
  key logid as Logid,
  key activesystem as Activesystem,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
  
  _LogItem
}
