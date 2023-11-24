@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help: Tipo de mensagem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_MM_VH_MSGTY

  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name : 'ZD_MM_MSGTY' )  as Domain

    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_MM_MSGTY' ) as _Text on  _Text.domain_name    = Domain.domain_name
                                                                                           and _Text.value_position = Domain.value_position
                                                                                           and _Text.language       = $session.system_language
{
      @ObjectModel.text.element: ['MsgtyText']
      @EndUserText.label: 'Status'
  key ( cast( Domain.value_low as ze_mm_msgty ) ) as Msgty,
      @EndUserText.label: 'Descrição'
      _Text.text                                  as MsgtyText
}
