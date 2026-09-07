@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Brand Analytics Hub'
@Metadata.ignorePropagatedAnnotations: true

define root view entity Z02_I_BRAND_ANALYTICS_HUB
  as select from Z02_I_BRAND_ANALYTICS as Brand

  association [0..*] to Z02_I_BRAND_TIME_ANALYTICS     as _TimeAnalytics         on  $projection.BrandId  = _TimeAnalytics.BrandId
                                                                                 and $projection.Currency = _TimeAnalytics.Currency

  association [0..*] to Z02_I_CUSTOMER_BRAND_SUMMARY   as _CustomerSummary       on  $projection.BrandId  = _CustomerSummary.BrandId
                                                                                 and $projection.Currency = _CustomerSummary.Currency

  association [0..*] to Z02_I_CUSTOMER_BRAND_ANALYTICS as _CustomerTimeAnalytics on  $projection.BrandId  = _CustomerTimeAnalytics.BrandId
                                                                                 and $projection.Currency = _CustomerTimeAnalytics.Currency

{
      @ObjectModel.text.element: [ 'BrandName' ]

  key Brand.BrandId,
  key Brand.Currency,

      Brand.BrandName,

      @Semantics.amount.currencyCode: 'Currency'
      Brand.TotalGrossSales,

      @Semantics.amount.currencyCode: 'Currency'
      Brand.TotalNetSales,

      @Semantics.amount.currencyCode: 'Currency'
      Brand.TotalCancelledValue,

      Brand.TotalItems,
      Brand.CancelledItems,
      Brand.ActiveItems,

      _TimeAnalytics,
      _CustomerSummary,
      _CustomerTimeAnalytics
}
