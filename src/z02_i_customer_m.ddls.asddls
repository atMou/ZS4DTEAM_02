@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'CDS customer interfce'

@Metadata.ignorePropagatedAnnotations: false

define root view entity z02_i_customer_m
  as select from z02_a_customer_m
    
    association [0..*] to z02_i_order_m as _Order
        on $projection.CustomerId = _Order.CustomerId
{
      @ObjectModel.text.element: [ 'CustomerName' ]
  key customer_id                                                              as CustomerId,

      first_name                                                               as FirstName,
      last_name                                                                as LastName,
      title                                                                    as Title,
      concat_with_space(title, concat_with_space(first_name, last_name, 1), 1) as CustomerName,
      street                                                                   as Street,
      postal_code                                                              as PostalCode,
      city                                                                     as City,
      country_code                                                             as CountryCode,
      phone_number                                                             as PhoneNumber,
      email_address                                                            as EmailAddress,
      local_created_by                                                         as LocalCreatedBy,
      local_created_at                                                         as LocalCreatedAt,
      local_last_changed_by                                                    as LocalLastChangedBy,
      local_last_changed_at                                                    as LocalLastChangedAt,
      last_changed_at                                                          as LastChangedAt,
      
      _Order
}
