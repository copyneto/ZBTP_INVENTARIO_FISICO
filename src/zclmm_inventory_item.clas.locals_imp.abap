CLASS lcl_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _Item RESULT result.

    METHODS validadeduplicate FOR VALIDATE ON SAVE
      IMPORTING keys FOR _item~validadeduplicate.

    METHODS validatefield FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~validatefield.

ENDCLASS.

CLASS lcl_Item IMPLEMENTATION.

  METHOD get_instance_features.

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

* ---------------------------------------------------------------------
* Cria registro de cabeçalho
* ---------------------------------------------------------------------
    lo_behavior->get_Data( EXPORTING it_head_key = CORRESPONDING #( keys )
                           IMPORTING et_item     = DATA(lt_item)
                                     et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    LOOP AT keys REFERENCE INTO DATA(ls_keys).

      READ TABLE lt_item REFERENCE INTO DATA(ls_item) WITH KEY DocumentId = ls_keys->DocumentItemId
                                                      BINARY SEARCH.
      CHECK sy-subrc EQ 0.

      result = VALUE #( BASE result
                      ( %tky              = ls_keys->%tky
                        %update           = COND #( WHEN ls_item->StatusId EQ zclmm_bd_inventory=>gc_status_head-pending
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                        %delete           = COND #( WHEN ls_item->StatusId EQ zclmm_bd_inventory=>gc_status_head-pending
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
                      ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD validadeDuplicate.
    DATA:
      lt_data_itens_aux TYPE TABLE FOR READ RESULT zi_mm_inventory_head\\_item.

    READ ENTITIES OF zi_mm_inventory_head IN LOCAL MODE ##LOCAL_OK[I_CmmdtyMarketCurveTP]
      ENTITY _Item
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_itens)
      FAILED DATA(lt_failed).

    IF lt_failed IS NOT INITIAL.
      failed = CORRESPONDING #( DEEP lt_failed ).
      RETURN.
    ENDIF.

    IF lt_data_itens IS NOT INITIAL.
      DATA(lv_documentid) = lt_data_itens[ 1 ]-documentid.
      SELECT * FROM ztmm_inv_draft_i
      WHERE documentid = @lv_documentid
        AND draftentityoperationcode <> 'D'
      INTO TABLE @DATA(lt_data_itens_db).
    ENDIF.

    LOOP AT lt_data_itens ASSIGNING FIELD-SYMBOL(<fs_data_itens>).
      CLEAR lt_data_itens_aux.
      lt_data_itens_aux = VALUE #(
        FOR ls_data_item IN lt_data_itens WHERE
        ( material        = <fs_data_itens>-material AND
          StorageLocation = <fs_data_itens>-StorageLocation AND
          Batch           = <fs_data_itens>-Batch AND
          documentitemid  <> <fs_data_itens>-documentitemid )
        ( ls_data_item )
      ).

      lt_data_itens_aux = VALUE #( BASE lt_data_itens_aux
        FOR ls_data_itens_db IN lt_data_itens_db WHERE
        ( material        = <fs_data_itens>-material AND
          StorageLocation = <fs_data_itens>-StorageLocation AND
          Batch           = <fs_data_itens>-Batch AND
          documentitemid  <> <fs_data_itens>-documentitemid )
        ( CORRESPONDING #( ls_data_itens_db ) )
      ).

      LOOP AT lt_data_itens_aux ASSIGNING FIELD-SYMBOL(<fs_data_itens_aux>).
        APPEND VALUE #(
          documentitemid = <fs_data_itens_aux>-documentitemid
          %is_draft      = <fs_data_itens_aux>-%is_draft
          %fail          = VALUE #( cause = if_abap_behv=>cause-dependency )
        ) TO failed-_item.

        APPEND VALUE #(
          documentitemid = <fs_data_itens_aux>-documentitemid
          %is_draft      = <fs_data_itens_aux>-%is_draft
          %msg           = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = |Material: { <fs_data_itens_aux>-material },Lote: { <fs_data_itens_aux>-Batch },Depósito: { <fs_data_itens_aux>-StorageLocation }  duplicados|
          )
          %element  = VALUE #(
            Batch           = if_abap_behv=>mk-on
            material        = if_abap_behv=>mk-on
            StorageLocation = if_abap_behv=>mk-on
          )
        ) TO reported-_item.

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD validateField.

    READ ENTITIES OF zi_mm_inventory_head IN LOCAL MODE ##LOCAL_OK[I_CmmdtyMarketCurveTP]
      ENTITY _Item
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_data_itens)
      FAILED DATA(lt_failed).

  ENDMETHOD.

ENDCLASS.
