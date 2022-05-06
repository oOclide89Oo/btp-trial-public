@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forES_DETAIL'
define view entity ZI_SILES_DETAIL
  as select from ZSU_ES_DETAIL
  association to parent ZI_SILES_MASTER as _ES_MASTER on $projection.Fieldname = _ES_MASTER.Fieldname and $projection.Activesystem = _ES_MASTER.Activesystem
  association [1] to ZI_SILES_MASTER_S as _ES_MASTER_S on $projection.SingletonID = _ES_MASTER_S.SingletonID
{
  key CONFIGURATIONID as ConfigurationID,
  key FIELDNAME as Fieldname,
  key ACTIVESYSTEM as Activesystem,
  CUSTOMIZINGVALUE as Customizingvalue,
  @Semantics.user.createdBy: true
  CREATED_BY as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  CREATED_AT as CreatedAt,
  @Semantics.user.lastChangedBy: true
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  INACTIVE as Inactive,
  _ES_MASTER,
  _ES_MASTER_S,
  1 as SingletonID
  
}
