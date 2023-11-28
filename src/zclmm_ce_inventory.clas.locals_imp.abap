CLASS lcl_Head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES:
    ty_t_return   TYPE STANDARD TABLE OF bapiret2.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _Head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _Head RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE _Head.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE _Head.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE _Head.

    METHODS read FOR READ
      IMPORTING keys FOR READ _Head RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK _Head.

    METHODS rba_Item FOR READ
      IMPORTING keys_rba FOR READ _Head\_Item FULL result_requested RESULT result LINK association_links.

    METHODS rba_Log FOR READ
      IMPORTING keys_rba FOR READ _Head\_Log FULL result_requested RESULT result LINK association_links.

    METHODS cba_Item FOR MODIFY
      IMPORTING entities_cba FOR CREATE _Head\_Item.

*    METHODS cba_Log FOR MODIFY
*      IMPORTING entities_cba FOR CREATE _Head\_Log.

    METHODS cancelar FOR MODIFY
      IMPORTING keys FOR ACTION _Head~cancelar.

    METHODS liberar FOR MODIFY
      IMPORTING keys FOR ACTION _Head~liberar.

*    METHODS earlynumbering_create FOR NUMBERING
*      IMPORTING entities FOR CREATE _Head.



ENDCLASS.

CLASS lcl_Head IMPLEMENTATION.

  METHOD get_instance_features.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Cria registro de cabeçalho
* ---------------------------------------------------------------------
    lo_behavior->get_Data( EXPORTING it_head_key = CORRESPONDING #( keys )
                           IMPORTING et_head     = DATA(lt_head)
                                     et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    LOOP AT keys REFERENCE INTO DATA(ls_keys).

      READ TABLE lt_head REFERENCE INTO DATA(ls_head) WITH KEY DocumentId = ls_keys->DocumentId
                                                      BINARY SEARCH.
      CHECK sy-subrc EQ 0.

      result = VALUE #( BASE result
                      ( %tky             = ls_keys->%tky
                        %update          = COND #( WHEN ls_head->StatusId = zclmm_bd_inventory=>gc_status_head-created
                                                     OR ls_head->StatusId = zclmm_bd_inventory=>gc_status_head-pending
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )
                        %delete          = COND #( WHEN ls_head->StatusId = zclmm_bd_inventory=>gc_status_head-created
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )
                        %action-cancelar = COND #( WHEN ls_head->StatusId = zclmm_bd_inventory=>gc_status_head-created
                                                     OR ls_head->StatusId = zclmm_bd_inventory=>gc_status_head-pending
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )
                        %action-liberar  = COND #( WHEN ls_head->StatusId = zclmm_bd_inventory=>gc_status_head-created
                                                     OR ls_head->StatusId = zclmm_bd_inventory=>gc_status_head-pending
                                                   THEN if_abap_behv=>fc-o-enabled
                                                   ELSE if_abap_behv=>fc-o-disabled )
                      ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD create.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Cria registro de cabeçalho
* ---------------------------------------------------------------------
    lo_behavior->create_head( EXPORTING it_entities = entities
                              IMPORTING et_head     = DATA(lt_head)
                                        et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Prepara os dados para serem inseridos posteriormente no método COMMIT
* ---------------------------------------------------------------------
    IF lt_return IS INITIAL.

      lo_behavior->prepare_commit( EXPORTING iv_insert = abap_true
                                             it_head   = lt_head
                                   IMPORTING et_return = lt_return ).

    ENDIF.

* ---------------------------------------------------------------------
* Atualiza o mapeamento da chave atual
* ---------------------------------------------------------------------
    TRY.
        mapped-_head = VALUE #( FOR ls_entity_ IN entities ( %cid       = ls_entity_-%cid
                                                             DocumentId = lt_head[ 1 ]-DocumentId
                                                             ) ).
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD update.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Atualiza registro de cabeçalho
* ---------------------------------------------------------------------
    lo_behavior->update_head( EXPORTING it_entities = entities
                              IMPORTING et_head     = DATA(lt_head)
                                        et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Prepara os dados para serem atualizados posteriormente no método COMMIT
* ---------------------------------------------------------------------
    IF lt_return IS INITIAL.

      lo_behavior->prepare_commit( EXPORTING iv_update = abap_true
                                             it_head   = lt_head
                                   IMPORTING et_return = lt_return ).

    ENDIF.

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD delete.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Prepara os dados para serem removidos posteriormente no método COMMIT
* ---------------------------------------------------------------------
    lo_behavior->prepare_commit( EXPORTING iv_delete = abap_true
                                           it_head   = CORRESPONDING #( keys )
                                 IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD rba_Item.
    RETURN.
  ENDMETHOD.

  METHOD rba_Log.
    RETURN.
  ENDMETHOD.

  METHOD cba_Item.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Cria registro de item
* ---------------------------------------------------------------------
    lo_behavior->create_item( EXPORTING it_entities = entities_cba
                              IMPORTING et_item     = DATA(lt_item)
                                        et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Prepara os dados para serem inseridos posteriormente no método COMMIT
* ---------------------------------------------------------------------
    IF lt_return IS INITIAL.

      lo_behavior->prepare_commit( EXPORTING iv_insert = abap_true
                                             it_item   = lt_item
                                   IMPORTING et_return = lt_return ).

    ENDIF.

* ---------------------------------------------------------------------
* Atualiza o mapeamento da chave atual
* ---------------------------------------------------------------------
    LOOP AT entities_cba REFERENCE INTO DATA(ls_entity).

      LOOP AT ls_entity->%target REFERENCE INTO DATA(ls_target).

        READ TABLE lt_item REFERENCE INTO DATA(ls_item) INDEX sy-tabix.

        CHECK sy-subrc EQ 0.

        mapped-_item = VALUE #( BASE  mapped-_item ( %cid           = ls_target->%cid
                                                     DocumentId     = ls_entity->DocumentId
                                                     DocumentItemId = ls_item->DocumentItemId
                                                     ) ).
      ENDLOOP.
    ENDLOOP.

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

*  METHOD cba_Log.
*    RETURN.
*  ENDMETHOD.

  METHOD cancelar.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Chama evento de cancelamento
* ---------------------------------------------------------------------
    lo_behavior->cancel_inventory( EXPORTING it_head_key = CORRESPONDING #( keys )
                                   IMPORTING et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD liberar.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Prepara para fazer a liberação no commit (SAVE)
* ---------------------------------------------------------------------
    lo_behavior->prepare_release( it_head_key =  CORRESPONDING #( keys ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _Item RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE _Item.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE _Item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE _Item.

    METHODS read FOR READ
      IMPORTING keys FOR READ _Item RESULT result.

    METHODS rba_Head FOR READ
      IMPORTING keys_rba FOR READ _Item\_Head FULL result_requested RESULT result LINK association_links.


ENDCLASS.


CLASS lcl_Item IMPLEMENTATION.

  METHOD get_instance_features.
    RETURN.
  ENDMETHOD.

  METHOD update.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Atualiza registro de cabeçalho
* ---------------------------------------------------------------------
    lo_behavior->update_item( EXPORTING it_entities = entities
                              IMPORTING et_head     = DATA(lt_head)
                                        et_item     = DATA(lt_item)
                                        et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Prepara os dados para serem atualizados posteriormente no método COMMIT
* ---------------------------------------------------------------------
    IF lt_return IS INITIAL.

      lo_behavior->prepare_commit( EXPORTING iv_update = abap_true
                                             it_head   = lt_head
                                             it_item   = lt_item
                                   IMPORTING et_return = lt_return ).

    ENDIF.

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD delete.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Prepara os dados para serem removidos posteriormente no método COMMIT
* ---------------------------------------------------------------------
    lo_behavior->prepare_commit( EXPORTING iv_delete = abap_true
                                           it_item   = CORRESPONDING #( keys )
                                 IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD read.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Atualiza registro de cabeçalho
* ---------------------------------------------------------------------
    lo_behavior->get_data( EXPORTING it_item_key = CORRESPONDING #( keys )
                           IMPORTING et_item     = DATA(lt_item)
                                     et_return   = DATA(lt_return) ).

    result = CORRESPONDING #( lt_item ).

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD rba_Head.
    RETURN.
  ENDMETHOD.

  METHOD create.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_Log DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ _Log RESULT result.

    METHODS rba_Head FOR READ
      IMPORTING keys_rba FOR READ _Log\_Head FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lcl_Log IMPLEMENTATION.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD rba_Head.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ZC_MM_CE_INVENTORY_HEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lcl_ZC_MM_CE_INVENTORY_HEAD IMPLEMENTATION.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD save.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Chama lógica de liberação
* ---------------------------------------------------------------------
    lo_behavior->call_release( IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Insere/atualiza/remove os registros
* ---------------------------------------------------------------------
    IF NOT line_exists( lt_return[ type = 'E' ] ).
      lo_behavior->commit( ).
    ENDIF.

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD cleanup.
    RETURN.
  ENDMETHOD.

  METHOD cleanup_finalize.
    RETURN.
  ENDMETHOD.

ENDCLASS.
