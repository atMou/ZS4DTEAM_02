CLASS lhc_Order DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features
      FOR INSTANCE FEATURES
      IMPORTING
        keys REQUEST requested_features FOR Order
      RESULT
        result.

    METHODS earlynumbering_create
      FOR NUMBERING
      IMPORTING
        entities FOR CREATE Order.

    METHODS earlynumbering_cba_order_item
      FOR NUMBERING
      IMPORTING
        entities FOR CREATE Order\_order_item.

    METHODS setInitialValues
      FOR DETERMINE ON MODIFY
      IMPORTING
        keys FOR Order~setInitialValues.

    METHODS validateCustomer
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR Order~validateCustomer.

    METHODS nextStatus
      FOR MODIFY
      IMPORTING
        keys FOR ACTION Order~nextStatus
      RESULT
        result.

    METHODS cancelOrder
      FOR MODIFY
      IMPORTING
        keys FOR ACTION Order~cancelOrder
      RESULT
        result.

    METHODS openAnalytics
      FOR MODIFY
      IMPORTING
        keys FOR ACTION Order~openAnalytics.

ENDCLASS.


CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( StatusId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    result = VALUE #(
      FOR ls_order IN lt_orders
      (
        %tky = ls_order-%tky

        %action-nextStatus =
          COND #(
            WHEN ls_order-StatusId = 3
              OR ls_order-StatusId = 4
            THEN if_abap_behv=>fc-o-disabled
            ELSE if_abap_behv=>fc-o-enabled
          )

        %action-cancelOrder =
          COND #(
            WHEN ls_order-StatusId = 3
              OR ls_order-StatusId = 4
            THEN if_abap_behv=>fc-o-disabled
            ELSE if_abap_behv=>fc-o-enabled
          )
      )
    ).

  ENDMETHOD.


METHOD earlynumbering_create.


  SELECT SINGLE FROM z02_i_order_m
    FIELDS MAX( OrderId ) AS max_id
    INTO @DATA(lv_max_order_id).

  LOOP AT entities INTO DATA(ls_entity).

    IF ls_entity-OrderId IS NOT INITIAL.

      APPEND VALUE #(
        %cid      = ls_entity-%cid
        %is_draft = ls_entity-%is_draft
        OrderId   = ls_entity-OrderId
      ) TO mapped-order.

      CONTINUE.

    ENDIF.

    lv_max_order_id += 1.

    APPEND VALUE #(
      %cid      = ls_entity-%cid
      %is_draft = ls_entity-%is_draft
      OrderId   = lv_max_order_id
    ) TO mapped-order.

  ENDLOOP.

ENDMETHOD.


METHOD earlynumbering_cba_order_item.

  READ ENTITIES OF z02_i_order_m IN LOCAL MODE
    ENTITY Order BY \_order_item
      FROM CORRESPONDING #( entities )
      LINK DATA(lt_existing_links).

  LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_order>).

    DATA(lv_max_item) = CONV z02_i_order_it_m-OrderItemId( 0 ).

    LOOP AT lt_existing_links INTO DATA(ls_link)
      WHERE source-OrderId = <ls_order>-OrderId.

      IF ls_link-target-OrderItemId > lv_max_item.
        lv_max_item = ls_link-target-OrderItemId.
      ENDIF.

    ENDLOOP.

    IF lv_max_item IS INITIAL.

      " Again: CDS view, not physical table.
      SELECT SINGLE FROM z02_i_order_it_m
        FIELDS MAX( OrderItemId ) AS max_id
        WHERE OrderId = @<ls_order>-OrderId
        INTO @lv_max_item.

    ENDIF.

    LOOP AT <ls_order>-%target ASSIGNING FIELD-SYMBOL(<ls_target>).

      IF <ls_target>-OrderItemId > lv_max_item.
        lv_max_item = <ls_target>-OrderItemId.
      ENDIF.

    ENDLOOP.

    LOOP AT <ls_order>-%target ASSIGNING <ls_target>.

      APPEND CORRESPONDING #( <ls_target> )
        TO mapped-orderitem
        ASSIGNING FIELD-SYMBOL(<ls_mapped>).

      IF <ls_target>-OrderItemId IS INITIAL.

        lv_max_item += 10.

        <ls_mapped>-OrderItemId = lv_max_item.

      ENDIF.

      <ls_mapped>-OrderId = <ls_order>-OrderId.

    ENDLOOP.

  ENDLOOP.

ENDMETHOD.


  METHOD setInitialValues.

    MODIFY ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order
        UPDATE FIELDS (
          StatusId
          TotalCost
        )
        WITH VALUE #(
          FOR ls_key IN keys
          (
            %tky = ls_key-%tky

            StatusId  = 0
            TotalCost = 0

            %control-StatusId  = if_abap_behv=>mk-on
            %control-TotalCost = if_abap_behv=>mk-on
          )
        ).

  ENDMETHOD.


  METHOD validateCustomer.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( CustomerId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    IF lt_orders IS INITIAL.
      RETURN.
    ENDIF.

    SELECT customer_id
      FROM z02_a_customer_m
      FOR ALL ENTRIES IN @lt_orders
      WHERE customer_id = @lt_orders-CustomerId
      INTO TABLE @DATA(lt_customers).

    SORT lt_customers BY customer_id.

    LOOP AT lt_orders INTO DATA(ls_order).

      IF ls_order-CustomerId IS INITIAL.

        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.

        APPEND VALUE #(
          %tky = ls_order-%tky

          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Customer is required'
          )

          %element-CustomerId = if_abap_behv=>mk-on
        ) TO reported-order.

        CONTINUE.

      ENDIF.

      READ TABLE lt_customers
        WITH KEY customer_id = ls_order-CustomerId
        TRANSPORTING NO FIELDS
        BINARY SEARCH.

      IF sy-subrc <> 0.

        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.

        APPEND VALUE #(
          %tky = ls_order-%tky

          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = |Customer { ls_order-CustomerId } does not exist|
          )

          %element-CustomerId = if_abap_behv=>mk-on
        ) TO reported-order.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD nextStatus.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( StatusId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    DATA lt_update TYPE TABLE FOR UPDATE z02_i_order_m.

    LOOP AT lt_orders INTO DATA(ls_order).

      DATA lv_new_status LIKE ls_order-StatusId.

      CASE ls_order-StatusId.

        WHEN 0.
          lv_new_status = 1.

        WHEN 1.
          lv_new_status = 2.

        WHEN 2.
          lv_new_status = 3.

        WHEN 3.

          APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.

          APPEND VALUE #(
            %tky = ls_order-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = 'Delivered orders cannot be advanced'
            )
          ) TO reported-order.

          CONTINUE.

        WHEN 4.

          APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.

          APPEND VALUE #(
            %tky = ls_order-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = 'Cancelled orders cannot be advanced'
            )
          ) TO reported-order.

          CONTINUE.

        WHEN OTHERS.

          APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.

          APPEND VALUE #(
            %tky = ls_order-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = 'Invalid order status'
            )
          ) TO reported-order.

          CONTINUE.

      ENDCASE.

      APPEND VALUE #(
        %tky = ls_order-%tky
        StatusId = lv_new_status
        %control-StatusId = if_abap_behv=>mk-on
      ) TO lt_update.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF z02_i_order_m IN LOCAL MODE
        ENTITY Order
          UPDATE FIELDS ( StatusId )
          WITH lt_update.

    ENDIF.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #(
      FOR ls_result IN lt_result
      (
        %tky   = ls_result-%tky
        %param = ls_result
      )
    ).

  ENDMETHOD.


  METHOD cancelOrder.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order
        FIELDS ( StatusId )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    DATA lt_update TYPE TABLE FOR UPDATE z02_i_order_m.

    LOOP AT lt_orders INTO DATA(ls_order).

      IF ls_order-StatusId = 3.

        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.

        APPEND VALUE #(
          %tky = ls_order-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Delivered orders cannot be cancelled'
          )
        ) TO reported-order.

        CONTINUE.

      ENDIF.

      IF ls_order-StatusId = 4.

        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-order.

        APPEND VALUE #(
          %tky = ls_order-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Order is already cancelled'
          )
        ) TO reported-order.

        CONTINUE.

      ENDIF.

      APPEND VALUE #(
        %tky = ls_order-%tky
        StatusId = 4
        %control-StatusId = if_abap_behv=>mk-on
      ) TO lt_update.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.

      MODIFY ENTITIES OF z02_i_order_m IN LOCAL MODE
        ENTITY Order
          UPDATE FIELDS ( StatusId )
          WITH lt_update.

    ENDIF.

    READ ENTITIES OF z02_i_order_m IN LOCAL MODE
      ENTITY Order
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #(
      FOR ls_result IN lt_result
      (
        %tky   = ls_result-%tky
        %param = ls_result
      )
    ).

  ENDMETHOD.


  METHOD openAnalytics.

    LOOP AT keys INTO DATA(ls_key).

      APPEND VALUE #(
        %cid = ls_key-%cid
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-information
          text     = 'Analytics navigation is handled by the Fiori application'
        )
      ) TO reported-order.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
