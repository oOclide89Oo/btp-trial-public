@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Log Group Core Data Service'
define root view entity ZSU_CDS_LOG_GROUP 
as select from zsu_log_group as Log
composition [0..*] of ZSU_CDS_LOG_ITM as _LogItem {
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
