@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS product projection interface'
@Metadata.ignorePropagatedAnnotations: false
define root view entity Z02_C_PRODUCT_M
  provider contract transactional_query
  as projection on z02_i_product_m
{
  key ProductId,
      BrandId,
      BrandName,
      ProductName,
      FillingVolume,
      FillingUnit,
      Price,
      Currency,
      Availablity,
      AvailabilityUnit,
      MaxAvailability,
      AvailabilityIndicator,
      AvailabilityCriticality,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _Brand
}
