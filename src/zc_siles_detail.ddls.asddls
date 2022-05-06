@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forES_DETAIL'
@ObjectModel.semanticKey: [ 'ConfigurationID' ]
@Search.searchable: true
define view entity ZC_SILES_DETAIL
  as projection on ZI_SILES_DETAIL
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
  _ES_MASTER : redirected to parent ZC_SILES_MASTER,
  _ES_MASTER_S : redirected to ZC_SILES_MASTER_S,
  SingletonID
  
}
