@EndUserText.label: 'Cockpit de Inventário - Cabeçalho'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['DocumentNo']

define root view entity ZC_MM_INVENTORY_HEAD
  provider contract transactional_query
  as projection on ZI_MM_INVENTORY_HEAD

{
  key DocumentId,
      DocumentNo,
      CountId,
      CountDate,
      @ObjectModel.text.element : ['StatusText']
      StatusId,
      StatusText,
      StatusCrit,
      @ObjectModel.text.element : ['PlantName']
      Plant,
      PlantName,
      Description,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      /* Associations */
      _Item : redirected to composition child ZC_MM_INVENTORY_ITEM,
      _Log  : redirected to composition child ZC_MM_INVENTORY_LOG
}
