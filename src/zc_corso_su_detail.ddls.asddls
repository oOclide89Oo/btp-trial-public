@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forSU_DETAIL'
@ObjectModel.semanticKey: [ 'ConfigurationID' ]
@Search.searchable: true
define view entity ZC_CORSO_SU_DETAIL
  as projection on ZI_CORSO_SU_DETAIL
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
  _SU_MASTER : redirected to parent ZC_CORSO_SU_MASTER,
  _SU_MASTER_S : redirected to ZC_CORSO_SU_MASTER_S,
  SingletonID
  
}
