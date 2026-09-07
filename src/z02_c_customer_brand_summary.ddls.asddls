@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Customer Brand Summary'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false

@OData.applySupportedForAggregation: #FULL

define root view entity Z02_C_CUSTOMER_BRAND_SUMMARY
  provider contract transactional_query
  as projection on Z02_I_CUSTOMER_BRAND_SUMMARY

{
  key CustomerId,
  key BrandId,
  key Currency,

      CustomerName,
      BrandName,

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
