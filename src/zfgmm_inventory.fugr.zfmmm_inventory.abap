TYPES: ty_t_return TYPE bapiret2.

FUNCTION zfmmm_inventory.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IS_HEAD) TYPE
*"        Z_S41_RFC_INVENTORY_RELEASE=>ZSMM_INVENTORY_HEAD
*"     REFERENCE(IT_ITEM) TYPE
*"        Z_S41_RFC_INVENTORY_RELEASE=>ZCTGMM_INVENTORY_ITEM
*"     REFERENCE(IT_LOG) TYPE
*"        Z_S41_RFC_INVENTORY_RELEASE=>ZCTGMM_INVENTORY_LOG OPTIONAL
*"  EXPORTING
*"     REFERENCE(ES_RFC_HEAD) TYPE
*"        Z_S41_RFC_INVENTORY_RELEASE=>ZSMM_INVENTORY_HEAD
*"     REFERENCE(ET_RFC_ITEM) TYPE
*"        Z_S41_RFC_INVENTORY_RELEASE=>ZCTGMM_INVENTORY_ITEM
*"     REFERENCE(ET_RFC_LOG) TYPE
*"        Z_S41_RFC_INVENTORY_RELEASE=>ZCTGMM_INVENTORY_LOG
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------
  DATA(lo_inventory) = zclmm_bd_inventory=>get_instance( ).

  lo_inventory->call_rfc_inventory_release( EXPORTING is_head     = CORRESPONDING #( is_head )
                                                      it_item     = CORRESPONDING #( it_item )
                                                      it_log      = CORRESPONDING #( it_log )
                                            IMPORTING es_rfc_head = es_rfc_head
                                                      et_rfc_item = et_rfc_item
                                                      et_rfc_log  = et_rfc_log ).
*                                                      et_return   = et_return ).




ENDFUNCTION.
