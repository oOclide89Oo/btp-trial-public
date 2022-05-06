@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forES_MASTER'
@ObjectModel.semanticKey: [ 'Fieldname' ]
@Search.searchable: true
define view entity ZC_SILES_MASTER
  as projection on ZI_SILES_MASTER
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
  _ES_DETAIL : redirected to composition child ZC_SILES_DETAIL,
  _ES_MASTER_S : redirected to parent ZC_SILES_MASTER_S,
  SingletonID
  
}
