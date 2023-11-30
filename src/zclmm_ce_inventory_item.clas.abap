CLASS zclmm_ce_inventory_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .

    TYPES:
      ty_report     TYPE zc_mm_ce_inventory_item,
      ty_t_report_s TYPE SORTED TABLE OF ty_report
                    WITH NON-UNIQUE KEY DocumentId,
      ty_t_report   TYPE STANDARD TABLE OF ty_report,
      ty_t_head     TYPE STANDARD TABLE OF zi_mm_ce_inventory_head,
      ty_t_item     TYPE STANDARD TABLE OF zi_mm_ce_inventory_item,
      ty_t_return   TYPE STANDARD TABLE OF bapiret2,

      BEGIN OF ty_filter,
        DocumentId                TYPE RANGE OF zc_mm_inventory_item-DocumentId,
        DocumentItemId            TYPE RANGE OF zc_mm_inventory_item-DocumentItemId,
        StatusId                  TYPE RANGE OF zc_mm_inventory_item-StatusId,
        StatusText                TYPE RANGE OF zc_mm_inventory_item-StatusText,
        Material                  TYPE RANGE OF zc_mm_inventory_item-Material,
        MaterialName              TYPE RANGE OF zc_mm_inventory_item-MaterialName,
        StorageLocation           TYPE RANGE OF zc_mm_inventory_item-StorageLocation,
        StorageLocationName       TYPE RANGE OF zc_mm_inventory_item-StorageLocationName,
        Batch                     TYPE RANGE OF zc_mm_inventory_item-Batch,
*        QuantityStock             TYPE RANGE OF zc_mm_inventory_item-QuantityStock,
        QuantityCount             TYPE RANGE OF zc_mm_inventory_item-QuantityCount,
*        QuantityCurrent           TYPE RANGE OF zc_mm_inventory_item-QuantityCurrent,
*        Balance                   TYPE RANGE OF zc_mm_inventory_item-Balance,
*        BalanceCurrent            TYPE RANGE OF zc_mm_inventory_item-BalanceCurrent,
        Unit                      TYPE RANGE OF zc_mm_inventory_item-Unit,
*        PriceStock                TYPE RANGE OF zc_mm_inventory_item-PriceStock,
*        PriceCount                TYPE RANGE OF zc_mm_inventory_item-PriceCount,
*        PriceDiff                 TYPE RANGE OF zc_mm_inventory_item-PriceDiff,
*        Currency                  TYPE RANGE OF zc_mm_inventory_item-Currency,
*        Weight                    TYPE RANGE OF zc_mm_inventory_item-Weight,
*        WeightUnit                TYPE RANGE OF zc_mm_inventory_item-WeightUnit,
        Accuracy                  TYPE RANGE OF zc_mm_inventory_item-Accuracy,
*        CompanyCode               TYPE RANGE OF zc_mm_inventory_item-CompanyCode,
*        CompanyCodeName           TYPE RANGE OF zc_mm_inventory_item-CompanyCodeName,
        PhysicalInventoryDocument TYPE RANGE OF zc_mm_inventory_item-PhysicalInventoryDocument,
        FiscalYear                TYPE RANGE OF zc_mm_inventory_item-FiscalYear,
      END OF ty_filter.

    METHODS build_report
      IMPORTING it_range         TYPE if_rap_query_filter=>tt_name_range_pairs OPTIONAL
                it_sort_elements TYPE if_rap_query_request=>tt_sort_elements OPTIONAL
                iv_set_top       TYPE i DEFAULT 50
                iv_set_skip      TYPE i DEFAULT 0
      EXPORTING et_report        TYPE ty_t_report
                et_return        TYPE ty_t_return.

    "! Recupera dados locais de inventário
    METHODS get_info
      IMPORTING is_filter   TYPE ty_filter
                iv_set_top  TYPE i DEFAULT 50
                iv_set_skip TYPE i DEFAULT 0
      EXPORTING et_head     TYPE ty_t_head
                et_item     TYPE ty_t_item.

  PROTECTED SECTION.
  PRIVATE SECTION.

    "! Monta o filtro de seleção
    METHODS build_custom_filter
      IMPORTING it_range  TYPE if_rap_query_filter=>tt_name_range_pairs
      EXPORTING es_filter TYPE ty_filter
                et_return TYPE ty_t_return.

    "! Aplica regras de agregação nas linhas do relatório
    METHODS apply_aggregation
      IMPORTING io_request TYPE REF TO if_rap_query_request
      CHANGING  ct_report  TYPE ty_t_report.

    "! Aplica ordenação nas linhas do relatório
    METHODS apply_sort
      IMPORTING io_request TYPE REF TO if_rap_query_request
      CHANGING  ct_report  TYPE ty_t_report.

ENDCLASS.



CLASS zclmm_ce_inventory_item IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

* ---------------------------------------------------------------------------
* Verifica se informação foi solicitada
* ---------------------------------------------------------------------------
    TRY.
        CHECK io_request->is_data_requested( ).
      CATCH cx_rfc_dest_provider_error  INTO DATA(lo_ex_dest).
        DATA(lv_exp_msg) = lo_ex_dest->get_longtext( ).
        RETURN.
    ENDTRY.

    DATA(lv_total_requested) = io_request->is_total_numb_of_rec_requested( ).
    DATA(lt_sort_elements)   = io_request->get_sort_elements( ).
    DATA(lt_req_elements)    = io_request->get_requested_elements( ).
    DATA(lt_aggr_element)    = io_request->get_aggregation( )->get_aggregated_elements( ).

* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

    " Ao navegar pra Object Page, devemos setar como um registro .
    lv_top      = COND #( WHEN lv_top <= 0 THEN 1 ELSE lv_top ).
    lv_max_rows = COND #( WHEN lv_max_rows <= 0 THEN 1 ELSE lv_max_rows ).

* ---------------------------------------------------------------------------
* Recupera e seta filtros de seleção
* ---------------------------------------------------------------------------
    TRY.
        DATA(lt_range)      = io_request->get_filter( )->get_as_ranges( ). "#EC CI_CONV_OK
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        lv_exp_msg = lo_ex_filter->get_longtext( ).
    ENDTRY.

    " Quando uma agregação/sumarização é solicitada, precisamos buscar todos os dados
    DATA(lv_set_top) = COND int8( WHEN lt_aggr_element[] IS NOT INITIAL
                                  THEN 999999
                                  ELSE lv_top ).

* ---------------------------------------------------------------------------
* Monta relatório
* ---------------------------------------------------------------------------
    me->build_report( EXPORTING it_range         = lt_range
                                iv_set_skip      = CONV #( lv_skip )
                                iv_set_top       = CONV #( lv_top )
                                it_sort_elements = lt_sort_elements
                      IMPORTING et_report        = DATA(lt_report)
                                et_return        = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Realiza as agregações de acordo com as annotatios na custom entity
* ---------------------------------------------------------------------------
    me->apply_aggregation( EXPORTING io_request = io_request
                           CHANGING  ct_report  = lt_report ).

* ---------------------------------------------------------------------------
* Atualiza ordenação (relatório analítico)
* ---------------------------------------------------------------------------
    me->apply_sort( EXPORTING io_request = io_request
                    CHANGING  ct_report  = lt_report ).

* ---------------------------------------------------------------------------
* Ajusta o total de linhas (relatório analítico)
* ---------------------------------------------------------------------------
    lv_top = lines( lt_report ).

* ---------------------------------------------------------------------------
* Caso necessite retornar algum dado para o Front
* ---------------------------------------------------------------------------
    io_response->set_data( it_data = lt_report ).
    io_response->set_total_number_of_records( lv_top ).

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ

      RAISE EXCEPTION NEW zcxmm_inventory_exception( it_return = lt_return ).

    ENDIF.

  ENDMETHOD.

  METHOD apply_aggregation.

    DATA: lt_report_s TYPE ty_t_report_s.
    DATA(lt_requested_elements) = io_request->get_requested_elements( ).
    DATA(lt_aggregated_element) = io_request->get_aggregation( )->get_aggregated_elements( ).

    CHECK lt_aggregated_element IS NOT INITIAL.

    LOOP AT lt_aggregated_element REFERENCE INTO DATA(ls_aggregated_elements).
      DELETE lt_requested_elements WHERE table_line = ls_aggregated_elements->result_element. "#EC CI_STDSEQ
      DATA(lv_aggregation) = |{ ls_aggregated_elements->aggregation_method }( { ls_aggregated_elements->input_element } ) as { ls_aggregated_elements->result_element }|.
      APPEND lv_aggregation TO lt_requested_elements.
    ENDLOOP.

    DATA(lv_req_elements)    = concat_lines_of( table = lt_requested_elements sep = ',' ).
    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    DATA(lv_grouping)        = concat_lines_of(  table = lt_grouped_element sep = ',' ).

    lt_report_s[] = ct_report[].
    SELECT (lv_req_elements) FROM @lt_report_s AS dados
                             GROUP BY (lv_grouping)
                             INTO CORRESPONDING FIELDS OF TABLE @ct_report.

  ENDMETHOD.


  METHOD apply_sort.

    DATA: lt_report_s TYPE ty_t_report_s.
    DATA(lt_sort_elements)   = io_request->get_sort_elements( ).

    CHECK lt_sort_elements IS NOT INITIAL.

    DATA(lt_sort) = VALUE string_table( FOR ls_sort_ IN lt_sort_elements ( COND #( WHEN ls_sort_-descending IS INITIAL
                                                                                   THEN ls_sort_-element_name
                                                                                   ELSE |{ ls_sort_-element_name } DESCENDING| ) ) ).

    DATA(lv_sort) = concat_lines_of( table = lt_sort[] sep = ',' ).

    lt_report_s[] = ct_report[].
    SELECT * FROM @lt_report_s AS dados
             ORDER BY (lv_sort)
             INTO CORRESPONDING FIELDS OF TABLE @ct_report.

  ENDMETHOD.


  METHOD build_custom_filter.

    DATA: lv_exp_msg TYPE bapiret2-message.

    FREE: es_filter, et_return.

    CHECK it_range[] IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Recupera os filtros de seleção
* ---------------------------------------------------------------------------
    TRY.
        es_filter-documentid                = VALUE #( FOR ls_range IN it_range[ name = 'DOCUMENTID' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO DATA(lo_root).
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-documentitemid            = VALUE #( FOR ls_range IN it_range[ name = 'DOCUMENTITEMID' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-statusid                  = VALUE #( FOR ls_range IN it_range[ name = 'STATUSID' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-statustext                = VALUE #( FOR ls_range IN it_range[ name = 'STATUSTEXT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-material                  = VALUE #( FOR ls_range IN it_range[ name = 'MATERIAL' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-materialname              = VALUE #( FOR ls_range IN it_range[ name = 'MATERIALNAME' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-storagelocation           = VALUE #( FOR ls_range IN it_range[ name = 'STORAGELOCATION' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-storagelocationname       = VALUE #( FOR ls_range IN it_range[ name = 'STORAGELOCATIONNAME' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-batch                     = VALUE #( FOR ls_range IN it_range[ name = 'BATCH' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

*    TRY.
*        es_filter-quantitystock             = VALUE #( FOR ls_range IN it_range[ name = 'QUANTITYSTOCK' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

    TRY.
        es_filter-quantitycount             = VALUE #( FOR ls_range IN it_range[ name = 'QUANTITYCOUNT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

*    TRY.
*        es_filter-quantitycurrent           = VALUE #( FOR ls_range IN it_range[ name = 'QUANTITYCURRENT' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

*    TRY.
*        es_filter-balance                   = VALUE #( FOR ls_range IN it_range[ name = 'BALANCE' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

*    TRY.
*        es_filter-balancecurrent            = VALUE #( FOR ls_range IN it_range[ name = 'BALANCECURRENT' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

    TRY.
        es_filter-unit                      = VALUE #( FOR ls_range IN it_range[ name = 'UNIT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

*    TRY.
*        es_filter-pricestock                = VALUE #( FOR ls_range IN it_range[ name = 'PRICESTOCK' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

*    TRY.
*        es_filter-pricecount                = VALUE #( FOR ls_range IN it_range[ name = 'PRICECOUNT' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

*    TRY.
*        es_filter-pricediff                 = VALUE #( FOR ls_range IN it_range[ name = 'PRICEDIFF' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

*    TRY.
*        es_filter-currency                  = VALUE #( FOR ls_range IN it_range[ name = 'CURRENCY' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

*    TRY.
*        es_filter-weight                    = VALUE #( FOR ls_range IN it_range[ name = 'WEIGHT' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

*    TRY.
*        es_filter-weightunit                = VALUE #( FOR ls_range IN it_range[ name = 'WEIGHTUNIT' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

    TRY.
        es_filter-accuracy                  = VALUE #( FOR ls_range IN it_range[ name = 'ACCURACY' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

*    TRY.
*        es_filter-companycode               = VALUE #( FOR ls_range IN it_range[ name = 'COMPANYCODE' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

*    TRY.
*        es_filter-companycodename           = VALUE #( FOR ls_range IN it_range[ name = 'COMPANYCODENAME' ]-range (
*                                                                                 sign   = ls_range-sign
*                                                                                 option = ls_range-option
*                                                                                 low    = ls_range-low
*                                                                                 high   = ls_range-high ) ).
*      CATCH cx_root INTO lo_root.
*        lv_exp_msg = lo_root->get_longtext( ).
*    ENDTRY.

    TRY.
        es_filter-physicalinventorydocument = VALUE #( FOR ls_range IN it_range[ name = 'PHYSICALINVENTORYDOCUMENT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-fiscalyear                = VALUE #( FOR ls_range IN it_range[ name = 'FISCALYEAR' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

  ENDMETHOD.


  METHOD build_report.

    FREE: et_report, et_return.

* ----------------------------------------------------------------------
* Monta filtros de seleção
* ----------------------------------------------------------------------
    me->build_custom_filter( EXPORTING it_range  = it_range
                             IMPORTING es_filter = DATA(ls_filter)
                                       et_return = et_return ).

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera dados de cabeçalho e item
* ----------------------------------------------------------------------
    me->get_info( EXPORTING is_filter   = ls_filter
                            iv_set_top  = iv_set_top
                            iv_set_skip = iv_set_skip
                  IMPORTING et_head     = DATA(lt_head)
                            et_item     = DATA(lt_item) ).

    DATA(lo_behavior) = zclmm_bd_inventory=>get_instance( ).

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
                                    IMPORTING et_report         = et_report
                                              et_return         = DATA(lt_return) ).

    INSERT LINES OF lt_return INTO TABLE et_return.

  ENDMETHOD.


  METHOD get_info.

    FREE: et_head, et_item.

* ----------------------------------------------------------------------
* Recupera os dados de Item
* ----------------------------------------------------------------------
    SELECT * FROM zi_mm_ce_inventory_item
        WHERE DocumentId                 IN @is_filter-DocumentId
          AND DocumentItemId             IN @is_filter-DocumentItemId
          AND StatusId                   IN @is_filter-StatusId
          AND StatusText                 IN @is_filter-StatusText
          AND Material                   IN @is_filter-Material
          AND MaterialName               IN @is_filter-MaterialName
          AND StorageLocation            IN @is_filter-StorageLocation
          AND StorageLocationName        IN @is_filter-StorageLocationName
          AND Batch                      IN @is_filter-Batch
*          AND QuantityStock              IN @is_filter-QuantityStock
          AND QuantityCount              IN @is_filter-QuantityCount
*          AND QuantityCurrent            IN @is_filter-QuantityCurrent
*          AND Balance                    IN @is_filter-Balance
*          AND BalanceCurrent             IN @is_filter-BalanceCurrent
          AND Unit                       IN @is_filter-Unit
*          AND PriceStock                 IN @is_filter-PriceStock
*          AND PriceCount                 IN @is_filter-PriceCount
*          AND PriceDiff                  IN @is_filter-PriceDiff
*          AND Currency                   IN @is_filter-Currency
*          AND Weight                     IN @is_filter-Weight
*          AND WeightUnit                 IN @is_filter-WeightUnit
*          AND Accuracy                   IN @is_filter-Accuracy
*          AND CompanyCode                IN @is_filter-CompanyCode
*          AND CompanyCodeName            IN @is_filter-CompanyCodeName
          AND PhysicalInventoryDocument  IN @is_filter-PhysicalInventoryDocument
          AND FiscalYear                 IN @is_filter-FiscalYear
*         ORDER BY DocumentId, DocumentItemId
         INTO CORRESPONDING FIELDS OF TABLE @et_item.
*         UP TO @iv_set_top ROWS
*         OFFSET @iv_set_skip.

    IF sy-subrc EQ 0 .
      SORT et_item BY DocumentId DocumentItemId.
    ENDIF.

    " Monta tabela de chaves
    DATA(lt_item_key) = et_item.
    SORT lt_item_key BY DocumentId.
    DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING DocumentId.

* ----------------------------------------------------------------------
* Recupera os dados de Cabeçalho
* ----------------------------------------------------------------------
    IF lt_item_key[] IS NOT INITIAL.

      SELECT * FROM zi_mm_ce_inventory_head
          FOR ALL ENTRIES IN @lt_item_key
          WHERE DocumentId   EQ @lt_item_key-DocumentId
          INTO TABLE @et_head.

      IF sy-subrc EQ 0 .
        SORT et_head BY DocumentId.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
