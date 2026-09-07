@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Analytics Hub'
@Metadata.ignorePropagatedAnnotations: true

define root view entity Z02_I_CUSTOMER_ANALYTICS_HUB
  as select from Z02_I_CUSTOMER_TIME_ANALYTICS as Customer

  association [0..*] to Z02_I_CUSTOMER_BRAND_ANALYTICS as _BrandAnalytics on  $projection.CustomerId      = _BrandAnalytics.CustomerId
                                                                          and $projection.CalendarYear    = _BrandAnalytics.CalendarYear
                                                                          and $projection.CalendarQuarter = _BrandAnalytics.CalendarQuarter
                                                                          and $projection.YearMonth       = _BrandAnalytics.YearMonth
                                                                          and $projection.Currency        = _BrandAnalytics.Currency

{
      @ObjectModel.text.element: [ 'CustomerName' ]
  key Customer.CustomerId,
  key Customer.CalendarYear,
      @ObjectModel.text.element: [ 'QuarterText' ]
  key Customer.CalendarQuarter,
      @ObjectModel.text.element: [ 'MonthText' ]
  key Customer.YearMonth,

  key Customer.Currency,
      Customer.QuarterText,
      Customer.MonthText,

      Customer.CustomerName,

      @Semantics.amount.currencyCode: 'Currency'
      Customer.TotalGrossSales,

      @Semantics.amount.currencyCode: 'Currency'
      Customer.TotalNetSales,

      @Semantics.amount.currencyCode: 'Currency'
      Customer.TotalCancelledValue,

      Customer.TotalItems,
      Customer.CancelledItems,
      Customer.ActiveItems,

      _BrandAnalytics
}
