@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS projection view'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false

@Search.searchable: true

define view entity z02_c_order_it_m
  as projection on z02_i_order_it_m

{
  key OrderId,
  key OrderItemId,
  key ProductId,
      ProductName,
      BrandName,

      @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
      Quantity,

      QuantityUnit,

      @Semantics.amount.currencyCode: 'Currency'
      OrderItemTotalPrice,

      Currency,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _Order : redirected to parent z02_c_order_m,

      _Product
}
