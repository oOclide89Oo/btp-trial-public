@EndUserText.label: 'Log Group Projection View'
@AccessControl.authorizationCheck: #CHECK

@UI: {
  headerInfo: { typeName: 'Log', typeNamePlural: 'Logs', title: { type: #STANDARD, value: 'Logid' } } }

@Search.searchable: true
define root view entity ZSU_PRJ_LOG_GROUP
  as projection on ZSU_CDS_LOG_GROUP
{
      @UI.facet: [ { id:'Log',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Log',
                     position:        10 } ,
                            { id:              'LogItem',
                              purpose:         #STANDARD,
                              type:            #LINEITEM_REFERENCE,
                              label:           'LogItem',
                              position:        20,
                              targetElement:   '_LogItem'}]

      @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ] }
      @Search.defaultSearchElement: true
  key Logid,
      @UI: {
        lineItem:       [ { position: 20, importance: #HIGH } ],
        identification: [ { position: 20 } ],
        selectionField: [ { position: 20 } ] }
      @ObjectModel.text.element: ['Activesystem']
      @Search.defaultSearchElement: true
  key Activesystem,

      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      CreatedAt,
      @UI: {
      lineItem:       [ { position: 30, importance: #HIGH } ],
      identification: [ { position: 30 } ],
      selectionField: [ { position: 30 } ] }
      @ObjectModel.text.element: ['LastChangedBy']
      @Search.defaultSearchElement: true
      LastChangedBy,
      @UI: {
      lineItem:       [ { position: 40, importance: #HIGH } ],
      identification: [ { position: 40 } ],
      selectionField: [ { position: 40 } ] }
      @ObjectModel.text.element: ['LastChangedAt']
      @Search.defaultSearchElement: true
      LastChangedAt,

      /* Associations */
      _LogItem : redirected to composition child ZSU_PRJ_LOG_ITM
}
