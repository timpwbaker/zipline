class Hospital
  attr_accessor :name, :north, :east

  def initialize(name:, north:, east:)
    @name = name
    @north = north
    @east = east
  end
end
