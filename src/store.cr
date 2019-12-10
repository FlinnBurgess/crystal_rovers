require "rover"

class Store
  def self.rovers
    @@rovers || (@@rovers = {} of String => Rover)
  end

  def self.mutex
    @@mutex || (@@mutex = Mutex.new)
  end

  def self.create(name)
    mutex.synchronize do
      rovers[name] = Rover.new
    end
  end

  def self.delete(name)
    mutex.synchronize do
      rovers.delete(name)
    end
  end

  def self.get(name)
    mutex.synchronize do
      rovers[name]
    end
  end

  def self.move(name, move)
    mutex.synchronize do
      moves = move.split("").map { |m| translate_move(m) }
      rovers[name].move(moves)
      rovers[name].status
    end
  end

  def self.translate_move(move)
    case move
    when "l", "L"
      Left
    when "r", "R"
      Right
    else
      Forward
    end
  end

  def self.pretty(name)
    rovers[name].status
  end
end
