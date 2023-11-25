@EndUserText.label: 'Cockpit de Inventário - Logs'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['Line']

define view entity ZC_MM_INVENTORY_LOG
  as projection on ZI_MM_INVENTORY_LOG
{
  key DocumentId,
  key Line,
      Msgid,
      Msgty,
      MsgtyText,
      MsgtyCrit,
      Msgno,
      Msgv1,
      Msgv2,
      Msgv3,
      Msgv4,
      Message,
      @Semantics.user.createdBy: true
      CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      /* Associations */
      _Head : redirected to parent ZC_MM_INVENTORY_HEAD
}
