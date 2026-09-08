@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Customer projection interface'
@Metadata.ignorePropagatedAnnotations: true

@Metadata.allowExtensions: true

define root view entity Z02_C_CUSTOMER_M
  provider contract transactional_query
  as projection on z02_i_customer_m
{
  key CustomerId,
      FirstName,
      LastName,
      Title,
      CustomerName,
      Street,
      PostalCode,
      City,
      CountryCode,
      PhoneNumber,
      EmailAddress,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,
      /* Associations */
      _Order
}
