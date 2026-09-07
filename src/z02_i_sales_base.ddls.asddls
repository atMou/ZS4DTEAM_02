@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Analytics Base'
@Metadata.ignorePropagatedAnnotations: false

define view entity Z02_I_SALES_BASE
  as select from z02_i_order_it_m as Item
{
  key Item.OrderId,
  key Item.OrderItemId,
  key Item.ProductId,

      Item._Order.CustomerId      as CustomerId,
      Item._Order.CustomerName    as CustomerName,
      Item.ProductName            as ProductName,
      Item._Product.BrandId       as BrandId,
      Item._Product.BrandName     as BrandName,
      Item._Order.StatusId        as StatusId,
      Item._Order.OrderStatusText as OrderStatusText,
      Item.Currency               as Currency,

      @Semantics.amount.currencyCode: 'Currency'
      Item.OrderItemTotalPrice    as ItemSalesAmount,

      tstmp_to_dats(
        Item._Order.LocalCreatedAt,
        abap_system_timezone($session.client,'NULL'),
        $session.client,
        'NULL'
      )                           as OrderDate
}
