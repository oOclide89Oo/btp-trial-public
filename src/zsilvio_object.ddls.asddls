@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'prova'
define root view entity ZSILVIO_OBJECT as select from zdb_silvio {
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
