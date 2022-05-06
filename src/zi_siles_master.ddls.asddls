@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forES_MASTER'
define view entity ZI_SILES_MASTER
  as select from ZSU_ES_MASTER
  association to parent ZI_SILES_MASTER_S as _ES_MASTER_S on $projection.SingletonID = _ES_MASTER_S.SingletonID
  composition [0..*] of ZI_SILES_DETAIL as _ES_DETAIL
{
  key FIELDNAME as Fieldname,
  key ACTIVESYSTEM as Activesystem,
  FIELDVALUE as Fieldvalue,
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
  _ES_DETAIL,
  _ES_MASTER_S,
  1 as SingletonID
  
}
