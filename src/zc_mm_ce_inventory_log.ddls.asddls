@EndUserText.label: 'Cockpit de Inventário - Log'
@UI.headerInfo.typeName: 'Mensagem'
@UI.headerInfo.typeNamePlural: 'Mensagens'
@UI.headerInfo.title.type: #STANDARD
@Metadata.allowExtensions: true

@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_CE_INVENTORY_LOG'

@UI.lineItem: [{criticality: 'MsgtyCrit'}]

@UI.presentationVariant: [{sortOrder: [{by: 'Line', direction: #DESC }]}]

@ObjectModel.semanticKey: ['DocumentId', 'Line']

define custom entity ZC_MM_CE_INVENTORY_LOG
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------

      @UI.facet          : [ { id           : 'Log',
                               purpose      : #STANDARD,
                               type         : #IDENTIFICATION_REFERENCE,
                               position     : 10 }]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------

      @UI.hidden         : true

      @EndUserText.label : 'ID do documento'
  key DocumentId         : abap.raw(16);

      @UI.lineItem       : [{ position: 10 }]
      @UI.identification : [{ position: 10 }]

      @EndUserText.label : 'Linha'
  key Line               : abap.numc(10);

      @EndUserText.label : 'Classe de mensagem'
      Msgid              : abap.char(20);

      @UI.lineItem       : [{ position: 20 }]
      @UI.identification : [{ position: 20 }]

      @EndUserText.label : 'Tipo de mensagem'
      @ObjectModel.text.element : ['MsgtyText']
      Msgty              : abap.char(1);

      @UI.hidden         : true

      @EndUserText.label : 'Descrição Tipo de mensagem'
      MsgtyText          : abap.char(40);

      @UI.hidden         : true

      @EndUserText.label : 'Criticalidade Tipo de mensagem'
      MsgtyCrit          : abap.int1;

      @EndUserText.label : 'Número da mensagem'
      Msgno              : abap.numc(3);

      @EndUserText.label : 'Variável 1 da mensagem'
      Msgv1              : abap.char(50);

      @EndUserText.label : 'Variável 2 da mensagem'
      Msgv2              : abap.char(50);

      @EndUserText.label : 'Variável 3 da mensagem'
      Msgv3              : abap.char(50);

      @EndUserText.label : 'Variável 4 da mensagem'
      Msgv4              : abap.char(50);

      @UI.lineItem       : [{ position: 30 }]
      @UI.identification : [{ position: 30 }]

      @EndUserText.label : 'Mensagem'
      Message            : abap.char(220);

      @EndUserText.label : 'Criado por'
      CreatedBy          : abap.char(12);

      @EndUserText.label : 'Criado em'
      CreatedAt          : timestampl;

      @EndUserText.label : 'Modificado por'
      LastChangedBy      : abap.char(12);

      @EndUserText.label : 'Modificado em'
      LastChangedAt      : timestampl;

      @UI.lineItem       : [{ position: 40 }]
      @UI.identification : [{ position: 40 }]

      @EndUserText.label : 'Registro'
      LocalLastChangedAt : timestampl;

      /* Associations */

      @ObjectModel.sort.enabled: true
      @ObjectModel.filter.enabled: true
      _Head              : association to parent ZC_MM_CE_INVENTORY_HEAD on _Head.DocumentId = $projection.DocumentId;

}
