@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forAC_DTL'
@ObjectModel.semanticKey: [ 'ConfigurationID' ]
@Search.searchable: true
define view entity ZC_CORSO_AC_DTL
  as projection on ZI_CORSO_AC_DTL
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key ConfigurationID,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key Fieldname,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key Activesystem,
  Customizingvalue,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  Inactive,
  _AC_MSTR : redirected to parent ZC_CORSO_AC_MSTR,
  _AC_MSTR_S : redirected to ZC_CORSO_AC_MSTR_S,
  SingletonID
  
}
