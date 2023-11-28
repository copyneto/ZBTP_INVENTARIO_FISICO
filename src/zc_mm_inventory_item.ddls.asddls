@EndUserText.label: 'Cockpit de Inventário - Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['DocumentItemId']

define view entity ZC_MM_INVENTORY_ITEM
  as projection on ZI_MM_INVENTORY_ITEM as _Item
{
  key DocumentItemId,
      DocumentId,
      @ObjectModel.text.element : ['StatusText']
      StatusId,
      StatusText,
      StatusCrit,
      @ObjectModel.text.element : ['MaterialName']
      Material,
      MaterialName,
      @ObjectModel.text.element : ['StorageLocationName']
      StorageLocation,
      StorageLocationName,
      Batch,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      QuantityStock,
      QuantityStockText,
      QuantityStockCrit,
//      @Semantics.quantity.unitOfMeasure : 'Unit'
      QuantityCount,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      QuantityCurrent,
      QuantityCurrentCrit,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      Balance,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      BalanceCurrent,
      Unit,
      @Semantics.amount.currencyCode : 'Currency'
      PriceStock,
      @Semantics.amount.currencyCode : 'Currency'
      PriceCount,
      @Semantics.amount.currencyCode : 'Currency'
      PriceDiff,
      Currency,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      Weight,
      WeightUnit,
      ProductHierarchy,
      Accuracy,
      AccuracyCrit,
      MaterialDocumentYear,
      MaterialDocument,
      PostingDate,
      BR_NotaFiscal,
      AccountingDocument,
      AccountingDocumentYear,
      InvoiceReference,
      DocumentDate,
      BR_NFeNumber,
      BR_NFIsCanceled,
      @ObjectModel.text.element : ['BR_NFeDocumentStatusText']
      BR_NFeDocumentStatus,
      BR_NFeDocumentStatusText,
      @ObjectModel.text.element : ['CompanyCodeName']
      CompanyCode,
      CompanyCodeName,
      PhysicalInventoryDocument,
      FiscalYear,
      ExternalReference,
      ProfitCenter,
      @Semantics.user.createdBy: true
      @ObjectModel.text.element : ['CreatedByName']
      CreatedBy,
      CreatedByName,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      @ObjectModel.text.element : ['LastChangedByName']
      LastChangedBy,
      LastChangedByName,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      /* Associations */
      _Head : redirected to parent ZC_MM_INVENTORY_HEAD

}
