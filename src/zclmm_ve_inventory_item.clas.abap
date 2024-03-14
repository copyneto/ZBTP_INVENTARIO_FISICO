CLASS zclmm_ve_inventory_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_VE_INVENTORY_ITEM IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_item    TYPE STANDARD TABLE OF zi_mm_inventory_item.

    lt_item = CORRESPONDING #( it_original_data ).

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ----------------------------------------------------------------------
* Recupera os dados de cabeçalho
* ----------------------------------------------------------------------
    lo_behavior->get_data( EXPORTING it_item_key = CORRESPONDING #( lt_item )
                           IMPORTING et_head     = DATA(lt_head)
                                     et_return   = DATA(lt_return) ).

    IF lt_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera dados de inventário via RFC
* ----------------------------------------------------------------------
    lo_behavior->call_rfc_inventory_get_info( EXPORTING it_rfc_head       = CORRESPONDING #( lt_head )
                                                        it_rfc_item       = CORRESPONDING #( lt_item )
                                              IMPORTING et_material_stock = DATA(lt_material_stock)
                                                        et_material_price = DATA(lt_material_price)
                                                        et_phys_inv_info  = DATA(lt_phys_inv_info)
                                                        et_return         = DATA(lt_return_rfc) ).

* ----------------------------------------------------------------------
* Atualiza relatório com os dados do inventário
* ----------------------------------------------------------------------
    lo_behavior->build_report_item( EXPORTING it_head           = CORRESPONDING #( lt_head )
                                              it_item           = CORRESPONDING #( lt_item )
                                              it_material_stock = lt_material_stock
                                              it_material_price = lt_material_price
                                              it_phys_inv_info  = lt_phys_inv_info
                                              it_return_rfc     = lt_return_rfc
                                    IMPORTING et_report         = DATA(lt_report)
                                              et_return         = lt_return ).

* --------------------------------------------------------------------
* Transfere dados para CDS
* --------------------------------------------------------------------
    IF lt_report IS NOT INITIAL.
      ct_calculated_data = CORRESPONDING #( lt_report ).
    ENDIF.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    et_Requested_orig_elements[] = VALUE #( ( CONV #( 'DOCUMENTID' ) )
                                            ( CONV #( 'DOCUMENTITEMID' ) )
                                            ( CONV #( 'MATERIAL' ) )
                                            ( CONV #( 'STORAGELOCATION' ) )
                                            ( CONV #( 'BATCH' ) )
                                            ( CONV #( 'QUANTITYCOUNT' ) )
                                            ( CONV #( 'UNIT' ) )
                                            ( CONV #( 'PHYSICALINVENTORYDOCUMENT' ) )
                                            ( CONV #( 'FISCALYEAR' ) ) ).

  ENDMETHOD.
ENDCLASS.
