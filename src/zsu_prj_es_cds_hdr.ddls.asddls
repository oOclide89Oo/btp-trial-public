@EndUserText.label: 'Endpoints Customizing Table Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@UI: {
  headerInfo: { typeName: 'Endpoint', typeNamePlural: 'Endpoints', title: { type: #STANDARD, value: 'Fieldname' } } }
define root view entity ZSU_PRJ_ES_CDS_HDR
  as projection on ZSU_ES_CDS_HDR
{
      @UI.facet: [ { id:              'Endpoint',
                       purpose:         #STANDARD,
                       type:            #IDENTIFICATION_REFERENCE,
                       label:           'Endpoint',
                       position:        10 } ]

      @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
      @ObjectModel.text.element: ['Fieldname']
      @Search.defaultSearchElement: true
  key Fieldname,
      @UI: {
            lineItem:       [ { position: 20, importance: #HIGH } ],
            identification: [ { position: 20 } ],
            selectionField: [ { position: 20 } ] }
      @ObjectModel.text.element: ['Activesystem']
      @Search.defaultSearchElement: true
  key Activesystem,
      @UI: {
            lineItem:       [ { position: 30, importance: #HIGH } ],
            identification: [ { position: 30 } ],
            selectionField: [ { position: 30 } ] }
      @ObjectModel.text.element: ['Fieldvalue']
      Fieldvalue,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      LastChangedBy,
      @UI.hidden: true
      LastChangedAt,
      @UI: {
            lineItem:       [ { position: 40, importance: #HIGH } ],
            identification: [ { position: 40 } ],
            selectionField: [ { position: 40 } ] }
      Inactive
}


