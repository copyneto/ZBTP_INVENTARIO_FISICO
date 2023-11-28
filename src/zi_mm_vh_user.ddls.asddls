@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help: Usuário'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_USER
  as select from I_User
{
      @ObjectModel.text.element: ['UserDescription']
      @EndUserText.label: 'Usuário'
  key UserID,
      @EndUserText.label: 'Nome do Usuário'
      UserDescription

}
