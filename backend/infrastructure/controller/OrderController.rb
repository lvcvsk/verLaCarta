require 'json'

class OrderController
  def initialize(make_order_action, accept_order_action, mark_order_as_ready_action, delete_order_action, get_order_action, get_store_orders_action, codec)
    @make_order_action = make_order_action
    @get_order_action = get_order_action
    @get_store_orders_action = get_store_orders_action
    @accept_order_action = accept_order_action
    @make_order_as_ready_action = mark_order_as_ready_action
    @delete_order_action = delete_order_action
    @codec = codec
  end

  def make_order(store_id, encoded_request)
    decoded_request = @codec.decode_order_creation(encoded_request)
    result = @make_order_action.invoke(store_id, decoded_request.table_id, decoded_request.amount_by_item, decoded_request.coordinates, decoded_request.takeaway)
    @codec.encode_order_result(result)
  end

  def get_order(store_id, order_id)
    order = @get_order_action.invoke(store_id, order_id)
    @codec.encode_order(order)
  end

  def get_store_orders(store_id)
    orders = @get_store_orders_action.invoke(store_id)
    @codec.encode_orders(orders)
  end

  def accept_order(store_id, request)
    table_id = @codec.decode_table_id(request)
    @accept_order_action.invoke(store_id, table_id)
  end

  def mark_order_as_ready(store_id, request)
    order_id = @codec.decode_order_id(request)
    @mark_order_as_ready_action.invoke(store_id, order_id)
  end

  def delete_order(store_id, request)
    order_id = @codec.decode_order_id(request)
    @delete_order_action.invoke(store_id, order_id)
  end
end