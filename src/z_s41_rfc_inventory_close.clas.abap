CLASS z_s41_rfc_inventory_close DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aco_proxy .

    TYPES:
      BEGIN OF zsmm_inventory_head           ,
        documentid  TYPE x LENGTH 000016,
        documentno  TYPE c LENGTH 000010,
        countid     TYPE c LENGTH 000040,
        countdate   TYPE d,
        statusid    TYPE n LENGTH 000002,
        statustext  TYPE c LENGTH 000040,
        statuscrit  TYPE int1,
        plant       TYPE c LENGTH 000004,
        plantname   TYPE c LENGTH 000030,
        description TYPE c LENGTH 000080,
      END OF zsmm_inventory_head            ##TYPSHADOW .
    TYPES:
      BEGIN OF zsmm_inventory_item           ,
        documentid                TYPE x LENGTH 000016,
        documentitemid            TYPE x LENGTH 000016,
        statusid                  TYPE n LENGTH 000002,
        statustext                TYPE c LENGTH 000040,
        statuscrit                TYPE int1,
        material                  TYPE c LENGTH 000040,
        materialname              TYPE c LENGTH 000040,
        storagelocation           TYPE c LENGTH 000004,
        storagelocationname       TYPE c LENGTH 000016,
        batch                     TYPE c LENGTH 000010,
        quantitystock             TYPE p LENGTH 13  DECIMALS 000003,
        quantitycount             TYPE p LENGTH 13  DECIMALS 000003,
        quantitycurrent           TYPE p LENGTH 13  DECIMALS 000003,
        balance                   TYPE p LENGTH 13  DECIMALS 000003,
        balancecurrent            TYPE p LENGTH 13  DECIMALS 000003,
        unit                      TYPE c LENGTH 000003,
        pricestock                TYPE p LENGTH 11  DECIMALS 000002,
        pricecount                TYPE p LENGTH 11  DECIMALS 000002,
        pricediff                 TYPE p LENGTH 11  DECIMALS 000002,
        currency                  TYPE c LENGTH 000005,
        weight                    TYPE p LENGTH 13  DECIMALS 000003,
        weightunit                TYPE c LENGTH 000003,
        producthierarchy          TYPE c LENGTH 000018,
        accuracy                  TYPE p LENGTH 13  DECIMALS 000002,
        materialdocumentyear      TYPE n LENGTH 000004,
        materialdocument          TYPE c LENGTH 000010,
        postingdate               TYPE d,
        br_notafiscal             TYPE n LENGTH 000010,
        supplierinvoice           TYPE c LENGTH 000010,
        supplierinvoiceyear       TYPE n LENGTH 000004,
        invoicereference          TYPE c LENGTH 000010,
        documentdate              TYPE d,
        br_nfenumber              TYPE c LENGTH 000009,
        br_nfiscanceled           TYPE c LENGTH 000001,
        br_nfedocumentstatus      TYPE c LENGTH 000001,
        br_nfedocumentstatustext  TYPE c LENGTH 000040,
        companycode               TYPE c LENGTH 000004,
        companycodename           TYPE c LENGTH 000040,
        physicalinventorydocument TYPE c LENGTH 000010,
        fiscalyear                TYPE n LENGTH 000004,
        externalreference         TYPE c LENGTH 000040,
        profitcenter              TYPE c LENGTH 000010,
      END OF zsmm_inventory_item            ##TYPSHADOW .
    TYPES:
      zctgmm_inventory_item          TYPE STANDARD TABLE OF zsmm_inventory_item            WITH DEFAULT KEY ##TYPSHADOW .
    TYPES:
      BEGIN OF zsmm_inventory_log            ,
        documentid TYPE x LENGTH 000016,
        line       TYPE n LENGTH 000010,
        msgid      TYPE c LENGTH 000020,
        msgty      TYPE c LENGTH 000001,
        msgtytext  TYPE c LENGTH 000040,
        msgtycrit  TYPE int1,
        msgno      TYPE n LENGTH 000003,
        msgv1      TYPE c LENGTH 000050,
        msgv2      TYPE c LENGTH 000050,
        msgv3      TYPE c LENGTH 000050,
        msgv4      TYPE c LENGTH 000050,
        message    TYPE c LENGTH 000220,
      END OF zsmm_inventory_log             ##TYPSHADOW .
    TYPES:
      zctgmm_inventory_log           TYPE STANDARD TABLE OF zsmm_inventory_log             WITH DEFAULT KEY ##TYPSHADOW .

    METHODS constructor
      IMPORTING
        !destination TYPE REF TO if_rfc_dest
      RAISING
        cx_rfc_dest_provider_error .
    METHODS zfmmm_inventory_close
      IMPORTING
        !is_head TYPE zsmm_inventory_head
        !it_item TYPE zctgmm_inventory_item
        !it_log  TYPE zctgmm_inventory_log OPTIONAL
      EXPORTING
        !es_head TYPE zsmm_inventory_head
        !et_item TYPE zctgmm_inventory_item
        !et_log  TYPE zctgmm_inventory_log
      RAISING
        cx_aco_application_exception
        cx_aco_communication_failure
        cx_aco_system_failure .
  PROTECTED SECTION.

    DATA destination TYPE rfcdest .
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_S41_RFC_INVENTORY_CLOSE IMPLEMENTATION.


  METHOD constructor.
    me->destination = destination->get_destination_name( ).
  ENDMETHOD.


  METHOD zfmmm_inventory_close.
    DATA: _rfc_message_ TYPE aco_proxy_msg_type.
    CALL FUNCTION 'ZFMMM_INVENTORY_CLOSE' DESTINATION me->destination
      EXPORTING
        is_head               = is_head
        it_item               = it_item
        it_log                = it_log
      IMPORTING
        es_head               = es_head
        et_item               = et_item
        et_log                = et_log
      EXCEPTIONS
        communication_failure = 1 MESSAGE _rfc_message_
        system_failure        = 2 MESSAGE _rfc_message_
        OTHERS                = 3.
    IF sy-subrc NE 0.
      DATA __sysubrc TYPE sy-subrc.
      DATA __textid TYPE aco_proxy_textid_type.
      __sysubrc = sy-subrc.
      __textid-msgid = sy-msgid.
      __textid-msgno = sy-msgno.
      __textid-attr1 = sy-msgv1.
      __textid-attr2 = sy-msgv2.
      __textid-attr3 = sy-msgv3.
      __textid-attr4 = sy-msgv4.
      CASE __sysubrc.
        WHEN 1 .
          RAISE EXCEPTION TYPE cx_aco_communication_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 2 .
          RAISE EXCEPTION TYPE cx_aco_system_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 3 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'OTHERS'
              textid       = __textid.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
