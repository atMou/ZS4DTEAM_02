@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Brand Sales Analytics'
@Metadata.ignorePropagatedAnnotations: false

define root view entity Z02_I_CUSTOMER_BRAND_ANALYTICS
  as select from Z02_I_SALES_FACT
{
      @ObjectModel.text.element: [ 'CustomerName' ]
  key CustomerId,

      @ObjectModel.text.element: [ 'BrandName' ]
  key BrandId,

  key CalendarYear,

      @ObjectModel.text.element: [ 'QuarterText' ]
  key CalendarQuarter,
      @ObjectModel.text.element: [ 'MonthText' ]
  key YearMonth,
  key Currency,
      QuarterText,
      MonthText,

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
  CalendarYear,
  CalendarQuarter,
  YearMonth,
  QuarterText,
  MonthText,

  Currency
