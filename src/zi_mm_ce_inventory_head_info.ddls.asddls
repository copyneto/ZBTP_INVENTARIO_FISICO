@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventário - Cabeçalho - Dados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define view entity ZI_MM_CE_INVENTORY_HEAD_INFO

  as select from ztmm_inventory_h as _Info 
  
  association to parent ZC_MM_CE_INVENTORY_HEAD as _Head on $projection.DocumentId = _Head.DocumentId
{
  key  _Info.documentid         as DocumentId,
       _Info.documentno         as DocumentNo,
       _Info.countid            as CountId,
       _Info.countdate          as CountDate,
       _Info.statusid           as StatusId,
       _Info.statustext         as StatusText,

       case _Info.statusid
       when '00' then 0    -- 'Criado'
       when '01' then 2    -- 'Pendente'
       when '02' then 3    -- 'Liberado'
       when '03' then 1    -- 'Cancelado' 
       when '04' then 3    -- 'Concluido'
                 else 0
       end                      as StatusCrit,

       _Info.plant              as Plant,
       _Info.plantname          as PlantName,
       _Info.description        as Description,

       @Semantics.user.createdBy: true
       _Info.createdby          as CreatedBy,
       @Semantics.systemDateTime.createdAt: true
       _Info.createdat          as CreatedAt,
       @Semantics.user.lastChangedBy: true
       _Info.lastchangedby      as LastChangedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       _Info.lastchangedat      as LastChangedAt,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       _Info.locallastchangedat as LocalLastChangedAt,
       
      /* Associations */
      _Head
}
