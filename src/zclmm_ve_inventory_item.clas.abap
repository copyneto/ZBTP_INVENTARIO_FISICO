CLASS zclmm_ve_inventory_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_ve_inventory_item IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.


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
