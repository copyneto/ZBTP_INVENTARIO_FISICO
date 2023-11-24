@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help: Status da contagem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_MM_VH_COUNTING_STATUS

  as select from    DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name : 'ZD_MM_COUNTING_STATUS' )  as Domain

    left outer join DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_MM_COUNTING_STATUS' ) as _Text on  _Text.domain_name    = Domain.domain_name
                                                                                                     and _Text.value_position = Domain.value_position
                                                                                                     and _Text.language       = $session.system_language
{
      @ObjectModel.text.element: ['StatusText']
      @EndUserText.label: 'Status'
  key ( cast( Domain.value_low as ze_mm_counting_status ) ) as Status,
      @EndUserText.label: 'Descrição'
      cast( _Text.text as abap.char(60) )                        as StatusText
}
