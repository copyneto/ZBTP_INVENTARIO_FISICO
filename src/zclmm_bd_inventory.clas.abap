CLASS zclmm_bd_inventory DEFINITION
  PUBLIC
  INHERITING FROM cl_abap_behv
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_t_head_create      TYPE TABLE FOR CREATE zc_mm_ce_inventory_head\\_head,
      ty_t_head_update      TYPE TABLE FOR UPDATE zc_mm_ce_inventory_head\\_head,

      ty_t_item_create      TYPE TABLE FOR CREATE zc_mm_ce_inventory_head\\_head\_item,
      ty_t_item_update      TYPE TABLE FOR UPDATE zc_mm_ce_inventory_head\\_item,
      ty_t_item_read_import TYPE TABLE FOR READ IMPORT zc_mm_ce_inventory_head\\_item,
      ty_t_item_read_result TYPE TABLE FOR READ RESULT zc_mm_ce_inventory_head\\_item,

      ty_reported           TYPE RESPONSE FOR REPORTED EARLY zc_mm_ce_inventory_head,
      ty_failed             TYPE RESPONSE FOR FAILED EARLY zc_mm_ce_inventory_head,
      ty_t_return           TYPE STANDARD TABLE OF bapiret2,
      ty_head               TYPE zc_mm_ce_inventory_head,
      ty_t_head             TYPE STANDARD TABLE OF ty_head,
      ty_item               TYPE zc_mm_ce_inventory_item,
      ty_t_item             TYPE STANDARD TABLE OF ty_item,
      ty_log                TYPE zc_mm_ce_inventory_log,
      ty_t_log              TYPE STANDARD TABLE OF ty_log,
      ty_fieldname          TYPE c LENGTH 30,
      ty_t_fieldname        TYPE STANDARD TABLE OF ty_fieldname,

      BEGIN OF ty_operation,
        insert  TYPE abap_boolean,
        update  TYPE abap_boolean,
        delete  TYPE abap_boolean,
        release TYPE abap_boolean,
      END OF ty_operation.

    CONSTANTS:
      BEGIN OF gc_cds,
        head TYPE string VALUE 'ZC_MM_CE_INVENTORY_HEAD',
        item TYPE string VALUE 'ZC_MM_CE_INVENTORY_ITEM',
        log  TYPE string VALUE 'ZC_MM_CE_INVENTORY_LOG',
      END OF gc_cds,

      BEGIN OF gc_status_head,
        created  TYPE zc_mm_ce_inventory_head-StatusId VALUE '00', " Criado
        pending  TYPE zc_mm_ce_inventory_head-StatusId VALUE '01', " Pendente
        released TYPE zc_mm_ce_inventory_head-StatusId VALUE '02', " Liberado
        canceled TYPE zc_mm_ce_inventory_head-StatusId VALUE '03', " Cancelado
        complete TYPE zc_mm_ce_inventory_head-StatusId VALUE '04', " Concluido
      END OF gc_status_head,

      BEGIN OF gc_status_item,
        pending       TYPE zc_mm_ce_inventory_item-StatusId VALUE '00', " Pendente
        released      TYPE zc_mm_ce_inventory_item-StatusId VALUE '01', " Liberado
        pending_count TYPE zc_mm_ce_inventory_item-StatusId VALUE '02', " Pendente Contagem
        complete      TYPE zc_mm_ce_inventory_item-StatusId VALUE '03', " Concluido
        canceled      TYPE zc_mm_ce_inventory_item-StatusId VALUE '04', " Cancelado
      END OF gc_status_item.

    "! Cria instancia
    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zclmm_bd_inventory.

    "! Cria novo GUID
    METHODS create_guid
      EXPORTING et_return      TYPE ty_t_return
      RETURNING VALUE(rv_guid) TYPE sysuuid_x16.

    "! Recupera as informações de inventário
    METHODS get_data
      IMPORTING it_head_key TYPE ty_t_head OPTIONAL
                it_item_key TYPE ty_t_item OPTIONAL
                it_log_key  TYPE ty_t_log OPTIONAL
      EXPORTING et_head     TYPE ty_t_head
                et_item     TYPE ty_t_item
                et_log      TYPE ty_t_log
                et_return   TYPE ty_t_return.

    "! Cria linha de cabeçalho
    METHODS create_head
      IMPORTING it_entities TYPE ty_t_head_create
      EXPORTING et_head     TYPE ty_t_head
                et_return   TYPE ty_t_return.

    "! Atualiza linha de cabeçalho
    METHODS update_head
      IMPORTING it_entities TYPE ty_t_head_update
      EXPORTING et_head     TYPE ty_t_head
                et_return   TYPE ty_t_return.

    "! Cria linha de item
    METHODS create_item
      IMPORTING it_entities TYPE ty_t_item_create
      EXPORTING et_item     TYPE ty_t_item
                et_return   TYPE ty_t_return.


    "! Atualiza linha de item
    METHODS update_item
      IMPORTING it_entities TYPE ty_t_item_update
      EXPORTING et_head     TYPE ty_t_head
                et_item     TYPE ty_t_item
                et_return   TYPE ty_t_return.

    "! Atualiza campo com o novo valor
    METHODS update_field
      IMPORTING iv_fieldname TYPE ty_fieldname OPTIONAL
                it_fieldname TYPE ty_t_fieldname OPTIONAL
                is_control   TYPE any
                is_new_data  TYPE any
      CHANGING  cs_data      TYPE any.

    "! Prepara os dados para serem inseridos na tabela
    METHODS prepare_commit
      IMPORTING iv_insert TYPE abap_boolean OPTIONAL
                iv_update TYPE abap_boolean OPTIONAL
                iv_delete TYPE abap_boolean OPTIONAL
                it_head   TYPE ty_t_head OPTIONAL
                it_item   TYPE ty_t_item OPTIONAL
                it_log    TYPE ty_t_log OPTIONAL
      EXPORTING et_return TYPE ty_t_return.

    "! Realiza a inserção/atualização/deleção dos dados
    METHODS commit.

    "! Constrói mensagens retorno do aplicativo
    METHODS build_reported
      IMPORTING
        it_return   TYPE ty_t_return
      EXPORTING
        es_reported TYPE ty_reported.

    METHODS cancel_inventory
      IMPORTING it_head_key TYPE ty_t_head
      EXPORTING et_return   TYPE ty_t_return.

    METHODS prepare_release
      IMPORTING it_head_key TYPE ty_t_head.

    METHODS call_release
      EXPORTING et_return TYPE ty_t_return.

    "! Chama RFC e cria documento de inventário, contagem e grava log
    METHODS call_rfc_inventory_release
      IMPORTING is_head     TYPE z_s41_rfc_inventory_release=>zsmm_inventory_head
                it_item     TYPE z_s41_rfc_inventory_release=>zctgmm_inventory_item
                it_log      TYPE z_s41_rfc_inventory_release=>zctgmm_inventory_log OPTIONAL
      EXPORTING es_rfc_head TYPE z_s41_rfc_inventory_release=>zsmm_inventory_head
                et_rfc_item TYPE z_s41_rfc_inventory_release=>zctgmm_inventory_item
                et_rfc_log  TYPE z_s41_rfc_inventory_release=>zctgmm_inventory_log
                et_return   TYPE ty_t_return.


  PROTECTED SECTION.

  PRIVATE SECTION.

    CLASS-DATA go_instance TYPE REF TO zclmm_bd_inventory.

    DATA: gs_operation   TYPE ty_operation,

          gt_release_h   TYPE ty_t_head,

          gt_inventory_h TYPE SORTED TABLE OF ztmm_inventory_h
                         WITH UNIQUE KEY documentid,
          gt_inventory_i TYPE SORTED TABLE OF ztmm_inventory_i
                         WITH UNIQUE KEY documentid documentitemid,
          gt_inventory_l TYPE SORTED TABLE OF ztmm_inventory_l
                         WITH UNIQUE KEY documentid line.

    METHODS ajust_log
      IMPORTING
        iv_documentid TYPE z_s41_rfc_inventory_release=>zsmm_inventory_head-documentid
      CHANGING
        ct_rfc_log    TYPE z_s41_rfc_inventory_release=>zctgmm_inventory_log.

ENDCLASS.



CLASS zclmm_bd_inventory IMPLEMENTATION.

  METHOD get_instance.

* ---------------------------------------------------------------------------
* Recupera ou cria nova instância da classe
* ---------------------------------------------------------------------------
    IF ( go_instance IS INITIAL ).
      go_instance = NEW zclmm_bd_inventory( ).
    ENDIF.

    ro_instance = go_instance.

  ENDMETHOD.

  METHOD create_guid.

    FREE: rv_guid, et_return.

* ---------------------------------------------------------------------------
* Cria novo GUID
* ---------------------------------------------------------------------------
    TRY.
        rv_guid = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error.
        " Falha ao criar GUID.
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_INVENTORY' number = '001' ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_data.

    DATA: lt_head_key TYPE ty_t_head,
          lt_item_key TYPE ty_t_item,
          lt_log_key  TYPE ty_t_log.

    FREE: et_head, et_item, et_log, et_return.

* ---------------------------------------------------------------------------
* Prepara as tabelas de chave
* ---------------------------------------------------------------------------
    IF it_head_key IS SUPPLIED.
      lt_head_key[] = it_head_key[].
    ENDIF.

    IF it_item_key IS SUPPLIED.
      lt_head_key[] = VALUE #( BASE lt_head_key FOR ls_item_key_ IN it_item_key ( CORRESPONDING #( ls_item_key_ ) ) ).
      lt_item_key[] = it_item_key[].
    ENDIF.

    IF it_log_key IS SUPPLIED.
      lt_head_key[] = VALUE #( BASE lt_head_key FOR ls_log_key_ IN it_log_key ( CORRESPONDING #( ls_log_key_ ) ) ).
      lt_log_key[] = it_log_key[].
    ENDIF.

    SORT lt_head_key BY DocumentId.
    DELETE ADJACENT DUPLICATES FROM lt_head_key COMPARING DocumentId.

    SORT lt_item_key BY DocumentId DocumentItemId.
    DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING DocumentId DocumentItemId.

    SORT lt_log_key BY DocumentId Line.
    DELETE ADJACENT DUPLICATES FROM lt_log_key COMPARING DocumentId Line.

* ---------------------------------------------------------------------------
* Recupera dados de cabeçalho
* ---------------------------------------------------------------------------
    IF et_head IS REQUESTED AND lt_head_key[] IS NOT INITIAL.

      SELECT *
         FROM zi_mm_ce_inventory_head
         FOR ALL ENTRIES IN @lt_head_key
         WHERE DocumentId = @lt_head_key-DocumentId
         INTO CORRESPONDING FIELDS OF TABLE @et_head.

      IF sy-subrc EQ 0.
        SORT et_head BY DocumentId.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados de item
* ---------------------------------------------------------------------------
    IF et_item IS REQUESTED AND lt_item_key[] IS NOT INITIAL.

      SELECT *
         FROM zi_mm_ce_inventory_item
         FOR ALL ENTRIES IN @lt_item_key
         WHERE DocumentId     = @lt_item_key-DocumentId
           AND DocumentItemId = @lt_item_key-DocumentItemId
         INTO CORRESPONDING FIELDS OF TABLE @et_item.

      IF sy-subrc EQ 0.
        SORT et_item BY DocumentId DocumentItemId.
      ENDIF.

    ELSEIF et_item IS REQUESTED AND lt_head_key[] IS NOT INITIAL.

      SELECT *
         FROM zi_mm_ce_inventory_item
         FOR ALL ENTRIES IN @lt_head_key
         WHERE DocumentId     = @lt_head_key-DocumentId
         INTO CORRESPONDING FIELDS OF TABLE @et_item.

      IF sy-subrc EQ 0.
        SORT et_item BY DocumentId DocumentItemId.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados de log
* ---------------------------------------------------------------------------
    IF et_log IS REQUESTED AND lt_log_key[] IS NOT INITIAL.

      SELECT *
         FROM zi_mm_ce_inventory_log
         FOR ALL ENTRIES IN @lt_log_key
         WHERE DocumentId = @lt_log_key-DocumentId
           AND Line       = @lt_log_key-Line
         INTO CORRESPONDING FIELDS OF TABLE @et_log.

      IF sy-subrc EQ 0.
        SORT et_log BY DocumentId Line.
      ENDIF.

    ELSEIF et_log IS REQUESTED AND lt_head_key[] IS NOT INITIAL.

      SELECT *
         FROM zi_mm_ce_inventory_log
         FOR ALL ENTRIES IN @lt_head_key
         WHERE DocumentId     = @lt_head_key-DocumentId
         INTO CORRESPONDING FIELDS OF TABLE @et_log.

      IF sy-subrc EQ 0.
        SORT et_log BY DocumentId Line.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD create_head.

    DATA: lt_return    TYPE ty_t_return,
          lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    FREE: et_head.

* ---------------------------------------------------------------------------
* Recupera status e descrição
* ---------------------------------------------------------------------------
    SELECT SINGLE Status, StatusText
       FROM zi_mm_vh_inventory_status
       WHERE Status = @gc_status_head-created
       INTO @DATA(ls_status).

    IF sy-subrc NE 0.
      CLEAR ls_status.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera o último documento criado
* ---------------------------------------------------------------------------
    SELECT MAX( DocumentNo )
        FROM zi_mm_ce_inventory_head
        WHERE DocumentNo IS NOT INITIAL
        INTO @DATA(lv_DocumentNo).

    IF sy-subrc NE 0.
      lv_DocumentNo = 0.
    ENDIF.

* ---------------------------------------------------------------------------
* Cria nova linha de cabeçalho
* ---------------------------------------------------------------------------
    LOOP AT it_entities REFERENCE INTO DATA(ls_entity).

      DATA(ls_head) = ls_entity->*.
      ls_head-documentid           = COND #( WHEN ls_head-DocumentId IS NOT INITIAL
                                             THEN ls_head-DocumentId
                                             ELSE me->create_guid( IMPORTING et_return = lt_return ) ).
      ls_head-DocumentNo           = lv_DocumentNo = lv_DocumentNo + 1.
      ls_head-statusid             = ls_status-status.
      ls_head-statustext           = ls_status-statustext.
      ls_head-createdby            = sy-uname.
      ls_head-createdat            = lv_timestamp.
      ls_head-locallastchangedat   = lv_timestamp.

      et_head = VALUE #( BASE et_head ( CORRESPONDING #( ls_head ) ) ).

      INSERT LINES OF lt_return INTO TABLE et_return.

    ENDLOOP.

    SORT et_head BY DocumentId.

  ENDMETHOD.

  METHOD update_head.

    DATA: lt_fieldname TYPE ty_t_fieldname,
          lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    FREE: et_head.

* ---------------------------------------------------------------------------
* Recupera dados de cabeçalho (criada)
* ---------------------------------------------------------------------------
    me->get_data( EXPORTING it_head_key = CORRESPONDING #( it_entities )
                  IMPORTING et_head     = et_head
                            et_return   = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Atualiza linha de cabeçalho
* ---------------------------------------------------------------------------
    LOOP AT it_entities REFERENCE INTO DATA(ls_entity).

      " Recupera a linha cabeçalho (criada)
      READ TABLE et_head REFERENCE INTO DATA(ls_head) WITH KEY DocumentId = ls_entity->DocumentId
                                                               BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      lt_fieldname = VALUE #( ( 'DocumentNo' )
                              ( 'CountId' )
                              ( 'CountDate' )
                              ( 'StatusId' )
                              ( 'StatusText' )
                              ( 'Plant' )
                              ( 'PlantName' )
                              ( 'Description' ) ) ##NO_TEXT.

      me->update_field( EXPORTING it_fieldname = lt_fieldname
                                  is_control   = ls_entity->%control
                                  is_new_data  = ls_entity->*
                        CHANGING  cs_data      = ls_head->* ).

      ls_head->LastChangedBy        = sy-uname.
      ls_head->LastChangedAt        = lv_timestamp.
      ls_head->LocalLastChangedAt   = lv_timestamp.

    ENDLOOP.

  ENDMETHOD.

  METHOD create_item.

    DATA: lt_return    TYPE ty_t_return,
          lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    FREE: et_item.

* ---------------------------------------------------------------------------
* Recupera status e descrição
* ---------------------------------------------------------------------------
    SELECT SINGLE Status, StatusText
       FROM zi_mm_vh_counting_status
       WHERE Status = @gc_status_item-pending
       INTO @DATA(ls_status).

    IF sy-subrc NE 0.
      CLEAR ls_status.
    ENDIF.

* ---------------------------------------------------------------------------
* Cria nova linha de item
* ---------------------------------------------------------------------------
    LOOP AT it_entities REFERENCE INTO DATA(ls_entity).

      LOOP AT ls_entity->%target REFERENCE INTO DATA(ls_target).

        DATA(ls_item) = ls_target->*.

* ---------------------------------------------------------------------------
* Cria registro
* ---------------------------------------------------------------------------
        ls_item-documentid           = ls_entity->DocumentId.
        ls_item-DocumentItemId       = COND #( WHEN ls_target->DocumentItemId IS NOT INITIAL
                                               THEN ls_target->DocumentItemId
                                               ELSE me->create_guid( IMPORTING et_return = lt_return ) ).
        ls_item-statusid             = ls_status-status.
        ls_item-statustext           = ls_status-statustext.
        ls_item-createdby            = sy-uname.
        ls_item-createdat            = lv_timestamp.
        ls_item-locallastchangedat   = lv_timestamp.

        et_item = VALUE #( BASE et_item ( CORRESPONDING #( ls_item ) ) ).

        INSERT LINES OF lt_return INTO TABLE et_return.

      ENDLOOP.

    ENDLOOP.

    SORT et_item BY DocumentId DocumentItemId.

  ENDMETHOD.


  METHOD update_item.

    DATA: lt_fieldname TYPE ty_t_fieldname,
          lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    FREE: et_item.

* ---------------------------------------------------------------------------
* Recupera dados de item (criada)
* ---------------------------------------------------------------------------
    me->get_data( EXPORTING it_item_key = CORRESPONDING #( it_entities )
                  IMPORTING et_head     = et_head
                            et_item     = et_item
                            et_return   = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Atualiza linha de item
* ---------------------------------------------------------------------------
    LOOP AT it_entities REFERENCE INTO DATA(ls_entity).

      " Recupera a linha de cabeçalho
      READ TABLE et_head REFERENCE INTO DATA(ls_head) WITH KEY DocumentId     = ls_entity->DocumentId
                                                               BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Recupera a linha item
      READ TABLE et_item REFERENCE INTO DATA(ls_item) WITH KEY DocumentId     = ls_entity->DocumentId
                                                               DocumentItemId = ls_entity->DocumentItemId
                                                               BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Atualiza linha de cabeçalho
      lt_fieldname = VALUE #( ( 'Plant' )
                              ( 'PlantName' ) ) ##NO_TEXT.

      me->update_field( EXPORTING it_fieldname = lt_fieldname
                                  is_control   = ls_entity->%control
                                  is_new_data  = ls_entity->*
                        CHANGING  cs_data      = ls_head->* ).

      ls_head->LastChangedBy        = sy-uname.
      ls_head->LastChangedAt        = lv_timestamp.
      ls_head->LocalLastChangedAt   = lv_timestamp.

      " Atualiza linha de item
      lt_fieldname = VALUE #( ( 'StatusId' )
                              ( 'StatusText' )
                              ( 'Material' )
                              ( 'MaterialName' )
                              ( 'Plant' )
                              ( 'PlantName' )
                              ( 'StorageLocation' )
                              ( 'StorageLocationName' )
                              ( 'Batch' )
                              ( 'QuantityStock' )
                              ( 'QuantityCount' )
                              ( 'QuantityCurrent' )
                              ( 'Balance' )
                              ( 'BalanceCurrent' )
                              ( 'Unit' )
                              ( 'PriceStock' )
                              ( 'PriceCount' )
                              ( 'PriceDiff' )
                              ( 'Currency' )
                              ( 'Weight' )
                              ( 'WeightUnit' )
                              ( 'ProductHierarchy' )
                              ( 'Accuracy' )
                              ( 'MaterialDocumentYear' )
                              ( 'MaterialDocument' )
                              ( 'PostingDate' )
                              ( 'BR_NotaFiscal' )
                              ( 'AccountingDocument' )
                              ( 'AccountingDocumentYear' )
                              ( 'InvoiceReference' )
                              ( 'DocumentDate' )
                              ( 'BR_NFeNumber' )
                              ( 'BR_NFIsCanceled' )
                              ( 'BR_NFeDocumentStatus' )
                              ( 'BR_NFeDocumentStatusText' )
                              ( 'CompanyCode' )
                              ( 'CompanyCodeName' )
                              ( 'PhysicalInventoryDocument' )
                              ( 'FiscalYear' )
                              ( 'ExternalReference' )
                              ( 'ProfitCenter' ) ) ##NO_TEXT.

      me->update_field( EXPORTING it_fieldname = lt_fieldname
                                  is_control   = ls_entity->%control
                                  is_new_data  = ls_entity->*
                        CHANGING  cs_data      = ls_item->* ).

      ls_item->LastChangedBy        = sy-uname.
      ls_item->LastChangedAt        = lv_timestamp.
      ls_item->LocalLastChangedAt   = lv_timestamp.

    ENDLOOP.

  ENDMETHOD.

  METHOD update_field.

    DATA: lt_fieldname TYPE ty_t_fieldname.

    IF iv_fieldname IS NOT INITIAL.
      INSERT iv_fieldname INTO TABLE lt_fieldname.
    ENDIF.
    IF it_fieldname IS NOT INITIAL.
      INSERT LINES OF it_fieldname INTO TABLE lt_fieldname.
    ENDIF.

    LOOP AT lt_fieldname INTO DATA(lv_fieldname).

      lv_fieldname = to_upper( lv_fieldname ).

      " Recupera gerenciador de controle dos campos
      ASSIGN COMPONENT lv_fieldname OF STRUCTURE is_control TO FIELD-SYMBOL(<fs_control>).

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Verifica se o campo foi atualizado
      IF <fs_control> NE if_abap_behv=>mk-on.
        CONTINUE.
      ENDIF.

      " Recupera novo valor
      ASSIGN COMPONENT lv_fieldname OF STRUCTURE is_new_data TO FIELD-SYMBOL(<fs_new_field>).

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Atualiza campos com novo valor
      ASSIGN COMPONENT lv_fieldname OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_field>).

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      <fs_field> = <fs_new_field>.

    ENDLOOP.

  ENDMETHOD.

  METHOD prepare_commit.

* ---------------------------------------------------------------------------
* Atualiza operação
* ---------------------------------------------------------------------------
    gs_operation = VALUE #( insert = iv_insert
                            update = iv_update
                            delete = iv_delete ).

* ---------------------------------------------------------------------------
*
* ---------------------------------------------------------------------------
    gt_inventory_h = CORRESPONDING #( it_head ).
    gt_inventory_i = CORRESPONDING #( it_item ).
    gt_inventory_l = CORRESPONDING #( it_log ).

  ENDMETHOD.


  METHOD commit.

    CASE abap_true.

* ---------------------------------------------------------------------------
* Insere os novos dados
* ---------------------------------------------------------------------------
      WHEN gs_operation-insert.

        IF gt_inventory_h[] IS NOT INITIAL.
          MODIFY ztmm_inventory_h FROM TABLE @gt_inventory_h.
        ENDIF.

        IF gt_inventory_i[] IS NOT INITIAL.
          MODIFY ztmm_inventory_i FROM TABLE @gt_inventory_i.
        ENDIF.

        IF gt_inventory_l[] IS NOT INITIAL.
          MODIFY ztmm_inventory_l FROM TABLE @gt_inventory_l.
        ENDIF.

      WHEN gs_operation-update.

        IF gt_inventory_h[] IS NOT INITIAL.
          MODIFY ztmm_inventory_h FROM TABLE @gt_inventory_h.
        ENDIF.

        IF gt_inventory_i[] IS NOT INITIAL.
          MODIFY ztmm_inventory_i FROM TABLE @gt_inventory_i.
        ENDIF.

        IF gt_inventory_l[] IS NOT INITIAL.
          MODIFY ztmm_inventory_l FROM TABLE @gt_inventory_l.
        ENDIF.

      WHEN gs_operation-delete.

        IF gt_inventory_h[] IS NOT INITIAL.
          DELETE ztmm_inventory_h FROM TABLE @gt_inventory_h.
        ENDIF.

        IF gt_inventory_i[] IS NOT INITIAL.
          DELETE ztmm_inventory_i FROM TABLE @gt_inventory_i.
        ENDIF.

        IF gt_inventory_l[] IS NOT INITIAL.
          DELETE ztmm_inventory_l FROM TABLE @gt_inventory_l.
        ENDIF.

    ENDCASE.

* ---------------------------------------------------------------------------
* Limpa os dados em memória
* ---------------------------------------------------------------------------
    FREE: gs_operation,
          gt_inventory_h,
          gt_inventory_i,
          gt_inventory_l,
          gt_release_h.

  ENDMETHOD.


  METHOD build_reported.

    DATA: lo_dataref TYPE REF TO data,
          ls_cockpit TYPE zc_mm_ce_inventory_head.

    FIELD-SYMBOLS: <fs_cds>  TYPE any.

    FREE: es_reported.

    LOOP AT it_return INTO DATA(ls_return).

* ---------------------------------------------------------------------------
* Determina tipo de estrutura CDS
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-head.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-_head.
        WHEN gc_cds-item.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-_item.
        WHEN gc_cds-log.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-_log.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-_head.
      ENDCASE.

      ASSIGN lo_dataref->* TO <fs_cds>.

* ---------------------------------------------------------------------------
* Converte mensagem
* ---------------------------------------------------------------------------
      ASSIGN COMPONENT '%msg' OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_msg>).

      IF sy-subrc EQ 0.
        TRY.
            <fs_msg>  = me->new_message( id       = ls_return-id
                                         number   = ls_return-number
                                         v1       = ls_return-message_v1
                                         v2       = ls_return-message_v2
                                         v3       = ls_return-message_v3
                                         v4       = ls_return-message_v4
                                         severity = CONV #( ls_return-type ) ).
          CATCH cx_root.
        ENDTRY.
      ENDIF.

* ---------------------------------------------------------------------------
* Marca o campo com erro
* ---------------------------------------------------------------------------
      IF ls_return-field IS NOT INITIAL.
        ASSIGN COMPONENT |%element-{ ls_return-field }| OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_field>).

        IF sy-subrc EQ 0.
          TRY.
              <fs_field> = if_abap_behv=>mk-on.
            CATCH cx_root.
          ENDTRY.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Adiciona o erro na CDS correspondente
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-head.
          es_reported-_head[] = VALUE #( BASE es_reported-_head[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-item.
          es_reported-_item[] = VALUE #( BASE es_reported-_item[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-log.
          es_reported-_log[]  = VALUE #( BASE es_reported-_log[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-_head[] = VALUE #( BASE es_reported-_head[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_release.

    gs_operation-release = abap_true.
    gt_release_h = CORRESPONDING #( it_head_key ).

  ENDMETHOD.


  METHOD call_release.

    CHECK gs_operation-release EQ abap_true.

* ---------------------------------------------------------------------
* Busca dados de cabeçalho e item
* ---------------------------------------------------------------------
    me->get_data( EXPORTING it_head_key = CORRESPONDING #( gt_release_h )
                  IMPORTING et_head     = DATA(lt_head)
                            et_item     = DATA(lt_item)
                            et_log      = DATA(lt_log)
                            et_return   = et_return ).

    CHECK et_return IS INITIAL.

    TRY.
        DATA(ls_head) = lt_head[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------
* Cria documento de inventário, contagem e log via RFC
* ---------------------------------------------------------------------
*    CALL FUNCTION 'ZFMMM_INVENTORY'
*      STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
*      EXPORTING
*        is_head     = CORRESPONDING #( ls_head )
*        it_item     = CORRESPONDING #( lt_item )
*        it_log      = CORRESPONDING #( lt_log )
*      TABLES
*        es_rfc_head = data(ls_rfc_head)
*        et_rfc_item = data(lt_rfc_item)
*        et_rfc_log  = data(lt_rfc_log).
*
*    WAIT FOR ASYNCHRONOUS TASKS UNTIL me->gt_return IS NOT INITIAL.


    me->call_rfc_inventory_release( EXPORTING is_head     = CORRESPONDING #( ls_head )
                                              it_item     = CORRESPONDING #( lt_item )
                                              it_log      = CORRESPONDING #( lt_log )
                                    IMPORTING es_rfc_head = DATA(ls_rfc_head)
                                              et_rfc_item = DATA(lt_rfc_item)
                                              et_rfc_log  = DATA(lt_rfc_log)
                                              et_return   = et_return ).
    CHECK et_return IS INITIAL.

    me->prepare_commit( EXPORTING iv_update = abap_true
                                  it_head   = VALUE #( ( CORRESPONDING #( ls_rfc_head ) ) )
                                  it_item   = CORRESPONDING #( lt_rfc_item )
                                  it_log    = CORRESPONDING #( lt_rfc_log )
                        IMPORTING et_return = et_return ).

  ENDMETHOD.




  METHOD call_rfc_inventory_release.

    DATA: lo_dest  TYPE REF TO if_rfc_dest,
          lo_myobj TYPE REF TO z_s41_rfc_inventory_release,
          lv_text  TYPE bapiret2-message.

    FREE: es_rfc_head, et_rfc_item, et_rfc_log, et_return.

    CHECK is_head IS NOT INITIAL.
    CHECK it_item IS NOT INITIAL.

* ----------------------------------------------------------------------
* Chama RFC
* ----------------------------------------------------------------------
    TRY.
        lo_dest = cl_rfc_destination_provider=>create_by_cloud_destination( i_name = 'S41_RFC_120' ).

        CREATE OBJECT lo_myobj
          EXPORTING
            destination = lo_dest.

        " Execução da BAPI via RFC
        lo_myobj->zfmmm_inventory_release( EXPORTING is_head = is_head
                                                     it_item = it_item
                                                     it_log  = it_log
                                           IMPORTING es_head = es_rfc_head
                                                     et_item = et_rfc_item
                                                     et_log  = et_rfc_log ).

* ----------------------------------------------------------------------
* Ajusta contagem do campo LINE da tabela de LOG
* ----------------------------------------------------------------------
        me->ajust_log( EXPORTING iv_documentid = is_head-documentid
                       CHANGING  ct_rfc_log    = et_rfc_log ).

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

  ENDMETHOD.


  METHOD cancel_inventory.

* ---------------------------------------------------------------------------
* Recupera dados de cabeçalho
* ---------------------------------------------------------------------------
    me->get_data( EXPORTING it_head_key = it_head_key
                  IMPORTING et_head     = DATA(lt_head)
                            et_return   = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Recupera status e descrição
* ---------------------------------------------------------------------------
    SELECT SINGLE Status, StatusText
       FROM zi_mm_vh_inventory_status
       WHERE Status = @gc_status_head-canceled
       INTO @DATA(ls_status).

    IF sy-subrc NE 0.
      CLEAR ls_status.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza novo status
* ---------------------------------------------------------------------------
    LOOP AT lt_head REFERENCE INTO DATA(ls_head).
      ls_head->StatusId   = ls_status-Status.
      ls_head->StatusText = ls_status-StatusText.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Prepara os dados para serem inseridos posteriormente no método COMMIT
* ---------------------------------------------------------------------------
    me->prepare_commit( EXPORTING iv_update = abap_true
                                  it_head   = lt_head
                        IMPORTING et_return = et_return ).

  ENDMETHOD.

  METHOD ajust_log.
* ---------------------------------------------------------------------------
* Recupera última mensagem criada
* ---------------------------------------------------------------------------
    SELECT MAX( line )
        FROM ztmm_inventory_l
        WHERE documentid = @iv_documentid
        INTO @DATA(lv_seqnr).

    IF sy-subrc NE 0.
      lv_seqnr = 1.
    ENDIF.
* ---------------------------------------------------------------------------
* Prepara mensagens
* ---------------------------------------------------------------------------
    LOOP AT ct_rfc_log ASSIGNING FIELD-SYMBOL(<fs_log>).
      <fs_log>-line = sy-tabix + lv_seqnr.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
