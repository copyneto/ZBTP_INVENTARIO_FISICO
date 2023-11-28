@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit de Inventário - Cabeçalho'

define root view entity ZI_MM_CE_INVENTORY_HEAD

  as select from ztmm_inventory_h as _Head

{
  key  _Head.documentid         as DocumentId,
       _Head.documentno         as DocumentNo,
       _Head.countid            as CountId,
       _Head.countdate          as CountDate,
       _Head.statusid           as StatusId,
       _Head.statustext         as StatusText,

       case _Head.statusid
       when '00' then 2    -- Pendente
       when '01' then 3    -- Liberado
       when '02' then 3    -- Concluido
       when '03' then 1    -- Cancelado
                 else 0
       end               as StatusCrit,

       _Head.plant              as Plant,
       _Head.plantname          as PlantName,
       _Head.description        as Description,

       @Semantics.user.createdBy: true
       _Head.createdby          as CreatedBy,
       @Semantics.systemDateTime.createdAt: true
       _Head.createdat          as CreatedAt,
       @Semantics.user.lastChangedBy: true
       _Head.lastchangedby      as LastChangedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       _Head.lastchangedat      as LastChangedAt,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       _Head.locallastchangedat as LocalLastChangedAt
}
