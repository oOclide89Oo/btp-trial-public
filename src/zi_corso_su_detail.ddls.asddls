@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forSU_DETAIL'
define view entity ZI_CORSO_SU_DETAIL
  as select from ZRAP_SU_DETAIL
  association to parent ZI_CORSO_SU_MASTER as _SU_MASTER on $projection.Fieldname = _SU_MASTER.Fieldname and $projection.Activesystem = _SU_MASTER.Activesystem
  association [1] to ZI_CORSO_SU_MASTER_S as _SU_MASTER_S on $projection.SingletonID = _SU_MASTER_S.SingletonID
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
  _SU_MASTER,
  _SU_MASTER_S,
  1 as SingletonID
  
}
