@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bottom Customer Analytics'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false
@OData.applySupportedForAggregation: #FULL

define root view entity Z02_C_BOTTOM_CUST_ANALYTICS
  provider contract transactional_query
  as projection on Z02_I_CUSTOMER_TOTAL_ANALYTICS
{
  key CustomerId,
  key Currency,

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
      ActiveItems
}
