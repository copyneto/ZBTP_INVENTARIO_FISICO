@EndUserText.label: 'Custom Entity - Search Help: Batch'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_VH_BATCH'
@Search.searchable: true
define custom entity ZI_MM_CE_VH_BATCH
{
      @ObjectModel.text.element: ['PlantName']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.sort.enabled: false
      @EndUserText.label: 'Centro'
  key Plant        : abap.char(4);
      @ObjectModel.text.element: ['MaterialName']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.sort.enabled: false
      @EndUserText.label: 'Material'
  key Material     : abap.char(40);
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.sort.enabled: false
      @EndUserText.label: 'Lote'
  key Batch        : abap.char(10);
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.sort.enabled: false
      @EndUserText.label: 'Descrição do material'
      MaterialName : abap.char(40);
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.sort.enabled: false
      @EndUserText.label: 'Descrição do centro'
      PlantName    : abap.char(30);
}
