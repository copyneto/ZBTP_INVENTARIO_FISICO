@EndUserText.label: 'Custom Entity - Search Help: Material'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_VH_MATERIAL'

define custom entity ZI_MM_CE_VH_MATERIAL
{
  
      @UI.selectionField : [{ position: 10 }]
      @UI.lineItem       : [{ position: 10 }]
      
      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['MaterialName']
      @ObjectModel.sort.enabled: false -- Custom Entity não funciona sem isso, pois por default o campo chave vem ordenado e gera uma exceção
  key Material     : abap.char( 18 );
  
      @UI.selectionField : [{ position: 20 }]
      @UI.lineItem       : [{ position: 20 }]
  
      @EndUserText.label: 'Nome do Material'
      @Semantics.text: true
      @EndUserText.quickInfo: 'Nome do Material'
      @ObjectModel.sort.enabled: false
      MaterialName : abap.char( 40 );

}
