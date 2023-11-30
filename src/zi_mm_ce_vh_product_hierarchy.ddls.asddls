@EndUserText.label: 'Custom Entity - Search Help: Product Hierarchy'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_VH_PRODUCT_HIERARCHY'
@Search.searchable:true
define custom entity ZI_MM_CE_VH_PRODUCT_HIERARCHY
{
      @Search              : { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @ObjectModel.text.element: ['ProductHierarchyText']
      @EndUserText.label   : 'Hierarquia de produtos'
  key ProductHierarchy     : abap.char(18);
      @Search              : { defaultSearchElement: true, ranking: #LOW, fuzzinessThreshold: 0.7 }
      @EndUserText.label   : 'Descrição hierarquia de produtos'
      ProductHierarchyText : abap.char(40);

}
