@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Order Status VH'

@Metadata.ignorePropagatedAnnotations: true


@Search.searchable: true

define view entity z02_order_status_vh
  as select from z02_order_st

{
      @ObjectModel.text.element: [ 'OrderStatusText' ]
      @UI.textArrangement:  #TEXT_ONLY
      @EndUserText.label: 'Order Status'
  key order_status_id          as OrderStatusId,

      @Consumption.filter.hidden: true
      @UI.hidden: true
      @Semantics.language: true
  key language                 as Language,

      @Search.defaultSearchElement: true
      order_status_text        as OrderStatusText,

      @Consumption.filter.hidden: true
      @EndUserText.label: 'Description'

      order_status_description as OrderStatusDescription
}

where
  language = $session.system_language
