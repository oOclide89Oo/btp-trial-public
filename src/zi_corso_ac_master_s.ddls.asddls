@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forAC_MASTER_S'
define root view entity ZI_CORSO_AC_MASTER_S
  as select from I_Language
    left outer join ZRAP_AC_MASTER as child_tab on 0 = 0
  composition [0..*] of ZI_CORSO_AC_MASTER as _AC_MASTER
{
  key 1 as SingletonID,
  _AC_MASTER,
  max (child_tab.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as sxco_transport) as Request,
  cast( 'X' as abap_boolean) as HideTransport
  
}
where I_Language.Language = $session.system_language
