class DropoffPoint
  attr_reader :north, :east, :deliverable

  def initialize(north:, east:, deliverable:)
    @north = north
    @east = east
    @deliverable = deliverable
  end
end
