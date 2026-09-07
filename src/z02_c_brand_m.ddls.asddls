@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS brand projection interface'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity Z02_C_BRAND_M
  provider contract transactional_query
  as projection on z02_i_brand_m
{
  key BrandId,
      BrandName,
      BrandDescription,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
