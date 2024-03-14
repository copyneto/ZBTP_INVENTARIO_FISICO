CLASS zclmm_ce_vh_product_hierarchy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .

    TYPES: ty_t_data TYPE STANDARD TABLE OF zclmm_s41_cds_inventario=>tys_zi_mm_vh_product_hierarc_2,
           ty_cds    TYPE zi_mm_ce_vh_product_hierarchy,
           ty_t_cds  TYPE STANDARD TABLE OF ty_cds.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS filter_search_expression
      IMPORTING iv_search_expression TYPE string
      CHANGING  ct_data              TYPE ty_t_data.

    "! Aplica ordenação nas linhas do relatório
    METHODS apply_sort
      IMPORTING it_sort_elements TYPE if_rap_query_request=>tt_sort_elements
      CHANGING  ct_data          TYPE ty_t_data.

ENDCLASS.



CLASS ZCLMM_CE_VH_PRODUCT_HIERARCHY IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_data TYPE ty_t_data,
          lt_cds  TYPE ty_t_cds.

* ---------------------------------------------------------------------------
* Verifica se informação foi solicitada
* ---------------------------------------------------------------------------
    TRY.
        CHECK io_request->is_data_requested( ).
      CATCH cx_rfc_dest_provider_error  INTO DATA(lo_ex_dest).
        DATA(lv_exp_msg) = lo_ex_dest->get_longtext( ).
        RETURN.
    ENDTRY.

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
        DATA(lt_range)  = io_request->get_filter( )->get_as_ranges( ).
        DELETE lt_range WHERE name = 'PRODUCTHIERARCHYTEXT'.

      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        lv_exp_msg = lo_ex_filter->get_longtext( ).
    ENDTRY.

* ---------------------------------------------------------------------------
* Chama ODATA para buscar dados da CDS
* ---------------------------------------------------------------------------
    DATA(lo_remote) = NEW zclmm_remote_system( iv_cloud_destination       = 'S41_HTTP_120'
                                               iv_service_definition_name = 'Z_S41_CDS_INVENTARIO'
                                               iv_relative_service_root   = '/sap/opu/odata/sap/ZUI_O2_CDS_INVENTARIO/' ).

    lo_remote->call_odata_read_list( EXPORTING iv_cds_name = 'ZI_MM_VH_PRODUCT_HIERARCHY'
                                               it_range    = lt_range
                                               iv_set_top  = CONV #( lv_top )
                                               iv_set_skip = CONV #( lv_skip )
                                     IMPORTING et_data     = lt_data
                                               et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Filtra resultado de acordo com a expressão regular informada na tela
* ---------------------------------------------------------------------------
    DATA(lv_search_expression) = io_request->get_search_expression( ).

    me->filter_search_expression( EXPORTING iv_search_expression = lv_search_expression
                                  CHANGING  ct_data              = lt_data ).

* ---------------------------------------------------------------------------
* Aplica ordenação dos resultados
* ---------------------------------------------------------------------------
    DATA(lt_sort_elements) = io_request->get_sort_elements( ).

    me->apply_sort( EXPORTING it_sort_elements = lt_sort_elements
                    CHANGING  ct_data          = lt_data ).

* ---------------------------------------------------------------------------
* Caso haja necessidade, implementações futuras
* ---------------------------------------------------------------------------

    DATA(lo_aggregation)        = io_request->get_aggregation( ).
    DATA(lv_entity_id)          = io_request->get_entity_id( ).
    DATA(lt_requested_elements) = io_request->get_requested_elements( ).

* ---------------------------------------------------------------------------
* Transfere os dados do formato ODATA para Tabela
* ---------------------------------------------------------------------------
    lt_cds = CORRESPONDING #( lt_data ).

* ---------------------------------------------------------------------------
* Caso necessite retornar algum dado para o Front
* ---------------------------------------------------------------------------
    io_response->set_data( it_data = lt_cds ).
    io_response->set_total_number_of_records( lines( lt_cds ) ).

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).

      RAISE EXCEPTION NEW zcxmm_inventory_exception( it_return = lt_return ).

    ENDIF.

  ENDMETHOD.


  METHOD filter_search_expression.

    CHECK iv_search_expression IS NOT INITIAL.

    DATA(lv_search) = iv_search_expression.
    REPLACE ALL OCCURRENCES OF '"' IN lv_search WITH space.

    LOOP AT ct_data REFERENCE INTO DATA(ls_data).

      DATA(lv_index) = sy-tabix.

      FIND lv_search IN ls_data->producthierarchy.

      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.

      FIND lv_search IN ls_data->producthierarchytext.

      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.

      DELETE ct_data INDEX lv_Index.

    ENDLOOP.

  ENDMETHOD.


  METHOD apply_sort.

    DATA: lt_data TYPE SORTED TABLE OF ty_cds WITH NON-UNIQUE KEY producthierarchy.

    CHECK it_sort_elements IS NOT INITIAL.

    DATA(lt_sort) = VALUE string_table( FOR ls_sort_ IN it_sort_elements ( COND #( WHEN ls_sort_-descending IS INITIAL
                                                                                   THEN ls_sort_-element_name
                                                                                   ELSE |{ ls_sort_-element_name } DESCENDING| ) ) ).

    DATA(lv_sort) = concat_lines_of( table = lt_sort[] sep = ',' ).

    lt_data = ct_data.
    SELECT * FROM @lt_data AS dados
             ORDER BY (lv_sort)
             INTO CORRESPONDING FIELDS OF TABLE @ct_data.

  ENDMETHOD.
ENDCLASS.
