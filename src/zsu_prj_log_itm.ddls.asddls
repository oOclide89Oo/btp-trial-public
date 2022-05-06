@EndUserText.label: 'Log Item Projection View'
@AccessControl.authorizationCheck: #CHECK

@UI: {
  headerInfo: { typeName: 'LogItem',
                typeNamePlural: 'LogItems',
                title: { type: #STANDARD, value: 'Logid' }
  }
}

@Search.searchable: true

define view entity ZSU_PRJ_LOG_ITM
  as projection on ZSU_CDS_LOG_ITM
{
      @UI.facet: [ { id:            'LogItem',
                           purpose:       #STANDARD,
                           type:          #IDENTIFICATION_REFERENCE,
                           label:         'LogItem',
                           position:      10 }]

      @Search.defaultSearchElement: true
  key Loguuid,
      @UI: { lineItem:       [ { position: 20, importance: #HIGH } ],
         identification: [ { position: 20 } ] }
      @Search.defaultSearchElement: true
  key Logid,
      @UI: { lineItem:       [ { position: 30, importance: #HIGH } ],
         identification: [ { position: 30 } ]
          }
      @Search.defaultSearchElement: true
  key Activesystem,
      @UI: { lineItem:       [ { position: 40, importance: #HIGH } ],
             identification: [ { position: 40 } ]
              }
      ClassName,
      @UI: { lineItem:       [ { position: 50, importance: #HIGH } ],
       identification: [ { position: 50 } ]
        }
      MethodName,
      @UI: { lineItem:       [ { position: 60, importance: #HIGH } ],
       identification: [ { position: 60 } ]
        }
      Type,
      @UI: { lineItem:       [ { position: 70, importance: #HIGH } ],
       identification: [ { position: 70 } ]
        }

      Msg,
      @UI: { lineItem:       [ { position: 80, importance: #HIGH } ],
       identification: [ { position: 80 } ]
        }
      QueryXml,
      @UI: { lineItem:       [ { position: 90, importance: #HIGH } ],
       identification: [ { position: 90 } ]
        }
      @ObjectModel.text.element: ['ResultXml']
      ResultXml,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      CreatedAt,
      @UI: { lineItem:       [ { position: 100, importance: #HIGH } ],
       identification: [ { position: 100 } ]
        }
      LastChangedBy,
      @UI: { lineItem:       [ { position: 110, importance: #HIGH } ],
       identification: [ { position: 110 } ]
        }
      LastChangedAt,
      /* Associations */
      _LogHeader : redirected to parent ZSU_PRJ_LOG_GROUP
}
