@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit de Inventário - Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@UI.presentationVariant: [{sortOrder: [{by: 'Line', direction: #DESC }]}]

define view entity ZI_MM_INVENTORY_LOG

  as select from ztmm_inventory_l as _Log

  association [0..1] to ZI_MM_VH_MSGTY              as _Msgty         on _Msgty.Msgty = $projection.Msgty

  association        to parent ZI_MM_INVENTORY_HEAD as _Head          on $projection.DocumentId = _Head.DocumentId
  association [0..1] to ZI_MM_VH_USER               as _CreatedBy     on _CreatedBy.UserID = $projection.CreatedBy
  association [0..1] to ZI_MM_VH_USER               as _LastChangedBy on _LastChangedBy.UserID = $projection.LastChangedBy

{

  key _Log.documentid                                as DocumentId,
  key _Log.line                                      as Line,
      _Log.msgid                                     as Msgid,
      _Log.msgty                                     as Msgty,
      _Msgty.MsgtyText                               as MsgtyText,

      case _Log.msgty
      when 'S' then 3 -- Sucesso
      when 'E' then 1 -- Erro
      when 'W' then 2 -- Aviso
      when 'I' then 2 -- Informativo
      when 'A' then 1 -- Terminação
      when 'X' then 2 -- Exit
               else 0
      end                                            as MsgtyCrit,

      _Log.msgno                                     as Msgno,
      _Log.msgv1                                     as Msgv1,
      _Log.msgv2                                     as Msgv2,
      _Log.msgv3                                     as Msgv3,
      _Log.msgv4                                     as Msgv4,
      _Log.message                                   as Message,
      @Semantics.user.createdBy: true
      _Log.createdby                                 as CreatedBy,
      _CreatedBy.UserDescription                     as CreatedByName,
      @Semantics.systemDateTime.createdAt: true
      cast( _Log.createdat as timestampl )           as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Log.lastchangedby                             as LastChangedBy,
      _LastChangedBy.UserDescription                 as LastChangedByName,
      @Semantics.systemDateTime.lastChangedAt: true
      cast( _Log.lastchangedat as timestampl )       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      cast(  _Log.locallastchangedat as timestampl ) as LocalLastChangedAt,

      /* Associations */
      _Head
}
