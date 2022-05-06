@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Log Item Core Data Service'
define view entity ZSU_CDS_LOG_ITM as select from zsu_log_item as LogItem
association to parent ZSU_CDS_LOG_GROUP as _LogHeader on  $projection.Logid = _LogHeader.Logid
                                                     and $projection.Activesystem = _LogHeader.Activesystem 
{
    key loguuid as Loguuid,
    key logid as Logid,
    key activesystem as Activesystem,
    class_name as ClassName,
    method_name as MethodName,
    type as Type,
    msg as Msg,
    query_xml as QueryXml,
    result_xml as ResultXml,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    
    _LogHeader
}
