@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calendar Quarter Value Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view entity Z02_CAL_QUARTER_VH
  as select from I_CalendarDate
{
      @EndUserText.label: 'Quarter'
      @Search.defaultSearchElement: true
  key YearQuarter
}
