@EndUserText.label: 'Cockpit de Inventário - Cabeçalho'
//@UI.headerInfo.typeName: 'Cockpit de Inventário'
//@UI.headerInfo.typeNamePlural: 'Cockpit de Inventário'
@UI.headerInfo.title.type: #STANDARD
@Metadata.allowExtensions: true

@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_INVENTORY_HEAD'

@UI.lineItem: [{criticality: 'StatusCrit'}]

@UI.presentationVariant: [{sortOrder: [{by: 'DocumentNo', direction: #DESC }]}]

@ObjectModel.semanticKey: ['DocumentNo']

define custom entity ZC_MM_CE_INVENTORY_HEAD_INFO
{

      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------

      @UI.facet          : [ { id             : 'Dados',
                               purpose        : #STANDARD,
                               type           : #COLLECTION,
                               label          : 'Dados Gerais',
                               position       : 10 },

                             { id             : 'DadosGeral',
                               purpose        : #STANDARD,
                               label          : 'Dados Gerais',
                               parentId       : 'Dados',
                               type           : #FIELDGROUP_REFERENCE,
                               targetQualifier: 'DadosGeral',
                               position       : 11 },

                             { id             : 'DadosRegistro',
                               purpose        : #STANDARD,
                               label          : 'Dados de Modificação',
                               parentId       : 'Dados',
                               type           : #FIELDGROUP_REFERENCE,
                               targetQualifier: 'DadosRegistro',
                               position       : 12 },

                             { id           : 'Header',
                               purpose      : #STANDARD,
                               type         : #LINEITEM_REFERENCE,
                               position     : 20,
                               targetElement: '_Head'}
                  ]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------

      @UI.hidden         : true
      @EndUserText.label : 'ID do documento'
  key DocumentId         : abap.raw(16);

      @UI.lineItem       : [{ position: 10 }]
      @UI.fieldGroup     : [{ position: 10, qualifier: 'DadosGeral' }]

      @EndUserText.label : 'Número do documento'
      DocumentNo         : abap.char(10);

//      @UI.lineItem       : [{ position: 20 }]
      @UI.fieldGroup     : [{ position: 20, qualifier: 'DadosGeral' }]
      @UI.dataPoint      : { qualifier: 'DataPointCountId', title: 'Id contagem' }

      @EndUserText.label : 'ID da contagem'
      CountId            : abap.char(40);

//      @UI.lineItem       : [{ position: 30 }]
      @UI.fieldGroup     : [{ position: 30, qualifier: 'DadosGeral' }]

      @EndUserText.label : 'Data da contagem'
      @Consumption.filter.selectionType: #INTERVAL
      CountDate          : abap.dats;

      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_VH_INVENTORY_STATUS', element: 'Status' },
                                           additionalBinding: [{ element: 'StatusText', localElement: 'StatusText' }],
                                           qualifier: 'ZI_MM_VH_INVENTORY_STATUS', useForValidation: true  }]

      @UI.lineItem       : [{ position: 40, criticality: 'StatusCrit' } ]
      @UI.fieldGroup     : [{ position: 40, criticality: 'StatusCrit', qualifier: 'DadosGeral' }]
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

//      @UI.lineItem       : [{ position: 45 }]
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
//      @UI.lineItem       : [{ position: 70 } ]
      @UI.fieldGroup     : [{ position: 70, qualifier: 'DadosGeral' }]

      @EndUserText.label : 'Observações'
      Description        : abap.char(80);

      @UI.lineItem       : [{ position: 110 } ]
      @UI.fieldGroup     : [{ position: 10, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Criado por'
      CreatedBy          : abap.char(12);

      @UI.lineItem       : [{ position: 120 } ]
      @UI.fieldGroup     : [{ position: 20, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Criado em'
      CreatedAt          : timestampl;

      @UI.lineItem       : [{ position: 130 } ]
      @UI.fieldGroup     : [{ position: 30, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Modificado por'
      LastChangedBy      : abap.char(12);

      @UI.lineItem       : [{ position: 140 } ]
      @UI.fieldGroup     : [{ position: 40, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Modificado em'
      LastChangedAt      : timestampl;

      @UI.lineItem       : [{ position: 150 } ]
      @UI.fieldGroup     : [{ position: 50, qualifier: 'DadosRegistro' }]

      @EndUserText.label : 'Registro'
      LocalLastChangedAt : timestampl;

      /* Associations */

      @ObjectModel.sort.enabled : true
      @ObjectModel.filter.enabled: true
      _Head              : association to parent ZC_MM_CE_INVENTORY_HEAD on _Head.DocumentId = $projection.DocumentId;

}
