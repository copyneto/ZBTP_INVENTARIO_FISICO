@EndUserText.label: 'Search Help: Storage Location'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_VH_STORAGE_LOCATION'
@Search.searchable: true
define custom entity ZI_MM_CE_VH_STORAGE_LOCATION
{
  
      @UI.selectionField : [{ position: 30 }]
      @UI.lineItem       : [{ position: 30 }]
      
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking     : #HIGH
      @ObjectModel.text.element: ['PlantName']
      @EndUserText.label  : 'Centro'
  key Plant               : abap.char(4);
  
      @UI.selectionField : [{ position: 10 }]
      @UI.lineItem       : [{ position: 10 }]

      @ObjectModel.text.element: ['StorageLocationName']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking     : #HIGH
      @EndUserText.label  : 'Depósito'
  key StorageLocation     : abap.char(4);
  
      @UI.selectionField : [{ position: 40 }]
      @UI.lineItem       : [{ position: 40 }]

      @Semantics.text     : true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking     : #HIGH
      @EndUserText.label  : 'Descrição do depósito'
      StorageLocationName : abap.char(16);
  
      @UI.selectionField : [{ position: 20 }]
      @UI.lineItem       : [{ position: 20 }]
      
      @Semantics.text     : true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking     : #HIGH
      @EndUserText.label  : 'Descrição do centro'
      PlantName           : abap.char(30);

}
