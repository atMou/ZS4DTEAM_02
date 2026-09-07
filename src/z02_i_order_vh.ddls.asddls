@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view entity Z02_I_ORDER_VH
  as select from z02_i_order_m
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Order'
  key OrderId,

      @Search.defaultSearchElement: true
      @EndUserText.label: 'Customer'
      CustomerName,

      @EndUserText.label: 'Status'
      OrderStatusText
}
