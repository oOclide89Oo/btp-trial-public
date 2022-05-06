@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forSU_MASTER_S'
@ObjectModel.semanticKey: [ 'SingletonID' ]
@Search.searchable: true
define root view entity ZC_CORSO_SU_MASTER_S
  as projection on ZI_CORSO_SU_MASTER_S
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key SingletonID,
  _SU_MASTER : redirected to composition child ZC_CORSO_SU_MASTER,
  LastChangedAtMax,
  Request,
  HideTransport
  
}
