CLASS zcxmm_inventory_exception DEFINITION
  PUBLIC
  INHERITING FROM cx_rap_query_provider
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: ty_t_return TYPE STANDARD TABLE OF bapiret2.

    METHODS constructor
      IMPORTING
        !iv_textid   LIKE if_t100_message=>t100key OPTIONAL
        !iv_previous LIKE previous OPTIONAL
        !it_return   TYPE ty_t_return.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCXMM_INVENTORY_EXCEPTION IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    CALL METHOD super->constructor
      EXPORTING
        previous = iv_previous.

    CLEAR me->textid.

* ---------------------------------------------------------------------------
* Recupera a primeira mensagem de erro
* ---------------------------------------------------------------------------
    TRY.
        DATA(ls_return) = it_return[ type = 'E' ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Caso não exista, recupera a primeira mensagem
* ---------------------------------------------------------------------------
    TRY.
        IF ls_return IS INITIAL.
          ls_return = it_return[ 1 ].
        ENDIF.
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Prepara a mensagem
* ---------------------------------------------------------------------------
    if_t100_message~t100key = VALUE #( msgid = ls_return-id
                                       msgno = ls_return-number
                                       attr1 = ls_return-message_v1
                                       attr2 = ls_return-message_v2
                                       attr3 = ls_return-message_v3
                                       attr4 = ls_return-message_v4 ).

  ENDMETHOD.
ENDCLASS.
