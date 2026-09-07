@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Customer Time Analytics'

@Metadata.ignorePropagatedAnnotations: true

define root view entity Z02_I_CUSTOMER_TIME_ANALYTICS
  as select from Z02_I_SALES_FACT

{
  key CustomerId,

  key CalendarYear,
      @ObjectModel.text.element: [ 'QuarterText' ]
  key CalendarQuarter,
      @ObjectModel.text.element: [ 'MonthText' ]
  key YearMonth,
  key Currency,

      QuarterText,
      CustomerName,
      MonthText,


      @Semantics.amount.currencyCode: 'Currency'
      sum(GrossSales)         as TotalGrossSales,

      @Semantics.amount.currencyCode: 'Currency'
      sum(NetSales)           as TotalNetSales,

      @Semantics.amount.currencyCode: 'Currency'
      sum(CancelledValue)     as TotalCancelledValue,

      sum(ItemCount)          as TotalItems,

      sum(CancelledItemCount) as CancelledItems,

      sum(ActiveItemCount)    as ActiveItems
}

group by
  CustomerId,
  CustomerName,
  CalendarYear,
  CalendarQuarter,
  QuarterText,
  YearMonth,
  MonthText,
  Currency
