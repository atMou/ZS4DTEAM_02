@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calendar Month Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view entity Z02_CAL_MONTH_VH
  as select from I_CalendarDate
{
      @EndUserText.label: 'Year / Month'
      @Search.defaultSearchElement: true
  key YearMonth
}
