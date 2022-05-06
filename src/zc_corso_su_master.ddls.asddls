@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forSU_MASTER'
@ObjectModel.semanticKey: [ 'Fieldname' ]
@Search.searchable: true
define view entity ZC_CORSO_SU_MASTER
  as projection on ZI_CORSO_SU_MASTER
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
  _SU_DETAIL : redirected to composition child ZC_CORSO_SU_DETAIL,
  _SU_MASTER_S : redirected to parent ZC_CORSO_SU_MASTER_S,
  SingletonID
  
}
