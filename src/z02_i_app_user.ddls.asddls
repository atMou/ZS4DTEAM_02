@Metadata.ignorePropagatedAnnotations: true
@AccessControl.auditing.specification: '...'
@AccessControl.auditing.type: #CUSTOM
define view entity z02_i_app_user
  as select from z02_a_app_user
{
  key id         as Id,
      name       as Name,
      can_create as CanCreate,
      can_delete as CanDelete,
      can_update as CanUpdate,
      can_view   as CanView
}
