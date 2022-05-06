@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'custom table cds esercizio silvio'
define root view entity ZSU_ES_CDS_HDR as select from zsu_es_hdr
{
    key fieldname as Fieldname,
    key activesystem as Activesystem,
    fieldvalue as Fieldvalue,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    inactive as Inactive

}
