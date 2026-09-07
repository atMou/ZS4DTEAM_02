@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS interface product'

@Metadata.ignorePropagatedAnnotations: false

define root view entity z02_i_product_m
  as select from z02_a_product_m

  association [1] to z02_i_brand_m as _Brand on $projection.BrandId = _Brand.BrandId

{
  key product_id            as ProductId,

      @ObjectModel.text.element: [ 'BrandName' ]
      brand_id              as BrandId,

      _Brand.BrandName      as BrandName,

      product_name          as ProductName,


      @Semantics.quantity.unitOfMeasure: 'FillingUnit'
      filling_volume        as FillingVolume,


      filling_unit          as FillingUnit,


      @Semantics.amount.currencyCode: 'Currency'
      price                 as Price,


      currency              as Currency,


      @Semantics.quantity.unitOfMeasure: 'AvailabilityUnit'
      availablity           as Availablity,

     
      availability_unit     as AvailabilityUnit,

      @Semantics.quantity.unitOfMeasure: 'AvailabilityUnit'
      max_availability      as MaxAvailability,


      case

        when max_availability = 0
          then 'LOW'

        when availablity * 100
             <= max_availability * 20
          then 'LOW'

        when availablity * 100
             <= max_availability * 60
          then 'MEDIUM'

        else 'HIGH'

      end                   as AvailabilityIndicator,


      case

        when max_availability = 0
          then 1

        when availablity * 100
             <= max_availability * 20
          then 1

        when availablity * 100
             <= max_availability * 60
          then 2

        else 3

      end                   as AvailabilityCriticality,


      local_created_by      as LocalCreatedBy,

      local_created_at      as LocalCreatedAt,

      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      last_changed_at       as LastChangedAt,


      _Brand
}
