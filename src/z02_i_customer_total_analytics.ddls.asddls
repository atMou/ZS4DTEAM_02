@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Customer Total Analytics'

@Metadata.ignorePropagatedAnnotations: true

define root view entity Z02_I_CUSTOMER_TOTAL_ANALYTICS
  as select from Z02_I_CUSTOMER_ANALYTICS_HUB

{
      @ObjectModel.text.element: [ 'CustomerName' ]
  key CustomerId,
  key Currency,

      CustomerName,

      @Semantics.amount.currencyCode: 'Currency'
      sum(TotalGrossSales)     as TotalGrossSales,

      @Semantics.amount.currencyCode: 'Currency'
      sum(TotalNetSales)       as TotalNetSales,

      @Semantics.amount.currencyCode: 'Currency'
      sum(TotalCancelledValue) as TotalCancelledValue,

      sum(TotalItems)          as TotalItems,

      sum(CancelledItems)      as CancelledItems,

      sum(ActiveItems)         as ActiveItems
}

group by
  CustomerId,
  Currency,
  CustomerName
