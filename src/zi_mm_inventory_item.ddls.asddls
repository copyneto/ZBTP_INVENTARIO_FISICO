@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Cockpit de Inventário - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MM_INVENTORY_ITEM
  as select from ztmm_inventory_i as _Item

  association        to parent ZI_MM_INVENTORY_HEAD as _Head          on _Head.DocumentId = $projection.DocumentId

  association [0..1] to ZI_MM_VH_COUNTING_STATUS    as _Status        on _Status.Status = $projection.StatusId
  association [0..1] to ZI_MM_VH_USER               as _CreatedBy     on _CreatedBy.UserID = $projection.CreatedBy
  association [0..1] to ZI_MM_VH_USER               as _LastChangedBy on _LastChangedBy.UserID = $projection.LastChangedBy

{
  key _Item.documentitemid                           as DocumentItemId,
      _Item.documentid                               as DocumentId,
      _Item.statusid                                 as StatusId,
      _Status.StatusText                             as StatusText,

      case  _Item.statusid
      when '00' then 2    -- 'Pendente'
      when '01' then 3    -- 'Liberado'
      when '02' then 2    -- 'Pendente Contagem'
      when '03' then 3    -- 'Concluido'
      when '04' then 1    -- 'Cancelado'
                else 0
      end                                            as StatusCrit,

      _Item.material                                 as Material,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      _Item.materialname                             as MaterialName,
      _Item.storagelocation                          as StorageLocation,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      _Item.storagelocationname                      as StorageLocationName,
      _Item.batch                                    as Batch,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.quan(13,3) )                   as QuantityStock,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(60) )                    as QuantityStockText,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '0' as abap.int1 )                       as QuantityStockCrit,

      //      @Semantics.quantity.unitOfMeasure: 'Unit'
      //      _Item.quantitycount                            as QuantityCount,
      cast( _Item.quantitycount as abap.dec(13,3) )  as QuantityCount,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.quan(13,3) )                   as QuantityCurrent,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '0' as abap.int1 )                       as QuantityCurrentCrit,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.quan(13,3) )                   as Balance,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.quan(13,3) )                   as BalanceCurrent,
      _Item.unit                                     as Unit,
      @Semantics.amount.currencyCode: 'Currency'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.curr(11,2) )                   as PriceStock,
      @Semantics.amount.currencyCode: 'Currency'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.curr(11,2) )                   as PriceCount,
      @Semantics.amount.currencyCode: 'Currency'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.curr(11,2) )                   as PriceDiff,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.cuky )                        as Currency,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.quan(13,3) )                   as Weight,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.unit(3) )                     as WeightUnit,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(18) )                    as ProductHierarchy,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( 0 as abap.dec(13,2) )                    as Accuracy,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '0' as abap.int1 )                       as AccuracyCrit,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '0000' as abap.numc(4) )                 as MaterialDocumentYear,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(10) )                    as MaterialDocument,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '00000000' as abap.dats )                as PostingDate,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.numc(10) )                    as BR_NotaFiscal,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(10) )                    as AccountingDocument,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.numc(4) )                     as AccountingDocumentYear,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(10) )                    as InvoiceReference,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '00000000' as abap.dats )                as DocumentDate,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(9) )                     as BR_NFeNumber,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(1) )                     as BR_NFIsCanceled,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(1) )                     as BR_NFeDocumentStatus,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(40) )                    as BR_NFeDocumentStatusText,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(4) )                     as CompanyCode,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(40) )                    as CompanyCodeName,
      _Item.physicalinventorydocument                as PhysicalInventoryDocument,
      _Item.fiscalyear                               as FiscalYear,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(40) )                    as ExternalReference,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_VE_INVENTORY_ITEM'
      cast( '' as abap.char(10) )                    as ProfitCenter,
      @Semantics.user.createdBy: true
      _Item.createdby                                as CreatedBy,
      _CreatedBy.UserDescription                     as CreatedByName,
      @Semantics.systemDateTime.createdAt: true
      cast( _Item.createdat as timestampl )          as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Item.lastchangedby                            as LastChangedBy,
      _LastChangedBy.UserDescription                 as LastChangedByName,
      @Semantics.systemDateTime.lastChangedAt: true
      cast( _Item.lastchangedat as timestampl )      as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      cast( _Item.locallastchangedat as timestampl ) as LocalLastChangedAt,

      /* Associations */
      _Head
}
