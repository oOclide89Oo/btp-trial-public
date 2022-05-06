@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forAC_MASTER'
define view entity ZI_CORSO_AC_MASTER
  as select from ZRAP_AC_MASTER
  association to parent ZI_CORSO_AC_MASTER_S as _AC_MASTER_S on $projection.SingletonID = _AC_MASTER_S.SingletonID
  composition [0..*] of ZI_CORSO_AC_DETAIL as _AC_DETAIL
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
  _AC_DETAIL,
  _AC_MASTER_S,
  1 as SingletonID
  
}
