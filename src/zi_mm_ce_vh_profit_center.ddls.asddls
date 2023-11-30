@EndUserText.label: 'Custom Entity - Search Help: Profit center'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_VH_PROFIT_CENTER'
@Search.searchable: true
define custom entity ZI_MM_CE_VH_PROFIT_CENTER
{
      @ObjectModel.text.element: ['ProfitCenterName']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking  : #HIGH
      @EndUserText.label  : 'Centro de lucro'
  key ProfitCenter     : abap.char(10);
      @Semantics.text  : true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking  : #HIGH
      @EndUserText.label  : 'Descrição do centro de lucro'
      ProfitCenterName : abap.char(20);

}
