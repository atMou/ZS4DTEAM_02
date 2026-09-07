@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Brand Summary'
@Metadata.ignorePropagatedAnnotations: true

define root view entity Z02_I_CUSTOMER_BRAND_SUMMARY
  as select from Z02_I_SALES_FACT
{
      @ObjectModel.text.element: [ 'CustomerName' ]
  key CustomerId,


      @ObjectModel.text.element: [ 'BrandName' ]
  key BrandId,


  key Currency,

      CustomerName,
      BrandName,
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
  BrandId,
  BrandName,
  Currency
