@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SpreadSheet Intentory Itens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_invent_itens_spreadsheet
  as select from ztmm_inventory_i as _Itens
    inner join   ztmm_inventory_h as _Header on _Header.documentid = _Itens.documentid
{
  key _Header.plant               as Plant,
  key _Itens.storagelocation      as StorageLocation,
  key _Itens.material             as Material,
  key _Itens.batch                as Batch,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      max( _Itens.quantitycount ) as QuantityCount,
      _Itens.unit                 as Unit
}
group by
  _Header.plant,
  _Itens.storagelocation,
  _Itens.material,
  _Itens.batch,
  _Itens.unit
