"! <p class="shorttext synchronized" lang="en">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>cds_zui_cds_inventario</em>
CLASS zclmm_s41_cds_inventario DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__FitToPage</p>
      BEGIN OF tys_sap_fit_to_page,
        "! ErrorRecoveryBehavior
        error_recovery_behavior TYPE c LENGTH 8,
        "! IsEnabled
        is_enabled              TYPE abap_bool,
        "! MinimumFontSize
        minimum_font_size       TYPE int4,
      END OF tys_sap_fit_to_page,
      "! <p class="shorttext synchronized" lang="en">List of SAP__FitToPage</p>
      tyt_sap_fit_to_page TYPE STANDARD TABLE OF tys_sap_fit_to_page WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__CoverPage</p>
      BEGIN OF tys_sap_cover_page,
        "! <em>Key property</em> Title
        title TYPE c LENGTH 256,
        "! <em>Key property</em> Id
        id    TYPE sysuuid_x16,
        "! <em>Key property</em> Name
        name  TYPE c LENGTH 256,
        "! Value
        value TYPE c LENGTH 256,
      END OF tys_sap_cover_page,
      "! <p class="shorttext synchronized" lang="en">List of SAP__CoverPage</p>
      tyt_sap_cover_page TYPE STANDARD TABLE OF tys_sap_cover_page WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__Currency</p>
      BEGIN OF tys_sap_currency,
        "! <em>Key property</em> CurrencyCode
        currency_code  TYPE c LENGTH 5,
        "! ISOCode
        isocode        TYPE c LENGTH 3,
        "! Text
        text           TYPE c LENGTH 15,
        "! DecimalPlaces
        decimal_places TYPE int1,
      END OF tys_sap_currency,
      "! <p class="shorttext synchronized" lang="en">List of SAP__Currency</p>
      tyt_sap_currency TYPE STANDARD TABLE OF tys_sap_currency WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__DocumentDescription</p>
      BEGIN OF tys_sap_document_description,
        "! <em>Key property</em> Id
        id         TYPE sysuuid_x16,
        "! CreatedBy
        created_by TYPE c LENGTH 12,
        "! CreatedAt
        created_at TYPE timestamp,
        "! FileName
        file_name  TYPE c LENGTH 256,
        "! Title
        title      TYPE c LENGTH 256,
      END OF tys_sap_document_description,
      "! <p class="shorttext synchronized" lang="en">List of SAP__DocumentDescription</p>
      tyt_sap_document_description TYPE STANDARD TABLE OF tys_sap_document_description WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__Format</p>
      BEGIN OF tys_sap_format,
        "! FitToPage
        fit_to_page TYPE tys_sap_fit_to_page,
        "! <em>Key property</em> Id
        id          TYPE sysuuid_x16,
        "! FontSize
        font_size   TYPE int4,
        "! Orientation
        orientation TYPE c LENGTH 10,
        "! PaperSize
        paper_size  TYPE c LENGTH 10,
        "! BorderSize
        border_size TYPE int4,
        "! MarginSize
        margin_size TYPE int4,
        "! FontName
        font_name   TYPE c LENGTH 255,
      END OF tys_sap_format,
      "! <p class="shorttext synchronized" lang="en">List of SAP__Format</p>
      tyt_sap_format TYPE STANDARD TABLE OF tys_sap_format WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__PDFStandard</p>
      BEGIN OF tys_sap_pdfstandard,
        "! <em>Key property</em> Id
        id                      TYPE sysuuid_x16,
        "! UsePDFAConformance
        use_pdfaconformance     TYPE abap_bool,
        "! DoEnableAccessibility
        do_enable_accessibility TYPE abap_bool,
      END OF tys_sap_pdfstandard,
      "! <p class="shorttext synchronized" lang="en">List of SAP__PDFStandard</p>
      tyt_sap_pdfstandard TYPE STANDARD TABLE OF tys_sap_pdfstandard WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__Signature</p>
      BEGIN OF tys_sap_signature,
        "! <em>Key property</em> Id
        id      TYPE sysuuid_x16,
        "! DoSign
        do_sign TYPE abap_bool,
        "! Reason
        reason  TYPE c LENGTH 256,
      END OF tys_sap_signature,
      "! <p class="shorttext synchronized" lang="en">List of SAP__Signature</p>
      tyt_sap_signature TYPE STANDARD TABLE OF tys_sap_signature WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__TableColumns</p>
      BEGIN OF tys_sap_table_columns,
        "! <em>Key property</em> Id
        id                   TYPE sysuuid_x16,
        "! <em>Key property</em> Name
        name                 TYPE c LENGTH 256,
        "! <em>Key property</em> Header
        header               TYPE c LENGTH 256,
        "! HorizontalAlignment
        horizontal_alignment TYPE c LENGTH 10,
      END OF tys_sap_table_columns,
      "! <p class="shorttext synchronized" lang="en">List of SAP__TableColumns</p>
      tyt_sap_table_columns TYPE STANDARD TABLE OF tys_sap_table_columns WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__UnitOfMeasure</p>
      BEGIN OF tys_sap_unit_of_measure,
        "! <em>Key property</em> UnitCode
        unit_code      TYPE c LENGTH 3,
        "! ISOCode
        isocode        TYPE c LENGTH 3,
        "! ExternalCode
        external_code  TYPE c LENGTH 3,
        "! Text
        text           TYPE c LENGTH 30,
        "! DecimalPlaces
        decimal_places TYPE int2,
      END OF tys_sap_unit_of_measure,
      "! <p class="shorttext synchronized" lang="en">List of SAP__UnitOfMeasure</p>
      tyt_sap_unit_of_measure TYPE STANDARD TABLE OF tys_sap_unit_of_measure WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">SAP__ValueHelp</p>
      BEGIN OF tys_sap_value_help,
        "! <em>Key property</em> VALUEHELP
        valuehelp   TYPE string,
        "! FIELD_VALUE
        field_value TYPE c LENGTH 10,
        "! DESCRIPTION
        description TYPE string,
      END OF tys_sap_value_help,
      "! <p class="shorttext synchronized" lang="en">List of SAP__ValueHelp</p>
      tyt_sap_value_help TYPE STANDARD TABLE OF tys_sap_value_help WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">ZI_MM_AccountingDocumentType</p>
      BEGIN OF tys_zi_mm_accounting_documen_2,
        "! <em>Key property</em> FiscalYear
        fiscal_year                TYPE c LENGTH 4,
        "! <em>Key property</em> PhysicalInventoryDocument
        physical_inventory_documen TYPE c LENGTH 10,
        "! MaterialDocument
        material_document          TYPE c LENGTH 10,
        "! PostingDate
        posting_date               TYPE datn,
        "! Material
        material                   TYPE c LENGTH 40,
        "! BR_NFSourceDocumentNumber
        br_nfsource_document_numbe TYPE c LENGTH 35,
        "! BR_NotaFiscal
        br_nota_fiscal             TYPE c LENGTH 10,
        "! BR_NFeNumber
        br_nfe_number              TYPE c LENGTH 9,
        "! BR_NFIsCanceled
        br_nfis_canceled           TYPE abap_bool,
        "! BR_NFeDocumentStatus
        br_nfe_document_status     TYPE c LENGTH 1,
        "! BR_NFeDocumentStatusText
        br_nfe_document_status_tex TYPE c LENGTH 60,
        "! CompanyCode
        company_code               TYPE c LENGTH 4,
        "! CompanyCodeName
        company_code_name          TYPE c LENGTH 25,
        "! AccountingDocument
        accounting_document        TYPE c LENGTH 10,
        "! AccountingDocumentYear
        accounting_document_year   TYPE c LENGTH 4,
        "! ExternalReference
        external_reference         TYPE c LENGTH 10,
        "! DocumentDate
        document_date              TYPE datn,
      END OF tys_zi_mm_accounting_documen_2,
      "! <p class="shorttext synchronized" lang="en">List of ZI_MM_AccountingDocumentType</p>
      tyt_zi_mm_accounting_documen_2 TYPE STANDARD TABLE OF tys_zi_mm_accounting_documen_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">ZI_MM_VH_BATCHType</p>
      BEGIN OF tys_zi_mm_vh_batchtype,
        "! <em>Key property</em> Plant
        plant        TYPE c LENGTH 4,
        "! <em>Key property</em> Material
        material     TYPE c LENGTH 18,
        "! <em>Key property</em> Batch
        batch        TYPE c LENGTH 10,
        "! Materialname
        materialname TYPE c LENGTH 40,
        "! Plantname
        plantname    TYPE c LENGTH 30,
      END OF tys_zi_mm_vh_batchtype,
      "! <p class="shorttext synchronized" lang="en">List of ZI_MM_VH_BATCHType</p>
      tyt_zi_mm_vh_batchtype TYPE STANDARD TABLE OF tys_zi_mm_vh_batchtype WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">ZI_MM_VH_COMPANYType</p>
      BEGIN OF tys_zi_mm_vh_companytype,
        "! <em>Key property</em> Companycode
        companycode     TYPE c LENGTH 4,
        "! Companycodename
        companycodename TYPE c LENGTH 25,
      END OF tys_zi_mm_vh_companytype,
      "! <p class="shorttext synchronized" lang="en">List of ZI_MM_VH_COMPANYType</p>
      tyt_zi_mm_vh_companytype TYPE STANDARD TABLE OF tys_zi_mm_vh_companytype WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">ZI_MM_VH_MATERIALType</p>
      BEGIN OF tys_zi_mm_vh_materialtype,
        "! <em>Key property</em> Material
        material     TYPE c LENGTH 18,
        "! Materialname
        materialname TYPE c LENGTH 40,
      END OF tys_zi_mm_vh_materialtype,
      "! <p class="shorttext synchronized" lang="en">List of ZI_MM_VH_MATERIALType</p>
      tyt_zi_mm_vh_materialtype TYPE STANDARD TABLE OF tys_zi_mm_vh_materialtype WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">ZI_MM_VH_PLANTType</p>
      BEGIN OF tys_zi_mm_vh_planttype,
        "! <em>Key property</em> Plant
        plant     TYPE c LENGTH 4,
        "! Plantname
        plantname TYPE c LENGTH 30,
      END OF tys_zi_mm_vh_planttype,
      "! <p class="shorttext synchronized" lang="en">List of ZI_MM_VH_PLANTType</p>
      tyt_zi_mm_vh_planttype TYPE STANDARD TABLE OF tys_zi_mm_vh_planttype WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">ZI_MM_VH_PRODUCT_HIERARCHYType</p>
      BEGIN OF tys_zi_mm_vh_product_hierarc_2,
        "! <em>Key property</em> Producthierarchy
        producthierarchy     TYPE c LENGTH 18,
        "! Producthierarchytext
        producthierarchytext TYPE c LENGTH 40,
      END OF tys_zi_mm_vh_product_hierarc_2,
      "! <p class="shorttext synchronized" lang="en">List of ZI_MM_VH_PRODUCT_HIERARCHYType</p>
      tyt_zi_mm_vh_product_hierarc_2 TYPE STANDARD TABLE OF tys_zi_mm_vh_product_hierarc_2 WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">ZI_MM_VH_PROFIT_CENTERType</p>
      BEGIN OF tys_zi_mm_vh_profit_centertype,
        "! <em>Key property</em> Profitcenter
        profitcenter     TYPE c LENGTH 10,
        "! Profitcentername
        profitcentername TYPE c LENGTH 20,
      END OF tys_zi_mm_vh_profit_centertype,
      "! <p class="shorttext synchronized" lang="en">List of ZI_MM_VH_PROFIT_CENTERType</p>
      tyt_zi_mm_vh_profit_centertype TYPE STANDARD TABLE OF tys_zi_mm_vh_profit_centertype WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">ZI_MM_VH_STORAGE_LOCATIONType</p>
      BEGIN OF tys_zi_mm_vh_storage_locationt,
        "! <em>Key property</em> Plant
        plant               TYPE c LENGTH 4,
        "! <em>Key property</em> storagelocation
        storagelocation     TYPE c LENGTH 4,
        "! Storagelocationname
        storagelocationname TYPE c LENGTH 16,
        "! Plantname
        plantname           TYPE c LENGTH 30,
      END OF tys_zi_mm_vh_storage_locationt,
      "! <p class="shorttext synchronized" lang="en">List of ZI_MM_VH_STORAGE_LOCATIONType</p>
      tyt_zi_mm_vh_storage_locationt TYPE STANDARD TABLE OF tys_zi_mm_vh_storage_locationt WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! SAP__CoverPageSet
        "! <br/> Collection of type 'SAP__CoverPage'
        sap_cover_page_set         TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_COVER_PAGE_SET',
        "! SAP__Currencies
        "! <br/> Collection of type 'SAP__Currency'
        sap_currencies             TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_CURRENCIES',
        "! SAP__FormatSet
        "! <br/> Collection of type 'SAP__Format'
        sap_format_set             TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_FORMAT_SET',
        "! SAP__MyDocumentDescriptions
        "! <br/> Collection of type 'SAP__DocumentDescription'
        sap_my_document_descriptio TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_MY_DOCUMENT_DESCRIPTIO',
        "! SAP__PDFStandardSet
        "! <br/> Collection of type 'SAP__PDFStandard'
        sap_pdfstandard_set        TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_PDFSTANDARD_SET',
        "! SAP__SignatureSet
        "! <br/> Collection of type 'SAP__Signature'
        sap_signature_set          TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_SIGNATURE_SET',
        "! SAP__TableColumnsSet
        "! <br/> Collection of type 'SAP__TableColumns'
        sap_table_columns_set      TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_TABLE_COLUMNS_SET',
        "! SAP__UnitsOfMeasure
        "! <br/> Collection of type 'SAP__UnitOfMeasure'
        sap_units_of_measure       TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_UNITS_OF_MEASURE',
        "! SAP__ValueHelpSet
        "! <br/> Collection of type 'SAP__ValueHelp'
        sap_value_help_set         TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'SAP_VALUE_HELP_SET',
        "! ZI_MM_AccountingDocument
        "! <br/> Collection of type 'ZI_MM_AccountingDocumentType'
        zi_mm_accounting_document  TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZI_MM_ACCOUNTING_DOCUMENT',
        "! ZI_MM_VH_BATCH
        "! <br/> Collection of type 'ZI_MM_VH_BATCHType'
        zi_mm_vh_batch             TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZI_MM_VH_BATCH',
        "! ZI_MM_VH_COMPANY
        "! <br/> Collection of type 'ZI_MM_VH_COMPANYType'
        zi_mm_vh_company           TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZI_MM_VH_COMPANY',
        "! ZI_MM_VH_MATERIAL
        "! <br/> Collection of type 'ZI_MM_VH_MATERIALType'
        zi_mm_vh_material          TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZI_MM_VH_MATERIAL',
        "! ZI_MM_VH_PLANT
        "! <br/> Collection of type 'ZI_MM_VH_PLANTType'
        zi_mm_vh_plant             TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZI_MM_VH_PLANT',
        "! ZI_MM_VH_PRODUCT_HIERARCHY
        "! <br/> Collection of type 'ZI_MM_VH_PRODUCT_HIERARCHYType'
        zi_mm_vh_product_hierarchy TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZI_MM_VH_PRODUCT_HIERARCHY',
        "! ZI_MM_VH_PROFIT_CENTER
        "! <br/> Collection of type 'ZI_MM_VH_PROFIT_CENTERType'
        zi_mm_vh_profit_center     TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZI_MM_VH_PROFIT_CENTER',
        "! ZI_MM_VH_STORAGE_LOCATION
        "! <br/> Collection of type 'ZI_MM_VH_STORAGE_LOCATIONType'
        zi_mm_vh_storage_location  TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'ZI_MM_VH_STORAGE_LOCATION',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal names for complex types</p>
      BEGIN OF gcs_complex_type,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_complex_type.

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized" lang="en">Internal names for SAP__DocumentDescription</p>
        "! See also structure type {@link ..tys_sap_document_description}
        BEGIN OF sap_document_description,
          "! <p class="shorttext synchronized" lang="en">Navigation properties</p>
          BEGIN OF navigation,
            "! CoverPage
            cover_page    TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'COVER_PAGE',
            "! Format
            format        TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'FORMAT',
            "! PDFStandard
            pdfstandard   TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'PDFSTANDARD',
            "! Signature
            signature     TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'SIGNATURE',
            "! TableColumns
            table_columns TYPE /iwbep/if_v4_pm_types=>ty_internal_name VALUE 'TABLE_COLUMNS',
          END OF navigation,
        END OF sap_document_description,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized" lang="en">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized" lang="en">Define SAP__FitToPage</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_fit_to_page RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__CoverPage</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_cover_page RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__Currency</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_currency RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__DocumentDescription</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_document_description RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__Format</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_format RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__PDFStandard</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_pdfstandard RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__Signature</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_signature RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__TableColumns</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_table_columns RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__UnitOfMeasure</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_unit_of_measure RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define SAP__ValueHelp</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_sap_value_help RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define ZI_MM_AccountingDocumentType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_zi_mm_accounting_documen_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define ZI_MM_VH_BATCHType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_zi_mm_vh_batchtype RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define ZI_MM_VH_COMPANYType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_zi_mm_vh_companytype RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define ZI_MM_VH_MATERIALType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_zi_mm_vh_materialtype RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define ZI_MM_VH_PLANTType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_zi_mm_vh_planttype RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define ZI_MM_VH_PRODUCT_HIERARCHYType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_zi_mm_vh_product_hierarc_2 RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define ZI_MM_VH_PROFIT_CENTERType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_zi_mm_vh_profit_centertype RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized" lang="en">Define ZI_MM_VH_STORAGE_LOCATIONType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_zi_mm_vh_storage_locationt RAISING /iwbep/cx_gateway.

ENDCLASS.


CLASS zclmm_s41_cds_inventario IMPLEMENTATION.

  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'cds_zui_cds_inventario' ).

    def_sap_fit_to_page( ).
    def_sap_cover_page( ).
    def_sap_currency( ).
    def_sap_document_description( ).
    def_sap_format( ).
    def_sap_pdfstandard( ).
    def_sap_signature( ).
    def_sap_table_columns( ).
    def_sap_unit_of_measure( ).
    def_sap_value_help( ).
    def_zi_mm_accounting_documen_2( ).
    def_zi_mm_vh_batchtype( ).
    def_zi_mm_vh_companytype( ).
    def_zi_mm_vh_materialtype( ).
    def_zi_mm_vh_planttype( ).
    def_zi_mm_vh_product_hierarc_2( ).
    def_zi_mm_vh_profit_centertype( ).
    def_zi_mm_vh_storage_locationt( ).

  ENDMETHOD.


  METHOD def_sap_fit_to_page.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_complex_type        TYPE REF TO /iwbep/if_v4_pm_cplx_type,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_complex_type = mo_model->create_complex_type_by_struct(
                                    iv_complex_type_name      = 'SAP_FIT_TO_PAGE'
                                    is_structure              = VALUE tys_sap_fit_to_page( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_complex_type->set_edm_name( 'SAP__FitToPage' ) ##NO_TEXT.


    lo_primitive_property = lo_complex_type->get_primitive_property( 'ERROR_RECOVERY_BEHAVIOR' ).
    lo_primitive_property->set_edm_name( 'ErrorRecoveryBehavior' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_complex_type->get_primitive_property( 'IS_ENABLED' ).
    lo_primitive_property->set_edm_name( 'IsEnabled' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_complex_type->get_primitive_property( 'MINIMUM_FONT_SIZE' ).
    lo_primitive_property->set_edm_name( 'MinimumFontSize' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int32' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

  ENDMETHOD.


  METHOD def_sap_cover_page.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_COVER_PAGE'
                                    is_structure              = VALUE tys_sap_cover_page( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__CoverPage' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_COVER_PAGE_SET' ).
    lo_entity_set->set_edm_name( 'SAP__CoverPageSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'TITLE' ).
    lo_primitive_property->set_edm_name( 'Title' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 256 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ID' ).
    lo_primitive_property->set_edm_name( 'Id' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'NAME' ).
    lo_primitive_property->set_edm_name( 'Name' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 256 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VALUE' ).
    lo_primitive_property->set_edm_name( 'Value' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 256 ).
    lo_primitive_property->set_scale_floating( ).

  ENDMETHOD.


  METHOD def_sap_currency.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_CURRENCY'
                                    is_structure              = VALUE tys_sap_currency( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__Currency' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_CURRENCIES' ).
    lo_entity_set->set_edm_name( 'SAP__Currencies' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'CURRENCY_CODE' ).
    lo_primitive_property->set_edm_name( 'CurrencyCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ISOCODE' ).
    lo_primitive_property->set_edm_name( 'ISOCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TEXT' ).
    lo_primitive_property->set_edm_name( 'Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 15 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DECIMAL_PLACES' ).
    lo_primitive_property->set_edm_name( 'DecimalPlaces' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Byte' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

  ENDMETHOD.


  METHOD def_sap_document_description.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_DOCUMENT_DESCRIPTION'
                                    is_structure              = VALUE tys_sap_document_description( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__DocumentDescription' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_MY_DOCUMENT_DESCRIPTIO' ).
    lo_entity_set->set_edm_name( 'SAP__MyDocumentDescriptions' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'ID' ).
    lo_primitive_property->set_edm_name( 'Id' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATED_BY' ).
    lo_primitive_property->set_edm_name( 'CreatedBy' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CREATED_AT' ).
    lo_primitive_property->set_edm_name( 'CreatedAt' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type_v2( 'DateTime' ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FILE_NAME' ).
    lo_primitive_property->set_edm_name( 'FileName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 256 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TITLE' ).
    lo_primitive_property->set_edm_name( 'Title' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 256 ).
    lo_primitive_property->set_scale_floating( ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'COVER_PAGE' ).
    lo_navigation_property->set_edm_name( 'CoverPage' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'SAP_COVER_PAGE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'FORMAT' ).
    lo_navigation_property->set_edm_name( 'Format' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'SAP_FORMAT' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'PDFSTANDARD' ).
    lo_navigation_property->set_edm_name( 'PDFStandard' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'SAP_PDFSTANDARD' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'SIGNATURE' ).
    lo_navigation_property->set_edm_name( 'Signature' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'SAP_SIGNATURE' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_one ).

    lo_navigation_property = lo_entity_type->create_navigation_property( 'TABLE_COLUMNS' ).
    lo_navigation_property->set_edm_name( 'TableColumns' ) ##NO_TEXT.
    lo_navigation_property->set_target_entity_type_name( 'SAP_TABLE_COLUMNS' ).
    lo_navigation_property->set_target_multiplicity( /iwbep/if_v4_pm_types=>gcs_nav_multiplicity-to_many_optional ).

  ENDMETHOD.


  METHOD def_sap_format.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_FORMAT'
                                    is_structure              = VALUE tys_sap_format( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__Format' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_FORMAT_SET' ).
    lo_entity_set->set_edm_name( 'SAP__FormatSet' ) ##NO_TEXT.


    lo_complex_property = lo_entity_type->create_complex_property( 'FIT_TO_PAGE' ).
    lo_complex_property->set_edm_name( 'FitToPage' ) ##NO_TEXT.
    lo_complex_property->set_complex_type( 'SAP_FIT_TO_PAGE' ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ID' ).
    lo_primitive_property->set_edm_name( 'Id' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FONT_SIZE' ).
    lo_primitive_property->set_edm_name( 'FontSize' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int32' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ORIENTATION' ).
    lo_primitive_property->set_edm_name( 'Orientation' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PAPER_SIZE' ).
    lo_primitive_property->set_edm_name( 'PaperSize' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BORDER_SIZE' ).
    lo_primitive_property->set_edm_name( 'BorderSize' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int32' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MARGIN_SIZE' ).
    lo_primitive_property->set_edm_name( 'MarginSize' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int32' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FONT_NAME' ).
    lo_primitive_property->set_edm_name( 'FontName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 255 ).
    lo_primitive_property->set_scale_floating( ).

  ENDMETHOD.


  METHOD def_sap_pdfstandard.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_PDFSTANDARD'
                                    is_structure              = VALUE tys_sap_pdfstandard( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__PDFStandard' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_PDFSTANDARD_SET' ).
    lo_entity_set->set_edm_name( 'SAP__PDFStandardSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'ID' ).
    lo_primitive_property->set_edm_name( 'Id' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'USE_PDFACONFORMANCE' ).
    lo_primitive_property->set_edm_name( 'UsePDFAConformance' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DO_ENABLE_ACCESSIBILITY' ).
    lo_primitive_property->set_edm_name( 'DoEnableAccessibility' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

  ENDMETHOD.


  METHOD def_sap_signature.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_SIGNATURE'
                                    is_structure              = VALUE tys_sap_signature( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__Signature' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_SIGNATURE_SET' ).
    lo_entity_set->set_edm_name( 'SAP__SignatureSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'ID' ).
    lo_primitive_property->set_edm_name( 'Id' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DO_SIGN' ).
    lo_primitive_property->set_edm_name( 'DoSign' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'REASON' ).
    lo_primitive_property->set_edm_name( 'Reason' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 256 ).
    lo_primitive_property->set_scale_floating( ).

  ENDMETHOD.


  METHOD def_sap_table_columns.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_TABLE_COLUMNS'
                                    is_structure              = VALUE tys_sap_table_columns( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__TableColumns' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_TABLE_COLUMNS_SET' ).
    lo_entity_set->set_edm_name( 'SAP__TableColumnsSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'ID' ).
    lo_primitive_property->set_edm_name( 'Id' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'NAME' ).
    lo_primitive_property->set_edm_name( 'Name' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 256 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'HEADER' ).
    lo_primitive_property->set_edm_name( 'Header' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 256 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'HORIZONTAL_ALIGNMENT' ).
    lo_primitive_property->set_edm_name( 'HorizontalAlignment' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).

  ENDMETHOD.


  METHOD def_sap_unit_of_measure.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_UNIT_OF_MEASURE'
                                    is_structure              = VALUE tys_sap_unit_of_measure( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__UnitOfMeasure' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_UNITS_OF_MEASURE' ).
    lo_entity_set->set_edm_name( 'SAP__UnitsOfMeasure' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'UNIT_CODE' ).
    lo_primitive_property->set_edm_name( 'UnitCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ISOCODE' ).
    lo_primitive_property->set_edm_name( 'ISOCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EXTERNAL_CODE' ).
    lo_primitive_property->set_edm_name( 'ExternalCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'TEXT' ).
    lo_primitive_property->set_edm_name( 'Text' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DECIMAL_PLACES' ).
    lo_primitive_property->set_edm_name( 'DecimalPlaces' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Int16' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_sap_value_help.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'SAP_VALUE_HELP'
                                    is_structure              = VALUE tys_sap_value_help( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'SAP__ValueHelp' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'SAP_VALUE_HELP_SET' ).
    lo_entity_set->set_edm_name( 'SAP__ValueHelpSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'VALUEHELP' ).
    lo_primitive_property->set_edm_name( 'VALUEHELP' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FIELD_VALUE' ).
    lo_primitive_property->set_edm_name( 'FIELD_VALUE' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'DESCRIPTION' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_zi_mm_accounting_documen_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZI_MM_ACCOUNTING_DOCUMEN_2'
                                    is_structure              = VALUE tys_zi_mm_accounting_documen_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZI_MM_AccountingDocumentType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZI_MM_ACCOUNTING_DOCUMENT' ).
    lo_entity_set->set_edm_name( 'ZI_MM_AccountingDocument' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'FISCAL_YEAR' ).
    lo_primitive_property->set_edm_name( 'FiscalYear' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PHYSICAL_INVENTORY_DOCUMEN' ).
    lo_primitive_property->set_edm_name( 'PhysicalInventoryDocument' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MATERIAL_DOCUMENT' ).
    lo_primitive_property->set_edm_name( 'MaterialDocument' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'POSTING_DATE' ).
    lo_primitive_property->set_edm_name( 'PostingDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MATERIAL' ).
    lo_primitive_property->set_edm_name( 'Material' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BR_NFSOURCE_DOCUMENT_NUMBE' ).
    lo_primitive_property->set_edm_name( 'BR_NFSourceDocumentNumber' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 35 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BR_NOTA_FISCAL' ).
    lo_primitive_property->set_edm_name( 'BR_NotaFiscal' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BR_NFE_NUMBER' ).
    lo_primitive_property->set_edm_name( 'BR_NFeNumber' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 9 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BR_NFIS_CANCELED' ).
    lo_primitive_property->set_edm_name( 'BR_NFIsCanceled' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BR_NFE_DOCUMENT_STATUS' ).
    lo_primitive_property->set_edm_name( 'BR_NFeDocumentStatus' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BR_NFE_DOCUMENT_STATUS_TEX' ).
    lo_primitive_property->set_edm_name( 'BR_NFeDocumentStatusText' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 60 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANY_CODE' ).
    lo_primitive_property->set_edm_name( 'CompanyCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANY_CODE_NAME' ).
    lo_primitive_property->set_edm_name( 'CompanyCodeName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 25 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACCOUNTING_DOCUMENT' ).
    lo_primitive_property->set_edm_name( 'AccountingDocument' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ACCOUNTING_DOCUMENT_YEAR' ).
    lo_primitive_property->set_edm_name( 'AccountingDocumentYear' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'EXTERNAL_REFERENCE' ).
    lo_primitive_property->set_edm_name( 'ExternalReference' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DOCUMENT_DATE' ).
    lo_primitive_property->set_edm_name( 'DocumentDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ).

  ENDMETHOD.


  METHOD def_zi_mm_vh_batchtype.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZI_MM_VH_BATCHTYPE'
                                    is_structure              = VALUE tys_zi_mm_vh_batchtype( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZI_MM_VH_BATCHType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZI_MM_VH_BATCH' ).
    lo_entity_set->set_edm_name( 'ZI_MM_VH_BATCH' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANT' ).
    lo_primitive_property->set_edm_name( 'Plant' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MATERIAL' ).
    lo_primitive_property->set_edm_name( 'Material' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 18 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BATCH' ).
    lo_primitive_property->set_edm_name( 'Batch' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MATERIALNAME' ).
    lo_primitive_property->set_edm_name( 'Materialname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANTNAME' ).
    lo_primitive_property->set_edm_name( 'Plantname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_zi_mm_vh_companytype.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZI_MM_VH_COMPANYTYPE'
                                    is_structure              = VALUE tys_zi_mm_vh_companytype( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZI_MM_VH_COMPANYType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZI_MM_VH_COMPANY' ).
    lo_entity_set->set_edm_name( 'ZI_MM_VH_COMPANY' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANYCODE' ).
    lo_primitive_property->set_edm_name( 'Companycode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANYCODENAME' ).
    lo_primitive_property->set_edm_name( 'Companycodename' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 25 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_zi_mm_vh_materialtype.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZI_MM_VH_MATERIALTYPE'
                                    is_structure              = VALUE tys_zi_mm_vh_materialtype( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZI_MM_VH_MATERIALType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZI_MM_VH_MATERIAL' ).
    lo_entity_set->set_edm_name( 'ZI_MM_VH_MATERIAL' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'MATERIAL' ).
    lo_primitive_property->set_edm_name( 'Material' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 18 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MATERIALNAME' ).
    lo_primitive_property->set_edm_name( 'Materialname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_zi_mm_vh_planttype.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZI_MM_VH_PLANTTYPE'
                                    is_structure              = VALUE tys_zi_mm_vh_planttype( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZI_MM_VH_PLANTType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZI_MM_VH_PLANT' ).
    lo_entity_set->set_edm_name( 'ZI_MM_VH_PLANT' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANT' ).
    lo_primitive_property->set_edm_name( 'Plant' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANTNAME' ).
    lo_primitive_property->set_edm_name( 'Plantname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_zi_mm_vh_product_hierarc_2.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZI_MM_VH_PRODUCT_HIERARC_2'
                                    is_structure              = VALUE tys_zi_mm_vh_product_hierarc_2( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZI_MM_VH_PRODUCT_HIERARCHYType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZI_MM_VH_PRODUCT_HIERARCHY' ).
    lo_entity_set->set_edm_name( 'ZI_MM_VH_PRODUCT_HIERARCHY' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'PRODUCTHIERARCHY' ).
    lo_primitive_property->set_edm_name( 'Producthierarchy' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 18 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PRODUCTHIERARCHYTEXT' ).
    lo_primitive_property->set_edm_name( 'Producthierarchytext' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_zi_mm_vh_profit_centertype.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZI_MM_VH_PROFIT_CENTERTYPE'
                                    is_structure              = VALUE tys_zi_mm_vh_profit_centertype( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZI_MM_VH_PROFIT_CENTERType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZI_MM_VH_PROFIT_CENTER' ).
    lo_entity_set->set_edm_name( 'ZI_MM_VH_PROFIT_CENTER' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROFITCENTER' ).
    lo_primitive_property->set_edm_name( 'Profitcenter' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PROFITCENTERNAME' ).
    lo_primitive_property->set_edm_name( 'Profitcentername' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 20 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_zi_mm_vh_storage_locationt.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'ZI_MM_VH_STORAGE_LOCATIONT'
                                    is_structure              = VALUE tys_zi_mm_vh_storage_locationt( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'ZI_MM_VH_STORAGE_LOCATIONType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'ZI_MM_VH_STORAGE_LOCATION' ).
    lo_entity_set->set_edm_name( 'ZI_MM_VH_STORAGE_LOCATION' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANT' ).
    lo_primitive_property->set_edm_name( 'Plant' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'STORAGELOCATION' ).
    lo_primitive_property->set_edm_name( 'storagelocation' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'STORAGELOCATIONNAME' ).
    lo_primitive_property->set_edm_name( 'Storagelocationname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 16 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANTNAME' ).
    lo_primitive_property->set_edm_name( 'Plantname' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


ENDCLASS.
