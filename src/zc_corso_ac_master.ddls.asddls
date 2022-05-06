@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forAC_MASTER'
@ObjectModel.semanticKey: [ 'Fieldname' ]
@Search.searchable: true
define view entity ZC_CORSO_AC_MASTER
  as projection on ZI_CORSO_AC_MASTER
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
  _AC_DETAIL : redirected to composition child ZC_CORSO_AC_DETAIL,
  _AC_MASTER_S : redirected to parent ZC_CORSO_AC_MASTER_S,
  SingletonID
  
}
