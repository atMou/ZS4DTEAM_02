@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'Consumption order cds'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false

@Search.searchable: true

define root view entity z02_c_order_m
  as projection on z02_i_order_m


{
  key OrderId,

      CustomerId,
      CustomerName,
      StatusId,
      OrderStatusText,


      StatusCriticality,
      TotalCost,
      Currency,
      LocalCreatedBy,
      UserName,
      Address,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,


      _Customer,
      _order_item : redirected to composition child z02_c_order_it_m,
      _user,
      _report,
      _report_orders,
      _orderStatus,
      _report_orders_cancelled

}
