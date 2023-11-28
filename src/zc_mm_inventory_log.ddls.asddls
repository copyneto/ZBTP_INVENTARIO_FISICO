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
      @ObjectModel.text.element : ['MsgtyText']
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
      @ObjectModel.text.element : ['CreatedByName']
      CreatedBy,
      CreatedByName,
      @Semantics.systemDateTime.createdAt: true
      CreatedAt,
      @Semantics.user.lastChangedBy: true
      @ObjectModel.text.element : ['LastChangedByName']
      LastChangedBy,
      LastChangedByName,
      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      /* Associations */
      _Head : redirected to parent ZC_MM_INVENTORY_HEAD
}
