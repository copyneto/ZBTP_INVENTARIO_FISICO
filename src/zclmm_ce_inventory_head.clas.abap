CLASS zclmm_ce_inventory_head DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .

    TYPES:
      ty_t_report_s TYPE SORTED TABLE OF zc_mm_ce_inventory_head
                    WITH NON-UNIQUE KEY DocumentId,
      ty_t_report   TYPE STANDARD TABLE OF zc_mm_ce_inventory_head,
      ty_t_return   TYPE STANDARD TABLE OF bapiret2,

      BEGIN OF ty_filter,
        DocumentId  TYPE RANGE OF zc_mm_inventory_head-DocumentId,
        DocumentNo  TYPE RANGE OF zc_mm_inventory_head-DocumentNo,
        CountId     TYPE RANGE OF zc_mm_inventory_head-CountId,
        CountDate   TYPE RANGE OF zc_mm_inventory_head-CountDate,
        StatusId    TYPE RANGE OF zc_mm_inventory_head-StatusId,
        StatusText  TYPE RANGE OF zc_mm_inventory_head-StatusText,
        Plant       TYPE RANGE OF zc_mm_inventory_head-Plant,
        PlantName   TYPE RANGE OF zc_mm_inventory_head-PlantName,
        Description TYPE RANGE OF zc_mm_inventory_head-Description,
      END OF ty_filter.

    METHODS build_report
      IMPORTING it_range         TYPE if_rap_query_filter=>tt_name_range_pairs OPTIONAL
                it_sort_elements TYPE if_rap_query_request=>tt_sort_elements OPTIONAL
                iv_set_top       TYPE i DEFAULT 50
                iv_set_skip      TYPE i DEFAULT 0
      EXPORTING et_report        TYPE ty_t_report
                et_return        TYPE ty_t_return.

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



CLASS zclmm_ce_inventory_head IMPLEMENTATION.


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
* Recupera e monta os filtros de seleção
* ---------------------------------------------------------------------------
    TRY.
        es_filter-documentid        = VALUE #( FOR ls_range IN it_range[ name = 'DOCUMENTID' ]-range (
                                                                         sign   = ls_range-sign
                                                                         option = ls_range-option
                                                                         low    = ls_range-low
                                                                         high   = ls_range-high ) ).
      CATCH cx_root INTO DATA(lo_root).
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-documentno        = VALUE #( FOR ls_range IN it_range[ name = 'DOCUMENTNO' ]-range (
                                                                         sign   = ls_range-sign
                                                                         option = ls_range-option
                                                                         low    = ls_range-low
                                                                         high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-countid           = VALUE #( FOR ls_range IN it_range[ name = 'COUNTID' ]-range (
                                                                         sign   = ls_range-sign
                                                                         option = ls_range-option
                                                                         low    = ls_range-low
                                                                         high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-countdate          = VALUE #( FOR ls_range IN it_range[ name = 'COUNTDATE' ]-range (
                                                                         sign   = ls_range-sign
                                                                         option = ls_range-option
                                                                         low    = ls_range-low
                                                                         high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-statusid          = VALUE #( FOR ls_range IN it_range[ name = 'STATUSID' ]-range (
                                                                         sign   = ls_range-sign
                                                                         option = ls_range-option
                                                                         low    = ls_range-low
                                                                         high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-statustext        = VALUE #( FOR ls_range IN it_range[ name = 'STATUSTEXT' ]-range (
                                                                         sign   = ls_range-sign
                                                                         option = ls_range-option
                                                                         low    = ls_range-low
                                                                         high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-plant             = VALUE #( FOR ls_range IN it_range[ name = 'PLANT' ]-range (
                                                                         sign   = ls_range-sign
                                                                         option = ls_range-option
                                                                         low    = ls_range-low
                                                                         high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-plantname         = VALUE #( FOR ls_range IN it_range[ name = 'PLANTNAME' ]-range (
                                                                         sign   = ls_range-sign
                                                                         option = ls_range-option
                                                                         low    = ls_range-low
                                                                         high   = ls_range-high ) ).
      CATCH cx_root INTO lo_root.
        lv_exp_msg = lo_root->get_longtext( ).
    ENDTRY.

    TRY.
        es_filter-description       = VALUE #( FOR ls_range IN it_range[ name = 'DESCRIPTION' ]-range (
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

    IF line_exists( et_return[ type = 'E' ] ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera os dados de cabeçalho
* ----------------------------------------------------------------------
    SELECT * FROM zi_mm_ce_inventory_head
        WHERE DocumentId   IN @ls_filter-DocumentId
          AND DocumentNo   IN @ls_filter-DocumentNo
          AND CountId      IN @ls_filter-CountId
          AND CountDate    IN @ls_filter-CountDate
          AND StatusId     IN @ls_filter-StatusId
          AND StatusText   IN @ls_filter-StatusText
          AND Plant        IN @ls_filter-Plant
          AND PlantName    IN @ls_filter-PlantName
          AND Description  IN @ls_filter-Description
*         ORDER BY DocumentId
         INTO CORRESPONDING FIELDS OF TABLE @et_report.
*         UP TO @iv_set_top ROWS
*         OFFSET @iv_set_skip.

    IF sy-subrc NE 0 .
      FREE et_report.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
