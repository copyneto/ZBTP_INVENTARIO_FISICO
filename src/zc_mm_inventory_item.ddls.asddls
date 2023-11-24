@EndUserText.label: 'Cockpit de Inventário - Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['Material', 'Plant']

define view entity ZC_MM_INVENTORY_ITEM
  as projection on ZI_MM_INVENTORY_ITEM

  association [0..1] to ZI_MM_CE_VH_MATERIAL as _Material on _Material.Material = $projection.Material
{
  key DocumentId,
  key DocumentItemId,
      @ObjectModel.text.element : ['StatusText']
      StatusId,
      StatusText,
      StatusCrit,
      @ObjectModel.text.element : ['MaterialName']
      Material,
//      _Material.MaterialName,
      MaterialName,
      @ObjectModel.text.element : ['PlantName']
      Plant,
      PlantName,
      @ObjectModel.text.element : ['StorageLocationName']
      StorageLocation,
      StorageLocationName,
      Batch,
      QuantityStock,
      QuantityCount,
      QuantityCurrent,
      Balance,
      BalanceCurrent,
      Unit,
      PriceStock,
      PriceCount,
      PriceDiff,
      Currency,
      Weight,
      WeightUnit,
//      ProductHierarchy,
      Accuracy,
//      MaterialDocumentYear,
//      MaterialDocument,
//      PostingDate,
//      BR_NotaFiscal,
//      AccountingDocument,
//      AccountingDocumentYear,
//      InvoiceReference,
//      DocumentDate,
//      BR_NFeNumber,
//      BR_NFIsCanceled,
//      BR_NFeDocumentStatus,
//      BR_NFeDocumentStatusText,
      CompanyCode,
      CompanyCodeName,
      PhysicalInventoryDocument,
      FiscalYear,
//      ExternalReference,
//      ProfitCenter,
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
      _Head : redirected to parent ZC_MM_INVENTORY_HEAD

}
