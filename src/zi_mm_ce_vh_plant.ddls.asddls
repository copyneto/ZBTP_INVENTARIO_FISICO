@EndUserText.label: 'Custom Entity - Search Help: Plant'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_VH_PLANT'
@Search.searchable: true
define custom entity ZI_MM_CE_VH_PLANT
{
  
      @UI.selectionField : [{ position: 10 }]
      @UI.lineItem       : [{ position: 10 }]
      
      @EndUserText.label: 'Centro'
      @ObjectModel.text.element: ['PlantName']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.sort.enabled: false -- Custom Entity não funciona sem isso, pois por default o campo chave vem ordenado e gera uma exceção
  key Plant     : abap.char(4);
  
      @UI.selectionField : [{ position: 20 }]
      @UI.lineItem       : [{ position: 20 }]
      
      @EndUserText.label: 'Descrição do centro'
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @ObjectModel.sort.enabled: false
      PlantName : abap.char(30);

}
