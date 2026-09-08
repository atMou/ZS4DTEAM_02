@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Analytics'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false
@OData.applySupportedForAggregation: #FULL

define root view entity Z02_C_ORDER_ANALYTICS
  provider contract transactional_query
  as projection on Z02_I_ORDER_ANALYTICS
{
  key OrderId,
  key Currency,

      CustomerId,
      CustomerName,

      StatusId,
      OrderStatusText,

      OrderDate,
      CalendarYear,
      CalendarQuarter,
      CalendarMonth,
      YearMonth,
      MonthText,
      QuarterText,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      GrossOrderValue,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      NetSales,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      CancelledValue,

      @Aggregation.default: #SUM
      OrderCount,

      @Aggregation.default: #SUM
      CancelledOrderCount,

      @Aggregation.default: #SUM
      ItemCount,

      @Aggregation.default: #SUM
      CancelledItemCount,

      @Aggregation.default: #SUM
      ActiveItemCount
}
