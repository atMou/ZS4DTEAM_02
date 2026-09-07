@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Analytics'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false
@OData.applySupportedForAggregation: #FULL

define root view entity Z02_C_CUSTOMER_ANALYTICS_HUB
  provider contract transactional_query
  as projection on Z02_I_CUSTOMER_ANALYTICS_HUB
{
  key CustomerId,
  key CalendarYear,
  key CalendarQuarter,
  key YearMonth,
  key Currency,


      QuarterText,
      MonthText,
      CustomerName,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      TotalGrossSales,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      TotalNetSales,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      TotalCancelledValue,

      @Aggregation.default: #SUM
      TotalItems,

      @Aggregation.default: #SUM
      CancelledItems,

      @Aggregation.default: #SUM
      ActiveItems,

      _BrandAnalytics : redirected to Z02_C_CUSTOMER_BRAND_ANALYTICS
}
