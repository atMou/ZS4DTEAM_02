@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Analytics'
@Metadata.ignorePropagatedAnnotations: true

define root view entity Z02_I_ORDER_ANALYTICS
  as select from Z02_I_SALES_FACT
{
  key OrderId,
  key Currency,

      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      CustomerName,

      @ObjectModel.text.element: [ 'OrderStatusText' ]
      StatusId,
      OrderStatusText,

      OrderDate,
      CalendarYear,
      @ObjectModel.text.element: [ 'QuarterText' ]
      CalendarQuarter,

      CalendarMonth,
      @ObjectModel.text.element: [ 'MonthText' ]
      YearMonth,
      MonthText,
      QuarterText,


      @Semantics.amount.currencyCode: 'Currency'
      sum( GrossSales )         as GrossOrderValue,

      @Semantics.amount.currencyCode: 'Currency'
      sum( NetSales )           as NetSales,

      @Semantics.amount.currencyCode: 'Currency'
      sum( CancelledValue )     as CancelledValue,

      cast( 1 as abap.int8 )    as OrderCount,

      cast(
        case
          when StatusId = 4 then 1
          else 0
        end
        as abap.int8
      )                         as CancelledOrderCount,

      sum( ItemCount )          as ItemCount,

      sum( CancelledItemCount ) as CancelledItemCount,

      sum( ActiveItemCount )    as ActiveItemCount
}
group by
  OrderId,
  Currency,
  CustomerId,
  CustomerName,
  StatusId,
  OrderStatusText,
  OrderDate,
  CalendarYear,
  CalendarQuarter,
  CalendarMonth,
  YearMonth,
  MonthText,
  QuarterText
