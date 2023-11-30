@EndUserText.label: 'Custom Entity - Search Help: Material'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_VH_MATERIAL'

define custom entity ZI_MM_CE_VH_MATERIAL
{
  
      @UI.selectionField : [{ position: 10 }]
      @UI.lineItem       : [{ position: 10 }]
      
      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['MaterialName']
  key Material     : abap.char( 18 );
  
      @UI.selectionField : [{ position: 20 }]
      @UI.lineItem       : [{ position: 20 }]
  
      @EndUserText.label: 'Nome do Material'
      @Semantics.text: true
      @EndUserText.quickInfo: 'Nome do Material'
      MaterialName : abap.char( 40 );

}
