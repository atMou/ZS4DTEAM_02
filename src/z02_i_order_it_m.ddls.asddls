@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS interface Order Item'

@Metadata.ignorePropagatedAnnotations: false

define view entity z02_i_order_it_m
  as select from z02_a_order_it_m

  association        to parent z02_i_order_m as _Order   on $projection.OrderId = _Order.OrderId
  association [1..1] to z02_i_product_m      as _Product on $projection.ProductId = _Product.ProductId

{
  key order_id               as OrderId,
  key order_item_id          as OrderItemId,

      @ObjectModel.text.element: [ 'ProductName' ]
  key product_id             as ProductId,

      _Product.ProductName   as ProductName,
      _Product.BrandName     as BrandName,

      quantity               as Quantity,
      quantity_unit          as QuantityUnit,
      order_item_total_price as OrderItemTotalPrice,
      currency               as Currency,
      local_created_by       as LocalCreatedBy,
      local_created_at       as LocalCreatedAt,
      local_last_changed_by  as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt,

      last_changed_at        as LastChangedAt,

      _Order,
      _Product
}
