CLASS lcl_Head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _Head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _Head RESULT result.

    METHODS cancelar FOR MODIFY
      IMPORTING keys FOR ACTION _Head~cancelar.

    METHODS liberar FOR MODIFY
      IMPORTING keys FOR ACTION _Head~liberar.

    METHODS AdditionalSave FOR MODIFY
      IMPORTING keys FOR ACTION _Head~AdditionalSave.

    METHODS createDocumentNo FOR DETERMINE ON SAVE
      IMPORTING keys FOR _Head~createDocumentNo.

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
                      ( %tky              = ls_keys->%tky
                        %features-%update = COND #( WHEN ls_head->StatusId EQ zclmm_bd_inventory=>gc_status_head-pending
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                        %update           = COND #( WHEN ls_head->StatusId EQ zclmm_bd_inventory=>gc_status_head-pending
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                        %delete           = COND #( WHEN ls_head->StatusId EQ zclmm_bd_inventory=>gc_status_head-pending
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                        %action-cancelar  = COND #( WHEN ls_keys->%is_draft EQ '00'
                                                     AND ls_head->StatusId EQ zclmm_bd_inventory=>gc_status_head-pending
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                        %action-liberar   = COND #( WHEN ls_keys->%is_draft EQ '00'
                                                     AND ls_head->StatusId EQ zclmm_bd_inventory=>gc_status_head-pending
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                        %assoc-_Log       = if_abap_behv=>fc-o-disabled
                      ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD cancelar.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Chama evento de cancelamento
* ---------------------------------------------------------------------
    lo_behavior->cancel_inventory( EXPORTING it_head_key = CORRESPONDING #( keys )
                                   IMPORTING et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Insere/atualiza/remove os registros
* ---------------------------------------------------------------------
    IF lt_return IS INITIAL.
      lo_behavior->commit( ).
    ENDIF.

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

  ENDMETHOD.

  METHOD AdditionalSave.
    RETURN.
  ENDMETHOD.

  METHOD createDocumentNo.

* ---------------------------------------------------------------------
* Recupera dados de cabeçalho
* ---------------------------------------------------------------------
    READ ENTITIES OF zi_mm_inventory_head IN LOCAL MODE
        ENTITY _Head
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_head)
        FAILED DATA(lt_failed).

    TRY.
        CHECK lt_head[ 1 ]-DocumentNo IS INITIAL.
      CATCH cx_root.
        RETURN.
    ENDTRY.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Cria registro de cabeçalho
* ---------------------------------------------------------------------
    lo_behavior->create_head(
      EXPORTING
        it_entities = CORRESPONDING #( lt_head )
      IMPORTING
        et_head     = DATA(lt_head_u)
        et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------
* Atualiza o mapeamento da chave atual
* ---------------------------------------------------------------------
    LOOP AT keys REFERENCE INTO DATA(ls_keys).

      READ TABLE lt_head_u REFERENCE INTO DATA(ls_head_u) WITH KEY DocumentId = ls_keys->DocumentId BINARY SEARCH.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF zi_mm_inventory_head IN LOCAL MODE
        ENTITY _Head
        UPDATE FIELDS ( DocumentNo )
        WITH VALUE #( (    %is_draft  = ls_keys->%is_draft
                       %key       = ls_keys->%key
                       %pky       = ls_keys->%pky
                       DocumentId = ls_keys->DocumentId
                       DocumentNo = ls_head_u->DocumentNo ) ).

    ENDLOOP.

* ---------------------------------------------------------------------
* Atualiza retorno
* ---------------------------------------------------------------------
    lo_behavior->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

ENDCLASS.
