CLASS lhc_OrderItem DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculateItemValues
      FOR DETERMINE ON MODIFY
      IMPORTING
        keys FOR OrderItem~calculateItemValues.

    METHODS calculateOrderTotal
      FOR DETERMINE ON MODIFY
      IMPORTING
        keys FOR OrderItem~calculateOrderTotal.

    METHODS validateQuantity
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR OrderItem~validateQuantity.

    METHODS validateProduct
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR OrderItem~validateProduct.

    METHODS validateCurrency
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR OrderItem~validateCurrency.

ENDCLASS.


CLASS lhc_OrderItem IMPLEMENTATION.

  METHOD calculateItemValues.
    " NOTE: adjust "z02_a_product_m" / field names to your actual
    " product master table (assumes product_id, price, currency).

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY OrderItem
        FIELDS ( ProductId Quantity )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    IF lt_items IS INITIAL.
      RETURN.
    ENDIF.

    SELECT product_id, price, currency
      FROM z02_a_product_m
      FOR ALL ENTRIES IN @lt_items
      WHERE product_id = @lt_items-ProductId
      INTO TABLE @DATA(lt_products).

    SORT lt_products BY product_id.

    DATA lt_update TYPE TABLE FOR UPDATE z02_i_order_it_m.

    LOOP AT lt_items INTO DATA(ls_item).

      READ TABLE lt_products INTO DATA(ls_product)
        WITH KEY product_id = ls_item-ProductId
        BINARY SEARCH.

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky = ls_item-%tky
          OrderItemTotalPrice = ls_product-price * ls_item-Quantity
          Currency            = ls_product-currency
          %control-OrderItemTotalPrice = if_abap_behv=>mk-on
          %control-Currency            = if_abap_behv=>mk-on
        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF z02_i_order_m IN LOCAL MODE
        ENTITY OrderItem
          UPDATE FIELDS ( OrderItemTotalPrice Currency )
          WITH lt_update.

    ENDIF.

  ENDMETHOD.


METHOD calculateOrderTotal.

  READ ENTITIES OF z02_i_order_m IN LOCAL MODE
    ENTITY OrderItem BY \_Order
      FROM CORRESPONDING #( keys )
      LINK DATA(lt_item_order_links).

  IF lt_item_order_links IS INITIAL.
    RETURN.
  ENDIF.

  DATA(lt_order_keys) = lt_item_order_links.
  SORT lt_order_keys BY target-OrderId target-%is_draft.
  DELETE ADJACENT DUPLICATES FROM lt_order_keys
    COMPARING target-OrderId target-%is_draft.

  DATA lt_orders_to_update TYPE TABLE FOR UPDATE z02_i_order_m.

  LOOP AT lt_order_keys INTO DATA(ls_order_key).

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order BY \_order_item
        FIELDS ( OrderItemTotalPrice )
        WITH VALUE #( ( %tky = ls_order_key-target-%tky ) )
      RESULT DATA(lt_sibling_items).

    DATA lv_total TYPE p LENGTH 15 DECIMALS 2.
    CLEAR lv_total.

    LOOP AT lt_sibling_items INTO DATA(ls_sibling).
      lv_total += ls_sibling-OrderItemTotalPrice.
    ENDLOOP.

    APPEND VALUE #(
      %tky      = ls_order_key-target-%tky
      TotalCost = lv_total
      %control-TotalCost = if_abap_behv=>mk-on
    ) TO lt_orders_to_update.

  ENDLOOP.

  IF lt_orders_to_update IS NOT INITIAL.

    MODIFY ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order
        UPDATE FIELDS ( TotalCost )
        WITH lt_orders_to_update.

  ENDIF.

ENDMETHOD.

  METHOD validateQuantity.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY OrderItem
        FIELDS ( Quantity )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).

      IF ls_item-Quantity <= 0.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-orderitem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Quantity must be greater than zero'
          )
          %element-Quantity = if_abap_behv=>mk-on
        ) TO reported-orderitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validateProduct.
    " NOTE: adjust "z02_a_product_m" to your actual product master table.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY OrderItem
        FIELDS ( ProductId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    IF lt_items IS INITIAL.
      RETURN.
    ENDIF.

    SELECT product_id
      FROM z02_a_product_m
      FOR ALL ENTRIES IN @lt_items
      WHERE product_id = @lt_items-ProductId
      INTO TABLE @DATA(lt_products).

    SORT lt_products BY product_id.

    LOOP AT lt_items INTO DATA(ls_item).

      IF ls_item-ProductId IS INITIAL.
        CONTINUE. " already enforced as mandatory on create
      ENDIF.

      READ TABLE lt_products
        WITH KEY product_id = ls_item-ProductId
        TRANSPORTING NO FIELDS
        BINARY SEARCH.

      IF sy-subrc <> 0.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-orderitem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = |Product { ls_item-ProductId } does not exist|
          )
          %element-ProductId = if_abap_behv=>mk-on
        ) TO reported-orderitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validateCurrency.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY OrderItem
        FIELDS ( Currency )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).

      IF ls_item-Currency IS INITIAL.

        APPEND VALUE #( %tky = ls_item-%tky ) TO failed-orderitem.

        APPEND VALUE #(
          %tky = ls_item-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Currency is required'
          )
          %element-Currency = if_abap_behv=>mk-on
        ) TO reported-orderitem.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
