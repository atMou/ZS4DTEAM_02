@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS interface Order'

@Metadata.ignorePropagatedAnnotations: false

define root view entity z02_i_order_m
  as select from z02_a_order_m

  composition [0..*] of z02_i_order_it_m              as _order_item

  association [1]    to z02_i_customer_m                 as _Customer             on  $projection.CustomerId = _Customer.CustomerId

  association [1]    to z02_i_app_user                   as _user                 on  $projection.LocalCreatedBy = _user.Id

  association [0..*] to z02_i_order_report            as _report                  on  $projection.CustomerId = _report.CustomerId

  association [1..*] to z02_order_st                  as _orderStatus             on  $projection.StatusId = _orderStatus.order_status_id

  association [0..*] to Z02_I_ORDERS_REPORT           as _report_orders           on  $projection.CustomerId = _report_orders.CustomerId
                                                                                  and $projection.Currency   = _report_orders.Currency

  association [0..*] to Z02_I_ORDERS_REPORT_CANCELLED as _report_orders_cancelled on  $projection.CustomerId = _report_orders_cancelled.CustomerId
                                                                                  and $projection.Currency   = _report_orders_cancelled.Currency

{
  key order_id                                                               as OrderId,

      @ObjectModel.text: { association: '_Customer',
                           element: [ 'CustomerName' ] }

      customer_id                                                            as CustomerId,

      _Customer.CustomerName                                                 as CustomerName,

      @ObjectModel.text.element: [ 'OrderStatusText' ]
      order_status_id                                                        as StatusId,

      _orderStatus[1: language = $session.system_language].order_status_text as OrderStatusText,

      case order_status_id
      when 0 then 0
      when 1 then 2
      when 2 then 3
      when 3 then 3
      when 4 then 1
      else 0
      end                                                                    as StatusCriticality,

      concat_with_space(
      concat_with_space(concat(_Customer.Street, ' ,'),
       _Customer.City, 1), _Customer.PostalCode, 1)                          as Address,

      total_cost                                                             as TotalCost,
      currency                                                               as Currency,

      @ObjectModel.text: { association: '_user',
                           element: [ 'UserName' ] }
      @Semantics.user.createdBy: true
      local_created_by                                                       as LocalCreatedBy,


      _user.Name                                                             as UserName,

      @Semantics.systemDateTime.createdAt: true
      local_created_at                                                       as LocalCreatedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_by                                                  as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                                                  as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                                        as LastChangedAt,

      _Customer,
      _order_item,
      _user,
      _report,
      _report_orders,
      _orderStatus,
      _report_orders_cancelled
}
