@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forAC_DETAIL'
define view entity ZI_CORSO_AC_DETAIL
  as select from ZRAP_AC_DETAIL
  association to parent ZI_CORSO_AC_MASTER as _AC_MASTER on $projection.Fieldname = _AC_MASTER.Fieldname and $projection.Activesystem = _AC_MASTER.Activesystem
  association [1] to ZI_CORSO_AC_MASTER_S as _AC_MASTER_S on $projection.SingletonID = _AC_MASTER_S.SingletonID
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
  _AC_MASTER,
  _AC_MASTER_S,
  1 as SingletonID
  
}
