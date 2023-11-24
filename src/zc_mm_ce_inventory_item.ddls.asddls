@EndUserText.label: 'Cockpit de Inventário - Item'
@UI.headerInfo.typeName: 'Item'
@UI.headerInfo.typeNamePlural: 'Itens'
@UI.headerInfo.title.type: #STANDARD
@Metadata.allowExtensions: true
@UI.headerInfo.typeImageUrl: 'sap-icon://sap-box'

@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_INVENTORY_ITEM'

@UI.lineItem: [{criticality: 'StatusCrit'}]

@UI.presentationVariant: [{sortOrder: [{by: 'Material', direction: #ASC }]}]

@ObjectModel.semanticKey: ['Material', 'Plant' ]

define custom entity ZC_MM_CE_INVENTORY_ITEM
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------

      @UI.facet                 : [ { id           : 'Item',
                                      purpose      : #STANDARD,
                                      type         : #IDENTIFICATION_REFERENCE,
                                      position     : 10 },

                                    { id           : 'Header',
                                      purpose      : #STANDARD,
                                      type         : #LINEITEM_REFERENCE,
                                      position     : 20,
                                      targetElement: '_Head'}]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------

      @UI.hidden                : true

      @EndUserText.label        : 'ID do documento'
  key DocumentId                : abap.raw(16);

      @UI.hidden                : true

      @EndUserText.label        : 'ID do item do documento'
  key DocumentItemId            : abap.raw(16);

      @UI.lineItem              : [{ position: 170, criticality: 'StatusCrit' }]
      @UI.identification        : [{ position: 170, criticality: 'StatusCrit' }]

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_VH_COUNTING_STATUS', element: 'Status' },
                                           additionalBinding: [{ element: 'StatusText', localElement: 'StatusText' }],
                                           qualifier: 'ZI_MM_VH_COUNTING_STATUS', useForValidation: true  }]

      @EndUserText.label        : 'Status'
      @ObjectModel.text.element : ['StatusText']
      statusId                  : ze_mm_counting_status;

      @UI.hidden                : true

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_VH_COUNTING_STATUS', element: 'StatusText ' },
                                           additionalBinding: [{ element: 'Status', localElement: 'StatusId' }],
                                           qualifier: 'ZI_MM_VH_COUNTING_STATUS', useForValidation: true  }]

      @EndUserText.label        : 'Descrição do status'
      StatusText                : abap.char(60);

      @UI.hidden                : true

      @EndUserText.label        : 'Criticalidade do status'
      StatusCrit                : abap.int1;

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_MATERIAL', element: 'Material' },
                                           additionalBinding: [{ element: 'MaterialName', localElement: 'MaterialName' }],
                                           qualifier: 'ZI_MM_CE_VH_MATERIAL', useForValidation: true  }]

      @UI.lineItem              : [{ position: 10 }]
      @UI.identification        : [{ position: 10 }]

      @EndUserText.label        : 'Material'
      @ObjectModel.text.element : ['MaterialName']
      Material                  : abap.char(40);

      @UI.hidden                : true

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_MATERIAL', element: 'MaterialName' },
                                           additionalBinding: [{ element: 'Material', localElement: 'Material' }],
                                           qualifier: 'ZI_MM_CE_VH_MATERIAL', useForValidation: true  }]

      @EndUserText.label        : 'Nome do Material'
      MaterialName              : abap.char(40);

      @UI.lineItem              : [{ position: 20 }]
      @UI.identification        : [{ position: 20 }]

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_PLANT', element: 'Plant' },
                                           additionalBinding: [{ element: 'PlantName', localElement: 'PlantName' }],
                                           qualifier: 'ZI_MM_CE_VH_PLANT', useForValidation: true  }]

      @EndUserText.label        : 'Centro'
      @ObjectModel.text.element : ['PlantName']
      Plant                     : abap.char(4);

      @UI.hidden                : true

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_PLANT', element: 'PlantName' },
                                           additionalBinding: [{ element: 'Plant', localElement: 'Plant' }],
                                           qualifier: 'ZI_MM_CE_VH_PLANT', useForValidation: true  }]

      @EndUserText.label        : 'Nome do Centro'
      PlantName                 : abap.char(30);

      @UI.lineItem              : [{ position: 30 }]
      @UI.identification        : [{ position: 30 }]

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_STORAGE_LOCATION', element: 'StorageLocation' },
                                           additionalBinding: [{ element: 'Plant', localElement: 'Plant' },
                                                               { element: 'PlantName', localElement: 'PlantName' },
                                                               { element: 'StorageLocationName', localElement: 'StorageLocationName' }],
                                           qualifier: 'ZI_MM_CE_VH_STORAGE_LOCATION', useForValidation: true  }]

      @EndUserText.label        : 'Depósito'
      @ObjectModel.text.element : ['StorageLocationName']
      StorageLocation           : abap.char(4);

      @UI.hidden                : true

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_STORAGE_LOCATION', element: 'StorageLocationName' },
                                           additionalBinding: [{ element: 'StorageLocation', localElement: 'StorageLocation' },
                                                               { element: 'Plant', localElement: 'Plant' },
                                                               { element: 'PlantName', localElement: 'PlantName' }],
                                           qualifier: 'ZI_MM_CE_VH_STORAGE_LOCATION', useForValidation: true  }]

      @EndUserText.label        : 'Nome do Depósito'
      StorageLocationName       : abap.char(16);

      @UI.lineItem              : [{ position: 40 }]
      @UI.identification        : [{ position: 40 }]

      @EndUserText.label        : 'Número do lote'
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_BATCH', element: 'Batch' },
                                           additionalBinding: [{ element: 'Plant', localElement: 'Plant' },
                                                               { element: 'PlantName', localElement: 'PlantName' },
                                                               { element: 'Material', localElement: 'Material'},
                                                               { element: 'MaterialName', localElement: 'MaterialName'}],
                                           qualifier: 'ZI_MM_CE_VH_BATCH', useForValidation: true  }]
      Batch                     : abap.char(10);

      @UI.lineItem              : [{ position: 51, criticality: 'QuantityStockCrit', criticalityRepresentation: #WITHOUT_ICON }]
      @UI.identification        : [{ position: 51, criticality: 'QuantityStockCrit', criticalityRepresentation: #WITHOUT_ICON }]
      @UI.textArrangement       : #TEXT_ONLY

      @EndUserText.label        : 'Quantidade em Estoque'
      @Semantics.quantity.unitOfMeasure : 'Unit'
      QuantityStock             : abap.quan(13,3);

      @UI.lineItem              : [{ position: 50, criticality: 'QuantityStockCrit' }]
      @UI.identification        : [{ position: 50, criticality: 'QuantityStockCrit' }]

      @EndUserText.label        : 'Status do Estoque'
      QuantityStockText         : abap.char(60);

      @UI.hidden                : true

      @EndUserText.label        : 'Quantidade em Estoque (Criticalidade)'
      QuantityStockCrit         : int1;

      @UI.lineItem              : [{ position: 60 }]
      @UI.identification        : [{ position: 60 }]

      @EndUserText.label        : 'Quantidade da contagem'
      @Semantics.quantity.unitOfMeasure : 'Unit'
      QuantityCount             : abap.quan(13,3);

      @UI.lineItem              : [{ position: 70, criticality: 'QuantityCurrentCrit', criticalityRepresentation: #WITHOUT_ICON }]
      @UI.identification        : [{ position: 70, criticality: 'QuantityCurrentCrit', criticalityRepresentation: #WITHOUT_ICON }]

      @EndUserText.label        : 'Quantidade estoque atual'
      @Semantics.quantity.unitOfMeasure : 'Unit'
      QuantityCurrent           : abap.quan(13,3);

      @UI.hidden                : true

      @EndUserText.label        : 'Quantidade estoque atual (Criticalidade)'
      QuantityCurrentCrit       : int1;

      @UI.lineItem              : [{ position: 80 }]
      @UI.identification        : [{ position: 80 }]

      @EndUserText.label        : 'Diferença contagem'
      @Semantics.quantity.unitOfMeasure : 'Unit'
      Balance                   : abap.quan(13,3);

      @UI.lineItem              : [{ position: 90 }]
      @UI.identification        : [{ position: 90 }]

      @EndUserText.label        : 'Diferença atual'
      @Semantics.quantity.unitOfMeasure : 'Unit'
      BalanceCurrent            : abap.quan(13,3);

      @EndUserText.label        : 'Unidade da contagem'
      Unit                      : abap.unit(3);

      @UI.lineItem              : [{ position: 100 }]
      @UI.identification        : [{ position: 100 }]

      @EndUserText.label        : 'Preço Qtd estoque'
      @Semantics.amount.currencyCode : 'Currency'
      PriceStock                : abap.curr(11,2);

      @UI.lineItem              : [{ position: 110 }]
      @UI.identification        : [{ position: 110 }]

      @EndUserText.label        : 'Preço contagem'
      @Semantics.amount.currencyCode : 'Currency'
      PriceCount                : abap.curr(11,2);

      @UI.lineItem              : [{ position: 120 }]
      @UI.identification        : [{ position: 120 }]

      @EndUserText.label        : 'Preço diferença'
      @Semantics.amount.currencyCode : 'Currency'
      PriceDiff                 : abap.curr(11,2);

      @EndUserText.label        : 'Moeda'
      Currency                  : abap.cuky;

      @UI.lineItem              : [{ position: 130 }]
      @UI.identification        : [{ position: 130 }]

      @EndUserText.label        : 'Peso Bruto'
      @Semantics.quantity.unitOfMeasure : 'Unit'
      Weight                    : abap.quan(13,3);

      @EndUserText.label        : 'Unidade do peso'
      WeightUnit                : abap.unit(3);

      @UI.hidden                : true

      @UI.lineItem              : [{ position: 140 }]
      @UI.identification        : [{ position: 140 }]

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_PRODUCT_HIERARCHY', element: 'ProductHierarchy' },
                                           qualifier: 'ZI_MM_CE_VH_PRODUCT_HIERARCHY', useForValidation: true  }]

      @EndUserText.label        : 'Hierarquia de produtos'
      ProductHierarchy          : abap.char(18);

      @UI.lineItem              : [{ position: 180, type:#AS_DATAPOINT }]
      @UI.identification        : [{ position: 180, type:#AS_DATAPOINT }]
      @UI.dataPoint             : { targetValue: 100, visualization: #PROGRESS }

      @EndUserText.label        : 'Acuracidade'
      Accuracy                  : abap.dec(13,2);

      @EndUserText.label        : 'Documento do material (Ano)'
      MaterialDocumentYear      : abap.numc(4);

      @UI.lineItem              : [{ position: 190 }]
      @UI.identification        : [{ position: 190 }]

      @EndUserText.label        : 'Documento do material'
      MaterialDocument          : abap.char(10);

      @UI.lineItem              : [{ position: 200 }]
      @UI.identification        : [{ position: 200 }]

      @EndUserText.label        : 'Data de lançamento'
      PostingDate               : abap.dats;

      @UI.lineItem              : [{ position: 210 }]
      @UI.identification        : [{ position: 210 }]

      @EndUserText.label        : 'Nº Doc. Entrada Saída'
      BR_NotaFiscal             : abap.numc(10);

      @UI.lineItem              : [{ position: 220 }]
      @UI.identification        : [{ position: 220 }]

      @EndUserText.label        : 'N° Doc. Contabilização'
      AccountingDocument        : abap.char(10);

      @EndUserText.label        : 'N° Doc. Contabilização (Ano)'
      AccountingDocumentYear    : abap.numc(4);

      @EndUserText.label        : 'Doc Contabilização Est.'
      InvoiceReference          : abap.char(10);

      @UI.lineItem              : [{ position: 230 }]
      @UI.identification        : [{ position: 230 }]

      @EndUserText.label        : 'Data Doc. Contabilização'
      DocumentDate              : abap.dats;

      @EndUserText.label        : 'Número NF-e'
      BR_NFeNumber              : abap.char(9);

      @EndUserText.label        : 'Nota fiscal cancelada'
      BR_NFIsCanceled           : abap.char(1);

      @EndUserText.label        : 'Status NFe'
      @ObjectModel.text.element : ['BR_NFeDocumentStatusText']
      BR_NFeDocumentStatus      : abap.char(1);

      @UI.hidden                : true

      @EndUserText.label        : 'Descrição Status NFe'
      BR_NFeDocumentStatusText  : abap.char(40);

      @EndUserText.label        : 'Empresa'
      @ObjectModel.text.element : ['CompanyCodeName']
      CompanyCode               : abap.char(4);

      @UI.hidden                : true

      @EndUserText.label        : 'Nome da Empresa'
      CompanyCodeName           : abap.char(40);

      @UI.lineItem              : [{ position: 160, semanticObjectAction: 'displayList', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.identification        : [{ position: 160, semanticObjectAction: 'displayList', type: #WITH_INTENT_BASED_NAVIGATION }]
      @Consumption.semanticObject :'PhysicalInventoryDocument'

      @EndUserText.label        : 'Documento do inventário físico'
      PhysicalInventoryDocument : abap.char(10);

      @UI.lineItem              : [{ position: 170 }]
      @UI.identification        : [{ position: 170 }]

      @EndUserText.label        : 'Documento do inventário físico (Ano)'
      FiscalYear                : abap.numc(4);

      @EndUserText.label        : 'Referência Externa'
      ExternalReference         : abap.char(40);

      @UI.lineItem              : [{ position: 150 }]
      @UI.identification        : [{ position: 150 }]

      @EndUserText.label        : 'Centro de Lucro'
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_PROFIT_CENTER', element: 'ProfitCenter' },
                                           qualifier: 'ZI_MM_CE_VH_PROFIT_CENTER', useForValidation: true  }]
      ProfitCenter              : abap.char(10);

      @UI.hidden                : true

      @EndUserText.label        : 'Criado por'
      CreatedBy                 : abap.char(12);

      @UI.hidden                : true

      @EndUserText.label        : 'Criado em'
      CreatedAt                 : timestampl;

      @UI.hidden                : true

      @EndUserText.label        : 'Modificado por'
      LastChangedBy             : abap.char(12);

      @UI.hidden                : true

      @EndUserText.label        : 'Modificado em'
      LastChangedAt             : timestampl;

      @UI.hidden                : true

      @EndUserText.label        : 'Registro'
      LocalLastChangedAt        : timestampl;

      /* Associations */

      @ObjectModel.sort.enabled : true
      @ObjectModel.filter.enabled: true
      _Head                     : association to parent ZC_MM_CE_INVENTORY_HEAD on _Head.DocumentId = $projection.DocumentId;

}
