@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit de Inventário - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CE_INVENTORY_ITEM
  as select from ztmm_inventory_i as _Item
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
      _Item.storagelocation           as StorageLocation,
      _Item.storagelocationname       as StorageLocationName,
      _Item.batch                     as Batch,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Item.quantitycount             as QuantityCount,
      _Item.unit                      as Unit,
      _Item.physicalinventorydocument as PhysicalInventoryDocument,
      _Item.fiscalyear                as FiscalYear,
      @Semantics.user.createdBy: true
      _Item.createdby                 as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Item.createdat                 as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Item.lastchangedby             as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Item.lastchangedat             as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Item.locallastchangedat        as LocalLastChangedAt

}
