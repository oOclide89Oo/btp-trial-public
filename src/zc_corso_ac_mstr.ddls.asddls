@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forAC_MSTR'
@ObjectModel.semanticKey: [ 'Fieldname' ]
@Search.searchable: true
define view entity ZC_CORSO_AC_MSTR
  as projection on ZI_CORSO_AC_MSTR
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key Fieldname,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key Activesystem,
  Fieldvalue,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  Inactive,
  _AC_DTL : redirected to composition child ZC_CORSO_AC_DTL,
  _AC_MSTR_S : redirected to parent ZC_CORSO_AC_MSTR_S,
  SingletonID
  
}
