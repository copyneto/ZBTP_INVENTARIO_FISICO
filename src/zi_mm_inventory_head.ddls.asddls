@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit de Inventário - Cabeçalho'

define root view entity ZI_MM_INVENTORY_HEAD

  as select from ztmm_inventory_h as _Head

  association [0..1] to ZI_MM_VH_INVENTORY_STATUS as _Status        on _Status.Status = $projection.StatusId
  association [0..1] to ZI_MM_VH_USER             as _CreatedBy     on _CreatedBy.UserID = $projection.CreatedBy
  association [0..1] to ZI_MM_VH_USER             as _LastChangedBy on _LastChangedBy.UserID = $projection.LastChangedBy

  composition [0..*] of ZI_MM_INVENTORY_ITEM      as _Item
  composition [0..*] of ZI_MM_INVENTORY_LOG       as _Log

{
  key  _Head.documentid                               as DocumentId,
       _Head.documentno                               as DocumentNo,
       _Head.countid                                  as CountId,
       _Head.countdate                                as CountDate,
       _Head.statusid                                 as StatusId,
       _Status.StatusText                             as StatusText,

       case _Head.statusid
       when '00' then 2    -- Pendente
       when '01' then 3    -- Liberado
       when '02' then 3    -- Concluido
       when '03' then 1    -- Cancelado
                 else 0
       end                                            as StatusCrit,

       _Head.plant                                    as Plant,
       _Head.plantname                                as PlantName,
       _Head.description                              as Description,

       case _Head.statusid
       when '00'
       then cast( '' as abap_boolean )
       else cast( 'X' as abap_boolean )
       end                                            as UpdateHidden,

       @Semantics.user.createdBy: true
       _Head.createdby                                as CreatedBy,
       _CreatedBy.UserDescription                     as CreatedByName,
       @Semantics.systemDateTime.createdAt: true
       cast( _Head.createdat as timestampl )          as CreatedAt,
       @Semantics.user.lastChangedBy: true
       _Head.lastchangedby                            as LastChangedBy,
       _LastChangedBy.UserDescription                 as LastChangedByName,
       @Semantics.systemDateTime.lastChangedAt: true
       cast( _Head.lastchangedat as timestampl )      as LastChangedAt,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       cast( _Head.locallastchangedat as timestampl ) as LocalLastChangedAt,

       /* Associations */
       _Item,
       _Log
}
