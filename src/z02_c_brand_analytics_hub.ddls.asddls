@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Brand Analytics'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false
@OData.applySupportedForAggregation: #FULL

define root view entity Z02_C_BRAND_ANALYTICS_HUB
  provider contract transactional_query
  as projection on Z02_I_BRAND_ANALYTICS_HUB
{
  key BrandId,
  key Currency,

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
      ActiveItems,

      _TimeAnalytics         : redirected to Z02_C_BRAND_TIME_ANALYTICS,

      _CustomerSummary       : redirected to Z02_C_CUSTOMER_BRAND_SUMMARY,

      _CustomerTimeAnalytics : redirected to Z02_C_CUSTOMER_BRAND_ANALYTICS
}
