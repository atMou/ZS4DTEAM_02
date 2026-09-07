@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Umsatz und Anzahl Bestellungen je Kunde'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: false

define view entity z02_i_order_report
  as select from z02_a_order_m

  association [1..1] to z02_i_customer_m as _Customer on $projection.CustomerId = _Customer.CustomerId


  //  association [0..*] to Z02_I_ORDERS_REPORT as _Orders   on  $projection.CustomerId = _Orders.CustomerId
  //                                                         and $projection.Currency   = _Orders.Currency

{
      @ObjectModel.text.element: [ 'CustomerName' ]
  key customer_id            as CustomerId,

  key currency               as Currency,

      _Customer.CustomerName as CustomerName,

      @Semantics.amount.currencyCode: 'Currency'
      sum(total_cost)        as Umsatz,

      count(*)               as AnzahlBestellungen,

      _Customer
      //      _Orders
}
where
  cast( order_status_id as Z02_ORDER_STATUS_ID_T ) != Z02_ORDER_STATUS_ID_T.#Cancelled
group by
  customer_id,
  _Customer.CustomerName,
  currency
