@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calendar Year Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view entity Z02_CAL_YEAR_VH
  as select from I_CalendarDate
{
      @EndUserText.label: 'Year'
      @Search.defaultSearchElement: true
  key CalendarYear
}
group by
  CalendarYear
having
  CalendarYear > '2000'
