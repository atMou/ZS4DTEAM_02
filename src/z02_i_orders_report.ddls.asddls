@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Orders for Umsatzbericht'
@Metadata.allowExtensions: true

define view entity Z02_I_ORDERS_REPORT
  as select from z02_i_order_m
  association [0..*] to z02_order_status_vh as _order_status_vh on $projection.StatusId = _order_status_vh.OrderStatusId
{
  key OrderId,
      CustomerId,
      CustomerName,
      StatusId,
      StatusCriticality,
      OrderStatusText,
      Currency,
      TotalCost,

      _order_status_vh

}
where
  StatusId != 4
