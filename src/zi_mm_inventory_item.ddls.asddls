@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit de Inventário - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INVENTORY_ITEM
  as select from ztmm_inventory_i as _Item

  association to parent ZI_MM_INVENTORY_HEAD as _Head on $projection.DocumentId = _Head.DocumentId
{

  key _Item.documentid                as DocumentId,
  key _Item.documentitemid            as DocumentItemId,
      _Item.statusid                  as StatusId,
      _Item.statustext                as StatusText,

      case  _Item.statusid
      when '00' then 2    -- 'Pendente'
      when '01' then 3    -- 'Liberado'
      when '02' then 2    -- 'Pendente Contagem'
      when '03' then 3    -- 'Concluido'
      when '04' then 1    -- 'Cancelado'
                else 0
      end                             as StatusCrit,

      _Item.material                  as Material,
      _Item.materialname              as MaterialName,
      _Item.plant                     as Plant,
      _Item.plantname                 as PlantName,
      _Item.storagelocation           as StorageLocation,
      _Item.storagelocationname       as StorageLocationName,
      _Item.batch                     as Batch,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Item.quantitystock             as QuantityStock,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Item.quantitycount             as QuantityCount,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Item.quantitycurrent           as QuantityCurrent,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Item.balance                   as Balance,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Item.balancecurrent            as BalanceCurrent,
      _Item.unit                      as Unit,
      @Semantics.amount.currencyCode: 'Currency'
      _Item.pricestock                as PriceStock,
      @Semantics.amount.currencyCode: 'Currency'
      _Item.pricecount                as PriceCount,
      @Semantics.amount.currencyCode: 'Currency'
      _Item.pricediff                 as PriceDiff,
      _Item.currency                  as Currency,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      _Item.weight                    as Weight,
      _Item.weightunit                as WeightUnit,
      //      _Item.ProductHierarchy           as ProductHierarchy,
      _Item.accuracy                  as Accuracy,
      //      _Item.MaterialDocumentYear     as MaterialDocumentYear,
      //      _Item.MaterialDocument         as MaterialDocument,
      //      _Item.PostingDate              as PostingDate,
      //      _Item.BR_NotaFiscal            as BR_NotaFiscal,
      //      _Item.AccountingDocument       as AccountingDocument,
      //      _Item.AccountingDocumentYear   as AccountingDocumentYear,
      //      _Item.InvoiceReference         as InvoiceReference,
      //      _Item.DocumentDate             as DocumentDate,
      //      _Item.BR_NFeNumber             as BR_NFeNumber,
      //      _Item.BR_NFIsCanceled          as BR_NFIsCanceled,
      //      _Item.BR_NFeDocumentStatus     as BR_NFeDocumentStatus,
      //      _Item.BR_NFeDocumentStatusText as BR_NFeDocumentStatusText,
      _Item.companycode               as CompanyCode,
      _Item.companycodename           as CompanyCodeName,
      _Item.physicalinventorydocument as PhysicalInventoryDocument,
      _Item.fiscalyear                as FiscalYear,
      //      _Item.ExternalReference          as ExternalReference,
      //      _Item.ProfitCenter               as ProfitCenter,
      @Semantics.user.createdBy: true
      _Item.createdby                 as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Item.createdat                 as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Item.lastchangedby             as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Item.lastchangedat             as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Item.locallastchangedat        as LocalLastChangedAt,

      /* Associations */
      _Head

}
