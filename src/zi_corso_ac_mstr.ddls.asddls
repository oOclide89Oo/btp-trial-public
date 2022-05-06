@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forAC_MSTR'
define view entity ZI_CORSO_AC_MSTR
  as select from ZAC_RAP_MASTER
  association to parent ZI_CORSO_AC_MSTR_S as _AC_MSTR_S on $projection.SingletonID = _AC_MSTR_S.SingletonID
  composition [0..*] of ZI_CORSO_AC_DTL as _AC_DTL
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
  _AC_DTL,
  _AC_MSTR_S,
  1 as SingletonID
  
}
