@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Brand Value Help'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

define view entity Z02_BRAND_VH
  as select from z02_i_brand_m
{
      @ObjectModel.text.element: [ 'BrandName' ]
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Brand'
  key BrandId,

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Brand Name'
      BrandName,

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Description'
      BrandDescription
}
