class Zip
  attr_reader :id, :max_deliveries, :max_range
  attr_accessor :in_use, :return_time, :orders

  def initialize(id:, max_deliveries:, max_range:)
    @id = id
    @max_deliveries = max_deliveries
    @max_range = max_range
    @orders = []
  end

  def dispatch(time)
    orders.map(&:dispatch)
    @return_time = time
  end

  def available
    in_use != true
  end

  def has_capacity
    orders.count < max_deliveries
  end

  def add_deliverable(order)
    if orders.length >= 3
      false
    end

    orders << order
    order.dispatch
  end
end
