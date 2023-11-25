@EndUserText.label: 'Cockpit de Inventário - Cabeçalho'
@UI.headerInfo.typeName: 'Cockpit de Inventário'
@UI.headerInfo.typeNamePlural: 'Cockpit de Inventário'
@UI.headerInfo.title.type: #STANDARD
@UI.headerInfo.title.value: 'Description'
@Metadata.allowExtensions: true
@UI.headerInfo.typeImageUrl: 'sap-icon://inventory'

@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_INVENTORY_HEAD'

@UI.lineItem: [{criticality: 'StatusCrit'}]

@UI.presentationVariant: [{sortOrder: [{by: 'DocumentNo', direction: #DESC }]}]

@ObjectModel.semanticKey: ['DocumentNo']

define root custom entity ZC_MM_CE_INVENTORY_HEAD
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------

      @UI.facet          : [ { id            : 'DataPointCountId',
                               purpose        : #HEADER,
                               type           : #DATAPOINT_REFERENCE,
                               targetQualifier: 'DataPointCountId',
                               position       : 01 },

                             { id             : 'DataPointStatusId',
                               purpose        : #HEADER,
                               type           : #DATAPOINT_REFERENCE,
                               targetQualifier: 'DataPointStatusId',
                               position       : 01 },

                             { id             : 'Dados',
                               purpose        : #STANDARD,
                               type           : #COLLECTION,
                               label          : 'Documento',
                               position       : 10 },
                               
                             { id             : 'DadosGeral',
                               purpose        : #STANDARD,
                               parentId       : 'Dados',
                               type           : #FIELDGROUP_REFERENCE,
                               targetQualifier: 'DadosGeral',
                               position       : 11 },
                               
//                             { id             : 'Dados',
//                               purpose        : #STANDARD,
//                               type           : #COLLECTION,
//                               label          : 'Documento',
//                               position       : 10 },
//                             { id             : 'DadosGeral',
//                               purpose        : #STANDARD,
//                               label          : 'Dados Gerais',
//                               parentId       : 'Dados',
//                               type           : #FIELDGROUP_REFERENCE,
//                               targetQualifier: 'DadosGeral',
//                               position       : 11 },
//
//                             { id             : 'DadosRegistro',
//                               purpose        : #STANDARD,
//                               label          : 'Dados de Modificação',
//                               parentId       : 'Dados',
//                               type           : #FIELDGROUP_REFERENCE,
//                               targetQualifier: 'DadosRegistro',
//                               position       : 12 },

                             { id             : 'Info',
                               purpose        : #STANDARD,
                               type           : #LINEITEM_REFERENCE,
                               label          : 'Dados Gerais',
                               position       : 20, 
                               targetElement  : '_HeadInfo'},

                             { id             : 'Item',
                               purpose        : #STANDARD,
                               type           : #LINEITEM_REFERENCE,
                               label          : 'Itens',
                               position       : 30,
                               targetElement  : '_Item'},

                             { id             : 'Log',
                               purpose        : #STANDARD,
                               type           : #LINEITEM_REFERENCE,
                               label          : 'Logs',
                               position       : 40,
                               targetElement  : '_Log'}
                  ]

      // ------------------------------------------------------
      //Button information
      // ------------------------------------------------------
      @UI.lineItem       : [{ position: 10, type: #FOR_ACTION, dataAction: 'liberar', label: 'Liberar' },
                            { position: 20, type: #FOR_ACTION, dataAction: 'cancelar', label: 'Encerrar' }]

      @UI.identification : [{ position: 10, type: #FOR_ACTION, dataAction: 'liberar', label: 'Liberar' },
                            { position: 20, type: #FOR_ACTION, dataAction: 'cancelar', label: 'Encerrar' }]

          // ------------------------------------------------------
          // Field information
          // ------------------------------------------------------

      @UI.hidden         : true
      @EndUserText.label : 'ID do documento'
  key DocumentId         : abap.raw(16);

      @UI.selectionField : [{ position: 10 }]
      @UI.lineItem       : [{ position: 10 }]
//      @UI.fieldGroup     : [{ position: 10, qualifier: 'DadosGeral' }]

      @EndUserText.label : 'Número do documento'
      DocumentNo         : abap.char(10);

      @UI.selectionField : [{ position: 20 }]
      @UI.lineItem       : [{ position: 20 }]
      @UI.fieldGroup     : [{ position: 20, qualifier: 'DadosGeral' }]
      @UI.dataPoint      : { qualifier: 'DataPointCountId', title: 'Id contagem' }

      @EndUserText.label : 'ID da contagem'
      CountId            : abap.char(40);

      @UI.selectionField : [{ position: 30 }]
      @UI.lineItem       : [{ position: 30 }]
      @UI.fieldGroup     : [{ position: 30, qualifier: 'DadosGeral' }]

      @EndUserText.label : 'Data da contagem'
      @Consumption.filter.selectionType: #INTERVAL
      CountDate          : abap.dats;

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_VH_INVENTORY_STATUS', element: 'Status' },
                                           additionalBinding: [{ element: 'StatusText', localElement: 'StatusText' }],
                                           qualifier: 'ZI_MM_VH_INVENTORY_STATUS', useForValidation: true  }]

      @UI.selectionField : [{ position: 40 } ]
      @UI.lineItem       : [{ position: 40, criticality: 'StatusCrit' } ]
//      @UI.fieldGroup     : [{ position: 40, qualifier: 'DadosGeral' }]
      @UI.dataPoint      : { qualifier: 'DataPointStatusId', title: 'Status', criticality: 'StatusCrit' }

      @EndUserText.label : 'Status'
      @ObjectModel.text.element : ['StatusText']
      StatusId           : ze_mm_inventory_status;

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_VH_INVENTORY_STATUS', element: 'StatusText ' },
                                           additionalBinding: [{ element: 'Status', localElement: 'StatusId' }],
                                           qualifier: 'ZI_MM_VH_INVENTORY_STATUS', useForValidation: true  }]

      @UI.hidden         : true
      @EndUserText.label : 'Descrição do status'
      StatusText         : abap.char(60);

      @UI.hidden         : true
      @EndUserText.label : 'Criticalidade do status'
      StatusCrit         : abap.int1;

      @UI.selectionField : [{ position: 45 }]
      @UI.lineItem       : [{ position: 45 }]
      @UI.fieldGroup     : [{ position: 30, qualifier: 'DadosGeral' }]

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_PLANT', element: 'Plant' },
                                           additionalBinding: [{ element: 'PlantName', localElement: 'PlantName' }],
                                           qualifier: 'ZI_MM_CE_VH_PLANT', useForValidation: true  }]

      @EndUserText.label : 'Centro'
      @ObjectModel.text.element : ['PlantName']
      Plant              : abap.char(4);

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_CE_VH_PLANT', element: 'PlantName' },
                                           additionalBinding: [{ element: 'Plant', localElement: 'Plant' }],
                                           qualifier: 'ZI_MM_CE_VH_PLANT', useForValidation: true  }]

      @UI.hidden         : true
      @EndUserText.label : 'Nome do centro'
      PlantName          : abap.char(30);

      @UI.multiLineText  : true
      @UI.lineItem       : [{ position: 70 } ]
      @UI.fieldGroup     : [{ position: 70, qualifier: 'DadosGeral' }]

      @EndUserText.label : 'Observações'
      Description        : abap.char(80);

      @UI.fieldGroup     : [{ position: 10, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Criado por'
      CreatedBy          : abap.char(12);

      @UI.fieldGroup     : [{ position: 20, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Criado em'
      CreatedAt          : timestampl;

      @UI.fieldGroup     : [{ position: 30, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Modificado por'
      LastChangedBy      : abap.char(12);

      @UI.fieldGroup     : [{ position: 40, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Modificado em'
      LastChangedAt      : timestampl;

      @UI.fieldGroup     : [{ position: 50, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Registro'
      LocalLastChangedAt : timestampl;

      /* Associations */

      @ObjectModel.filter.enabled: true
      _HeadInfo          : composition [0..*] of ZC_MM_CE_INVENTORY_HEAD_INFO;

      @ObjectModel.filter.enabled: true
      _Item              : composition [0..*] of ZC_MM_CE_INVENTORY_ITEM;

      @ObjectModel.filter.enabled: true
      _Log               : composition [0..*] of ZC_MM_CE_INVENTORY_LOG;

}
