CLASS z02_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS z02_runner IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*    DATA lt_users TYPE STANDARD TABLE OF z02_a_app_user WITH EMPTY KEY.
*
*    lt_users = VALUE #(
*      (
*        id         = 'CB9980000002'
*        name       = 'Yilmaz Uslu'
*        can_create = '00'
*        can_delete = '00'
*        can_update = '00'
*        can_view   = '00'
*      )
*      (
*        id         = 'CB9980000011'
*        name       = 'Stefan Breidenbach'
*        can_create = '01'
*        can_delete = '01'
*        can_update = '01'
*        can_view   = '00'
*      )
*      (
*        id         = 'CB9980000020'
*        name       = 'Volodymyr Holodivskyi'
*        can_create = '00'
*        can_delete = '00'
*        can_update = '00'
*        can_view   = '00'
*      )
*      (
*        id         = 'CB9980000023'
*        name       = 'Moustafa Ahmed'
*        can_create = '00'
*        can_delete = '00'
*        can_update = '00'
*        can_view   = '00'
*      )
*      (
*        id         = 'CB9980000024'
*        name       = 'Wassim Kebak'
*        can_create = '00'
*        can_delete = '00'
*        can_update = '00'
*        can_view   = '00'
*      )
*    ).
*
*    INSERT z02_a_app_user
*      FROM TABLE @lt_users
*      ACCEPTING DUPLICATE KEYS.
*
*    out->write( |Inserted: { sy-dbcnt } application user rows.| ).

  ENDMETHOD.
ENDCLASS.
