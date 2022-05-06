@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forES_MASTER_S'
define root view entity ZI_SILES_MASTER_S
  as select from I_Language
    left outer join ZSU_ES_MASTER as child_tab on 0 = 0
  composition [0..*] of ZI_SILES_MASTER as _ES_MASTER
{
  key 1 as SingletonID,
  _ES_MASTER,
  max (child_tab.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as sxco_transport) as Request,
  cast( 'X' as abap_boolean) as HideTransport
  
}
where I_Language.Language = $session.system_language
