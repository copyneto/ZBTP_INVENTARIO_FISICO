@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit de Inventário - Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INVENTORY_LOG

  as select from ztmm_inventory_l as _Log

  association [0..1] to ZI_MM_VH_MSGTY              as _Msgty on _Msgty.Msgty = $projection.Msgty

  association        to parent ZI_MM_INVENTORY_HEAD as _Head  on $projection.DocumentId = _Head.DocumentId
{

  key _Log.documentid         as DocumentId,
  key _Log.line               as Line,
      _Log.msgid              as Msgid,
      _Log.msgty              as Msgty,
      _Msgty.MsgtyText        as MsgtyText,

      case _Log.msgty
      when 'S' then 3 -- Sucesso
      when 'E' then 2 -- Erro
      when 'W' then 1 -- Aviso
      when 'I' then 1 -- Informativo
      when 'A' then 2 -- Terminação
      when 'X' then 2 -- Exit
               else 0
      end                     as MsgtyCrit,

      _Log.msgno              as Msgno,
      _Log.msgv1              as Msgv1,
      _Log.msgv2              as Msgv2,
      _Log.msgv3              as Msgv3,
      _Log.msgv4              as Msgv4,
      _Log.message            as Message,
      @Semantics.user.createdBy: true
      _Log.createdby          as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Log.createdat          as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Log.lastchangedby      as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Log.lastchangedat      as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Log.locallastchangedat as LocalLastChangedAt,

      /* Associations */
      _Head
}
