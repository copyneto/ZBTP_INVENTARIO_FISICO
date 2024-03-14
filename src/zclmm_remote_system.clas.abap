CLASS zclmm_remote_system DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_configuration,
             cloud_destination       TYPE string,
             service_definition_name TYPE cl_web_odata_client_factory=>ty_service_definition_name,
             relative_service_root   TYPE string,
           END OF ty_configuration,

           ty_t_return TYPE STANDARD TABLE OF bapiret2.

    METHODS constructor
      IMPORTING
        iv_cloud_destination       TYPE string
        iv_service_definition_name TYPE cl_web_odata_client_factory=>ty_service_definition_name
        iv_relative_service_root   TYPE string.

    "! Recupera lista de Centros em outro sistema
    METHODS call_odata_read_list
      IMPORTING
        !iv_cds_name      TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name
        !it_range         TYPE if_rap_query_filter=>tt_name_range_pairs
        !it_sort          TYPE if_rap_query_request=>tt_sort_elements OPTIONAL
        !iv_set_top       TYPE i DEFAULT 50
        !iv_set_skip      TYPE i DEFAULT 0
        !iv_request_count TYPE abap_boolean DEFAULT space
      EXPORTING
        !et_data          TYPE ANY TABLE
        !ev_count         TYPE int8
        !et_return        TYPE ty_t_return.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: gs_configuration TYPE ty_configuration.


    "! Recupera lista de Centros em outro sistema
    METHODS configure_filter
      IMPORTING
        !io_request          TYPE REF TO /iwbep/if_cp_request_read_list
        !it_range            TYPE if_rap_query_filter=>tt_name_range_pairs
      EXPORTING
        !eo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node
        !et_return           TYPE ty_t_return.
ENDCLASS.



CLASS ZCLMM_REMOTE_SYSTEM IMPLEMENTATION.


  METHOD constructor.

    gs_configuration = VALUE #( cloud_destination       = iv_cloud_destination
                                service_definition_name = iv_service_definition_name
                                relative_service_root   = iv_relative_service_root ).

  ENDMETHOD.


  METHOD call_odata_read_list.

    DATA:
      lo_http_client  TYPE REF TO if_web_http_client,
      lo_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request      TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response     TYPE REF TO /iwbep/if_cp_response_read_lst,
      lv_text         TYPE bapiret2-message.

    FREE: et_data, ev_count, et_return.

* ---------------------------------------------------------------------------
* Configura HTTP
* ---------------------------------------------------------------------------
    TRY.
        "
        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination( i_name       = gs_configuration-cloud_destination
                                                                                          i_authn_mode = if_a4c_cp_service=>service_specific ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

*        lo_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
*          EXPORTING
*            iv_service_definition_name = gs_configuration-service_definition_name
*            io_http_client             = lo_http_client
*            iv_relative_service_root   = gs_configuration-relative_service_root ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      =  gs_configuration-service_definition_name
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = gs_configuration-relative_service_root ).

        ASSERT lo_http_client IS BOUND.

* ---------------------------------------------------------------------------
* Navegue até o recurso e criar uma solicitação para operação de leitura
* ---------------------------------------------------------------------------
        lo_request = lo_client_proxy->create_resource_for_entity_set( iv_cds_name )->create_request_for_read( ).

* ---------------------------------------------------------------------------
* Criar filtros de seleção
* ---------------------------------------------------------------------------
        me->configure_filter( EXPORTING io_request          = lo_request
                                        it_range            = it_range
                              IMPORTING eo_filter_node_root = DATA(lo_filter_node_root)
                                        et_return           = DATA(lt_return) ).

        IF lt_return IS NOT INITIAL.
          INSERT LINES OF lt_return INTO TABLE et_return.
          RETURN.
        ENDIF.

        IF lo_filter_node_root IS NOT INITIAL.
          lo_request->set_filter( lo_filter_node_root ).
        ENDIF.

* ---------------------------------------------------------------------------
* Criar ordem de classificação
* ---------------------------------------------------------------------------
        IF it_sort IS NOT INITIAL.
          lo_request->set_orderby( EXPORTING it_orderby_property = VALUE #( FOR ls_sort IN it_sort ( property_path = ls_sort-element_name
                                                                                                     descending    = ls_sort-descending ) ) ).
        ENDIF.

* ---------------------------------------------------------------------------
* Executa a chamada remota e recupera os dados
* ---------------------------------------------------------------------------
        IF iv_request_count NE abap_true.
          lo_request->set_top( iv_set_top )->set_skip( iv_set_skip ).

          lo_response = lo_request->execute( ).
          lo_response->get_business_data( IMPORTING et_business_data = et_data ).

* ---------------------------------------------------------------------------
* Solicita apenas a contagem dos registros
* ---------------------------------------------------------------------------
        ELSE.
          lo_request->request_count( ).
          lo_request->request_no_business_data( ).
          lo_response = lo_request->execute( ).
          lo_response->get_count( RECEIVING rv_count = ev_count ).
        ENDIF.

      CATCH /iwbep/cx_cp_remote INTO DATA(lo_remote).
        lv_text = lo_remote->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).

      CATCH /iwbep/cx_gateway INTO DATA(lo_gateway).
        lv_text = lo_gateway->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).

      CATCH cx_web_http_client_error INTO DATA(lo_client_error).
        lv_text = lo_client_error->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).

      CATCH cx_http_dest_provider_error  INTO DATA(lo_provider_error).
        lv_text = lo_provider_error->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD configure_filter.

    DATA:
      lo_filter_factory TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node    TYPE REF TO /iwbep/if_cp_filter_node,
      lv_text           TYPE bapiret2-message.

    FREE: eo_filter_node_root, et_return.

    TRY.
        LOOP AT it_range REFERENCE INTO DATA(ls_range).

          lo_filter_factory = io_request->create_filter_factory( ).

          " Prepara dados para montagem do filtro
          IF ls_range->range[] IS NOT INITIAL.
            lo_filter_node  = lo_filter_factory->create_by_range( iv_property_path     = ls_range->name
                                                                  it_range             = ls_range->range[] ).
          ELSE.
            FREE lo_filter_node.
          ENDIF.

          " Monta filtro para seleção
          IF eo_filter_node_root IS INITIAL.
            eo_filter_node_root = lo_filter_node.
          ELSE.
            eo_filter_node_root->and( lo_filter_node ).
          ENDIF.

        ENDLOOP.

      CATCH /iwbep/cx_gateway INTO DATA(lo_gateway).
        lv_text = lo_gateway->get_longtext( ).
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_REMOTE_SYSTEM' number = '000' message_v1 = lv_text+0(50) message_v2 = lv_text+50(50) message_v3 = lv_text+100(50) message_v4 = lv_text+150(50) ) ).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
