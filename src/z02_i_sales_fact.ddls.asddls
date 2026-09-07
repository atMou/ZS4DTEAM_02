@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Sales Analytics Fact'

@Metadata.ignorePropagatedAnnotations: true

define view entity Z02_I_SALES_FACT
  as select from Z02_I_SALES_BASE

  association [0..1] to I_CalendarDate as _Calendar on $projection.OrderDate = _Calendar.CalendarDate

{
  key OrderId,
  key OrderItemId,
  key ProductId,

      CustomerId,
      CustomerName,
      ProductName,
      BrandId,
      BrandName,
      StatusId,
      OrderStatusText,
      OrderDate,

      _Calendar.CalendarYear    as CalendarYear,

      _Calendar.CalendarQuarter as CalendarQuarter,

      case _Calendar.CalendarQuarter
        when '1' then '1. Quartal'
        when '2' then '2. Quartal'
        when '3' then '3. Quartal'
        when '4' then '4. Quartal'
        else ''
      end                       as QuarterText,

      _Calendar.CalendarMonth   as CalendarMonth,

      case _Calendar.CalendarMonth
        when '01' then 'Januar'
        when '02' then 'Februar'
        when '03' then 'März'
        when '04' then 'April'
        when '05' then 'Mai'
        when '06' then 'Juni'
        when '07' then 'Juli'
        when '08' then 'August'
        when '09' then 'September'
        when '10' then 'Oktober'
        when '11' then 'November'
        when '12' then 'Dezember'
        else ''
      end                       as MonthText,

      _Calendar.YearMonth       as YearMonth,

      Currency,

      @Semantics.amount.currencyCode: 'Currency'
      cast(
        ItemSalesAmount as abap.dec(23,2)
      )                         as GrossSales,

      @Semantics.amount.currencyCode: 'Currency'
      cast(
        case
          when StatusId = 4
            then ItemSalesAmount - ItemSalesAmount
          else ItemSalesAmount
        end
        as abap.dec(23,2)
      )                         as NetSales,

      @Semantics.amount.currencyCode: 'Currency'
      cast(
        case
          when StatusId = 4
            then ItemSalesAmount
          else ItemSalesAmount - ItemSalesAmount
        end
        as abap.dec(23,2)
      )                         as CancelledValue,

      cast(
        1 as abap.int8
      )                         as ItemCount,

      cast(
        case
          when StatusId = 4 then 1
          else 0
        end
        as abap.int8
      )                         as CancelledItemCount,

      cast(
        case
          when StatusId = 4 then 0
          else 1
        end
        as abap.int8
      )                         as ActiveItemCount,

      _Calendar
}
