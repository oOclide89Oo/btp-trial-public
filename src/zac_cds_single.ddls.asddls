@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Single Table Data Definition'
define root view entity ZAC_CDS_SINGLE as select from zac_db_single{
    key fieldname as Fieldname,
    key activesystem as Activesystem,
    fieldvalue as Fieldvalue,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt,
    inactive as Inactive
}
