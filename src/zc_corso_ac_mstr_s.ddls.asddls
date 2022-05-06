@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forAC_MSTR_S'
@ObjectModel.semanticKey: [ 'SingletonID' ]
@Search.searchable: true
define root view entity ZC_CORSO_AC_MSTR_S
  as projection on ZI_CORSO_AC_MSTR_S
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key SingletonID,
  _AC_MSTR : redirected to composition child ZC_CORSO_AC_MSTR,
  LastChangedAtMax,
  Request,
  HideTransport
  
}
