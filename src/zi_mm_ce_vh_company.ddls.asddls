@EndUserText.label: 'Custom Entity - Search Help: Company'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_VH_COMPANY'
@Search.searchable: true
define custom entity ZI_MM_CE_VH_COMPANY
{
  
      @UI.selectionField : [{ position: 10 }]
      @UI.lineItem       : [{ position: 10 }]
      
      @Search         : { defaultSearchElement: true, fuzzinessThreshold: 0.8, ranking: #HIGH  }
      @ObjectModel    : { text.element: ['CompanyCodeName'],
                          sort.enabled: false }
      @EndUserText.label: 'Empresa'
  key CompanyCode     : abap.char(4);
  
      @UI.selectionField : [{ position: 20 }]
      @UI.lineItem       : [{ position: 20 }]

      @Semantics.text : true
      @Search         : { defaultSearchElement: true, fuzzinessThreshold: 0.8, ranking: #LOW  }
      @ObjectModel.sort.enabled: false
      @EndUserText.label: 'Descrição da empresa'
      CompanyCodeName : abap.char(25);

}
