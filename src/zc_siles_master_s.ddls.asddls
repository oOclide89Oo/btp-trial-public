@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forES_MASTER_S'
@ObjectModel.semanticKey: [ 'SingletonID' ]
@Search.searchable: true
define root view entity ZC_SILES_MASTER_S
  as projection on ZI_SILES_MASTER_S
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key SingletonID,
  _ES_MASTER : redirected to composition child ZC_SILES_MASTER,
  LastChangedAtMax,
  Request,
  HideTransport
  
}
