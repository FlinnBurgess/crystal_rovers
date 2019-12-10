require "./*"

class Rover
  property position : Point, orientation : Orientation

  def initialize
    @position = Point.new(0, 0)
    @orientation = North.new
  end

  def initialize(orientation, x, y)
    @position = Point.new(x, y)

    case orientation
    when "N"
      @orientation = North.new
    when "S"
      @orientation = South.new
    when "E"
      @orientation = East.new
    when "W"
      @orientation = West.new
    else
      @orientation = North.new
    end
  end

  def turn(direction : Direction) : Rover
    @orientation = @orientation.turn(direction)
    self
  end

  def advance : Rover
    @position = @position.move(*@orientation.forward_vector)
    self
  end

  def status : String
    "#{@orientation.class} (#{@position.x}, #{@position.y})"
  end

  def move(direction : Direction) : Rover
    self.turn direction
  end

  def move(advance : Forward.class) : Rover
    self.advance
  end

  def move(commands : Array(Command)) : Rover
    commands.reduce(self) do |r, move|
      self.move(move)
      self
    end
  end
end
