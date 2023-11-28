CLASS zclmm_ce_vh_plant DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

    TYPES: ty_t_data TYPE STANDARD TABLE OF zclmm_s41_cds_inventario=>tys_zi_mm_vh_planttype,
           ty_t_cds  TYPE STANDARD TABLE OF zi_mm_ce_vh_plant.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_ce_vh_plant IMPLEMENTATION.
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
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        lv_exp_msg = lo_ex_filter->get_longtext( ).
    ENDTRY.

* ---------------------------------------------------------------------------
* Chama ODATA para buscar dados da CDS
* ---------------------------------------------------------------------------
    DATA(lo_remote) = NEW zclmm_remote_system( iv_cloud_destination       = 'S41_HTTP_120'
                                               iv_service_definition_name = 'Z_S41_CDS_INVENTARIO'
                                               iv_relative_service_root   = '/sap/opu/odata/sap/ZUI_O2_CDS_INVENTARIO/' ).

    lo_remote->call_odata_read_list( EXPORTING iv_cds_name = 'ZI_MM_VH_PLANT'
                                               it_range    = lt_range
                                               iv_set_top  = CONV #( lv_top )
                                               iv_set_skip = CONV #( lv_skip )
                                     IMPORTING et_data     = lt_data
                                               et_return   = DATA(lt_return) ).

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

*      RAISE EXCEPTION NEW zcxmm_inventory_exception( it_return = lt_return ).

    ENDIF.
  ENDMETHOD.

ENDCLASS.
