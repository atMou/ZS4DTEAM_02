@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Brand Sales Analytics by Time'
@Metadata.ignorePropagatedAnnotations: true

define root view entity Z02_I_BRAND_TIME_ANALYTICS
  as select from Z02_I_SALES_FACT
{
      @ObjectModel.text.element: [ 'BrandName' ]
  key BrandId,

  key CalendarYear,
  key CalendarQuarter,
  key YearMonth,
  key Currency,

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
  BrandId,
  BrandName,
  CalendarYear,
  CalendarQuarter,
  YearMonth,
  Currency
