CLASS zclmm_ce_inventory_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .

    CONSTANTS:
      BEGIN OF gc_color,
        new      TYPE i VALUE 0,
        negative TYPE i VALUE 1,
        critical TYPE i VALUE 2,
        positive TYPE i VALUE 3,
      END OF gc_color,

      BEGIN OF gc_quantity_stock,
        rfc_failed     TYPE c LENGTH 60 VALUE 'Falha na conexão!'  ##NO_TEXT,
        no_stock_found TYPE c LENGTH 60 VALUE 'Estoque não encontrado!'  ##NO_TEXT,
        stock_found    TYPE c LENGTH 60 VALUE 'OK'  ##NO_TEXT,
      END OF gc_quantity_stock.

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
        Plant                     TYPE RANGE OF zc_mm_inventory_item-Plant,
        PlantName                 TYPE RANGE OF zc_mm_inventory_item-PlantName,
        StorageLocation           TYPE RANGE OF zc_mm_inventory_item-StorageLocation,
        StorageLocationName       TYPE RANGE OF zc_mm_inventory_item-StorageLocationName,
        Batch                     TYPE RANGE OF zc_mm_inventory_item-Batch,
        QuantityStock             TYPE RANGE OF zc_mm_inventory_item-QuantityStock,
        QuantityCount             TYPE RANGE OF zc_mm_inventory_item-QuantityCount,
        QuantityCurrent           TYPE RANGE OF zc_mm_inventory_item-QuantityCurrent,
        Balance                   TYPE RANGE OF zc_mm_inventory_item-Balance,
        BalanceCurrent            TYPE RANGE OF zc_mm_inventory_item-BalanceCurrent,
        Unit                      TYPE RANGE OF zc_mm_inventory_item-Unit,
        PriceStock                TYPE RANGE OF zc_mm_inventory_item-PriceStock,
        PriceCount                TYPE RANGE OF zc_mm_inventory_item-PriceCount,
        PriceDiff                 TYPE RANGE OF zc_mm_inventory_item-PriceDiff,
        Currency                  TYPE RANGE OF zc_mm_inventory_item-Currency,
        Weight                    TYPE RANGE OF zc_mm_inventory_item-Weight,
        WeightUnit                TYPE RANGE OF zc_mm_inventory_item-WeightUnit,
        Accuracy                  TYPE RANGE OF zc_mm_inventory_item-Accuracy,
        CompanyCode               TYPE RANGE OF zc_mm_inventory_item-CompanyCode,
        CompanyCodeName           TYPE RANGE OF zc_mm_inventory_item-CompanyCodeName,
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

    "! Chama RFC e recupera dados de inventário
    METHODS call_rfc_inventory_get_info
      IMPORTING it_rfc_head       TYPE z_s41_rfc_inventory_get_info=>zctgmm_inventory_head
                it_rfc_item       TYPE z_s41_rfc_inventory_get_info=>zctgmm_inventory_item
      EXPORTING et_material_stock TYPE z_s41_rfc_inventory_get_info=>zctgmm_inv_material_stock
                et_material_price TYPE z_s41_rfc_inventory_get_info=>zctgmm_inv_material_price
                et_phys_inv_info  TYPE z_s41_rfc_inventory_get_info=>zctgmm_inv_phys_inv_info
                et_return         TYPE ty_t_return.

    METHODS build_report_info
      IMPORTING it_head           TYPE ty_t_head
                it_item           TYPE ty_t_item
                it_material_stock TYPE z_s41_rfc_inventory_get_info=>zctgmm_inv_material_stock
                it_material_price TYPE z_s41_rfc_inventory_get_info=>zctgmm_inv_material_price
                it_phys_inv_info  TYPE z_s41_rfc_inventory_get_info=>zctgmm_inv_phys_inv_info
                it_return_rfc     TYPE ty_t_return OPTIONAL
      EXPORTING et_report         TYPE ty_t_report
                et_return         TYPE ty_t_return.


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

    DATA(lt_sort_elements)   = io_request->get_sort_elements( ).
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
        es_filter-plant                     = VALUE #( FOR ls_range IN it_range[ name = 'PLANT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-plantname                 = VALUE #( FOR ls_range IN it_range[ name = 'PLANTNAME' ]-range (
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

    TRY.
        es_filter-quantitystock             = VALUE #( FOR ls_range IN it_range[ name = 'QUANTITYSTOCK' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-quantitycount             = VALUE #( FOR ls_range IN it_range[ name = 'QUANTITYCOUNT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-quantitycurrent           = VALUE #( FOR ls_range IN it_range[ name = 'QUANTITYCURRENT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-balance                   = VALUE #( FOR ls_range IN it_range[ name = 'BALANCE' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-balancecurrent            = VALUE #( FOR ls_range IN it_range[ name = 'BALANCECURRENT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-unit                      = VALUE #( FOR ls_range IN it_range[ name = 'UNIT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-pricestock                = VALUE #( FOR ls_range IN it_range[ name = 'PRICESTOCK' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-pricecount                = VALUE #( FOR ls_range IN it_range[ name = 'PRICECOUNT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-pricediff                 = VALUE #( FOR ls_range IN it_range[ name = 'PRICEDIFF' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-currency                  = VALUE #( FOR ls_range IN it_range[ name = 'CURRENCY' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-weight                    = VALUE #( FOR ls_range IN it_range[ name = 'WEIGHT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-weightunit                = VALUE #( FOR ls_range IN it_range[ name = 'WEIGHTUNIT' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-accuracy                  = VALUE #( FOR ls_range IN it_range[ name = 'ACCURACY' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-companycode               = VALUE #( FOR ls_range IN it_range[ name = 'COMPANYCODE' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-companycodename           = VALUE #( FOR ls_range IN it_range[ name = 'COMPANYCODENAME' ]-range (
                                                                                 sign   = ls_range-sign
                                                                                 option = ls_range-option
                                                                                 low    = ls_range-low
                                                                                 high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

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

* ----------------------------------------------------------------------
* Recupera dados de inventário via RFC
* ----------------------------------------------------------------------
    me->call_rfc_inventory_get_info( EXPORTING it_rfc_head       = CORRESPONDING #( lt_head )
                                               it_rfc_item       = CORRESPONDING #( lt_item )
                                     IMPORTING et_material_stock = DATA(lt_material_stock)
                                               et_material_price = DATA(lt_material_price)
                                               et_phys_inv_info  = DATA(lt_phys_inv_info)
                                               et_return         = DATA(lt_return_rfc) ).

* ----------------------------------------------------------------------
* Atualiza relatório com os dados do inventário
* ----------------------------------------------------------------------
    me->build_report_info( EXPORTING it_head           = lt_head
                                     it_item           = lt_item
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
          AND Plant                      IN @is_filter-Plant
          AND PlantName                  IN @is_filter-PlantName
          AND StorageLocation            IN @is_filter-StorageLocation
          AND StorageLocationName        IN @is_filter-StorageLocationName
          AND Batch                      IN @is_filter-Batch
          AND QuantityStock              IN @is_filter-QuantityStock
          AND QuantityCount              IN @is_filter-QuantityCount
          AND QuantityCurrent            IN @is_filter-QuantityCurrent
          AND Balance                    IN @is_filter-Balance
          AND BalanceCurrent             IN @is_filter-BalanceCurrent
          AND Unit                       IN @is_filter-Unit
          AND PriceStock                 IN @is_filter-PriceStock
          AND PriceCount                 IN @is_filter-PriceCount
          AND PriceDiff                  IN @is_filter-PriceDiff
          AND Currency                   IN @is_filter-Currency
          AND Weight                     IN @is_filter-Weight
          AND WeightUnit                 IN @is_filter-WeightUnit
*          AND Accuracy                   IN @is_filter-Accuracy
*          AND CompanyCode                IN @is_filter-CompanyCode
*          AND CompanyCodeName            IN @is_filter-CompanyCodeName
          AND PhysicalInventoryDocument  IN @is_filter-PhysicalInventoryDocument
          AND FiscalYear                 IN @is_filter-FiscalYear
         ORDER BY DocumentId, DocumentItemId
         INTO TABLE @et_item
         UP TO @iv_set_top ROWS
         OFFSET @iv_set_skip.

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


  METHOD call_rfc_inventory_get_info.

    DATA: lo_dest  TYPE REF TO if_rfc_dest,
          lo_myobj TYPE REF TO z_s41_rfc_inventory_get_info,
          lv_text  TYPE bapiret2-message.

    FREE: et_material_stock, et_material_price, et_phys_inv_info, et_return.

    CHECK it_rfc_head IS NOT INITIAL.
    CHECK it_rfc_item IS NOT INITIAL.

* ----------------------------------------------------------------------
* Chama RFC
* ----------------------------------------------------------------------
    TRY.
        lo_dest = cl_rfc_destination_provider=>create_by_cloud_destination( i_name = 'S41_RFC_120' ).

        CREATE OBJECT lo_myobj
          EXPORTING
            destination = lo_dest.

        " Execução da BAPI via RFC
        lo_myobj->zfmmm_inventory_get_info(
           EXPORTING
             it_head           = it_rfc_head
             it_item           = it_rfc_item
           IMPORTING
             et_material_stock = et_material_stock
             et_material_price = et_material_price
             et_phys_inv_info  = et_phys_inv_info
         ).

      CATCH  cx_aco_communication_failure INTO DATA(lo_comm).
        lv_text = lo_comm->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).
      CATCH cx_aco_system_failure INTO DATA(lo_sys).
        lv_text = lo_sys->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).
      CATCH cx_aco_application_exception INTO DATA(lo_appl).
        lv_text = lo_appl->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).
      CATCH cx_rfc_dest_provider_error INTO DATA(lo_error).
        lv_text = lo_error->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).
    ENDTRY.

    SORT et_material_stock BY enddate material plant storagelocation batch materialbaseunit.
    SORT et_material_price BY valuationarea Material baseunit currency.
    SORT et_phys_inv_info BY fiscalyear physicalinventorydocument.

  ENDMETHOD.


  METHOD build_report_info.

    DATA: ls_report TYPE ty_report.

    FREE: et_report, et_return.

    LOOP AT it_item REFERENCE INTO DATA(ls_item).

      " Recupera dados de cabeçalho
      READ TABLE it_head REFERENCE INTO DATA(ls_head) WITH KEY documentid = ls_item->DocumentId BINARY SEARCH.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Recupera dados estoque de material (contagem)
      READ TABLE it_material_stock INTO DATA(ls_mat_stock_count) WITH KEY EndDate          = ls_head->countdate
                                                                          Material         = ls_item->Material
                                                                          Plant            = ls_item->Plant
                                                                          StorageLocation  = ls_item->StorageLocation
                                                                          Batch            = ls_item->Batch
                                                                          MaterialBaseUnit = ls_item->Unit
                                                                          BINARY SEARCH.

      IF sy-subrc NE 0.
        CLEAR ls_mat_stock_count.
      ENDIF.

      " Recupera dados estoque de material (contagem)
      READ TABLE it_material_stock INTO DATA(ls_mat_stock_current) WITH KEY EndDate          = ls_head->countdate
                                                                            Material         = ls_item->Material
                                                                            Plant            = ls_item->Plant
                                                                            StorageLocation  = ls_item->StorageLocation
                                                                            Batch            = ls_item->Batch
                                                                            MaterialBaseUnit = ls_item->Unit
                                                                            BINARY SEARCH.

      IF sy-subrc NE 0.
        CLEAR ls_mat_stock_current.
      ENDIF.

      " Recupera preço do material
      READ TABLE it_material_price INTO DATA(ls_material_price) WITH KEY valuationarea = ls_item->Plant
                                                                            Material   = ls_item->Material
                                                                            baseunit   = ls_item->Unit
                                                                            currency   = 'BRL'
                                                                            BINARY SEARCH.
      IF sy-subrc NE 0.

        READ TABLE it_material_price INTO ls_material_price WITH KEY valuationarea = ls_item->Plant
                                                                     Material   = ls_item->Material
                                                                     baseunit   = ls_item->Unit
                                                                     BINARY SEARCH.

        IF sy-subrc NE 0.
          CLEAR ls_mat_stock_current.
        ENDIF.
      ENDIF.


      " Recupera dados de inventário
      READ TABLE it_phys_inv_info INTO DATA(ls_phys_inv_info) WITH KEY FiscalYear                = ls_item->FiscalYear
                                                                       PhysicalInventoryDocument = ls_item->PhysicalInventoryDocument
                                                                       BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_phys_inv_info.
      ENDIF.


      CLEAR ls_report.
      ls_report = CORRESPONDING #( ls_item->* ).

      ls_report-MaterialName                = COND #( WHEN ls_report-MaterialName IS NOT INITIAL
                                                      THEN ls_report-MaterialName
                                                      WHEN ls_mat_stock_count-MaterialName IS NOT INITIAL
                                                      THEN ls_mat_stock_count-MaterialName
                                                      WHEN ls_mat_stock_current-MaterialName IS NOT INITIAL
                                                      THEN ls_mat_stock_current-MaterialName
                                                      ELSE space ).

      ls_report-PlantName                   = COND #( WHEN ls_report-PlantName IS NOT INITIAL
                                                      THEN ls_report-PlantName
                                                      WHEN ls_mat_stock_count-PlantName IS NOT INITIAL
                                                      THEN ls_mat_stock_count-PlantName
                                                      WHEN ls_mat_stock_current-PlantName IS NOT INITIAL
                                                      THEN ls_mat_stock_current-PlantName
                                                      ELSE space ).

      ls_report-StorageLocationName         = COND #( WHEN ls_report-StorageLocationName IS NOT INITIAL
                                                      THEN ls_report-StorageLocationName
                                                      WHEN ls_mat_stock_count-StorageLocationName IS NOT INITIAL
                                                      THEN ls_mat_stock_count-StorageLocationName
                                                      WHEN ls_mat_stock_current-StorageLocationName IS NOT INITIAL
                                                      THEN ls_mat_stock_current-StorageLocationName
                                                      ELSE space ).

      ls_report-QuantityStock               = ls_mat_stock_count-PeriodQuantity.

      ls_report-QuantityStockText           = COND #( WHEN it_return_rfc IS NOT INITIAL " Ocorreu algum erro na chamada RFC
                                                      THEN gc_quantity_stock-rfc_failed
                                                      ELSE gc_quantity_stock-stock_found ).

      ls_report-QuantityStockCrit           = COND #( WHEN it_return_rfc IS NOT INITIAL
                                                      THEN gc_color-negative
                                                      WHEN ls_mat_stock_count IS INITIAL
                                                      THEN gc_color-critical
                                                      ELSE gc_color-positive ).

      ls_report-QuantityCurrent             = ls_mat_stock_current-PeriodQuantity.

      ls_report-QuantityCurrentCrit         = COND #( WHEN it_return_rfc IS NOT INITIAL
                                                      THEN gc_color-negative
                                                      WHEN ls_mat_stock_current IS INITIAL
                                                      THEN gc_color-critical
                                                      ELSE gc_color-positive ).

      ls_report-balance                     = ls_report-QuantityCount - ls_report-QuantityStock.
      ls_report-balancecurrent              = ls_report-QuantityCount - ls_report-QuantityCurrent.

      TRY.
          ls_report-pricestock              = ( ls_material_price-inventoryprice / ls_material_price-materialpriceunitqty ) * ls_report-quantitystock.
        CATCH cx_root.
          ls_report-pricestock              = 0.
      ENDTRY.

      TRY.
          ls_report-pricecount              = ( ls_material_price-inventoryprice / ls_material_price-materialpriceunitqty ) * ls_report-quantitycount.
        CATCH cx_root.
          ls_report-pricecount              = 0.
      ENDTRY.

      TRY.
          ls_report-pricediff               = abs( ( ls_material_price-inventoryprice / ls_material_price-materialpriceunitqty ) * ls_report-balance ).
        CATCH cx_root.
          ls_report-pricediff               = 0.
      ENDTRY.

      ls_report-currency                    = ls_material_price-currency.

      TRY.
          ls_report-weight                  =  ls_material_price-grossweight * ls_report-balance.
        CATCH cx_root.
          ls_report-weight                  = 0.
      ENDTRY.

      TRY.
          ls_report-weightunit              = ls_material_price-weightunit.
        CATCH cx_root.
          ls_report-weightunit              = space.
      ENDTRY.

      TRY.
          ls_report-accuracy                = ( 1 - ( ls_report-pricediff / ls_report-pricestock ) ) * 100.
        CATCH cx_root.
          ls_report-accuracy                = 0.
      ENDTRY.

      ls_report-MaterialDocument            = ls_phys_inv_info-MaterialDocument.
      ls_report-MaterialDocumentYear        = ls_phys_inv_info-MaterialDocumentYear.
      ls_report-PostingDate                 = ls_phys_inv_info-postingdate.
      ls_report-BR_NotaFiscal               = ls_phys_inv_info-br_notafiscal.
      ls_report-BR_NFeNumber                = ls_phys_inv_info-br_nfenumber.
      ls_report-BR_NFIsCanceled             = ls_phys_inv_info-br_nfiscanceled.
      ls_report-BR_NFeDocumentStatus        = ls_phys_inv_info-br_nfedocumentstatus.
      ls_report-BR_NFeDocumentStatusText    = ls_phys_inv_info-br_nfedocumentstatustext.
      ls_report-CompanyCode                 = ls_phys_inv_info-companycode.
      ls_report-CompanyCodeName             = ls_phys_inv_info-CompanyCodeName.
      ls_report-AccountingDocument          = ls_phys_inv_info-accountingdocument.
      ls_report-AccountingDocumentYear      = ls_phys_inv_info-accountingdocumentyear.
      ls_report-ExternalReference           = ls_phys_inv_info-externalreference.
      ls_report-DocumentDate                = ls_phys_inv_info-documentdate.

      ls_report-ProductHierarchy            = ls_material_price-producthierarchy.


      et_report = VALUE #( BASE et_report ( ls_report ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
