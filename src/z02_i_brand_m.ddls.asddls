@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS interface brand'

@Metadata.ignorePropagatedAnnotations: false

define root view entity z02_i_brand_m
  as select from z02_a_brand_m

{
      @ObjectModel.text.element: [ 'BrandName' ]
  key brand_id              as BrandId,

      brand_name            as BrandName,
      brand_description     as BrandDescription,
      local_created_by      as LocalCreatedBy,
      local_created_at      as LocalCreatedAt,
      local_last_changed_by as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      last_changed_at       as LastChangedAt
}
