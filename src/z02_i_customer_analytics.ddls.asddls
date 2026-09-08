@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Sales Analytics'
@Metadata.ignorePropagatedAnnotations: true

define root view entity Z02_I_CUSTOMER_ANALYTICS
  as select from Z02_I_SALES_FACT
{
      @ObjectModel.text.element: [ 'CustomerName' ]
  key CustomerId,
  key Currency,

      CustomerName,

      @Semantics.amount.currencyCode: 'Currency'
      sum( GrossSales )         as TotalGrossSales,

      @Semantics.amount.currencyCode: 'Currency'
      sum( NetSales )           as TotalNetSales,

      @Semantics.amount.currencyCode: 'Currency'
      sum( CancelledValue )     as TotalCancelledValue,

      sum( ItemCount )          as TotalItems,

      sum( CancelledItemCount ) as CancelledItems,

      sum( ActiveItemCount )    as ActiveItems
}
group by
  CustomerId,
  CustomerName,
  Currency
