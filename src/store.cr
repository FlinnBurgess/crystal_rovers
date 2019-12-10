require "./rover"
require "sqlite3"

class Store
  def self.rovers
    @@rovers || (@@rovers = {} of String => Rover)
  end

  def self.mutex
    @@mutex || (@@mutex = Mutex.new)
  end

  def self.create(name)
    mutex.synchronize do
      DB.open "sqlite3://./rovers.db" do |db|
        db.exec "create table if not exists rovers (name text, x integer, y integer, orientation text)"
        db.exec "insert into rovers values (?, ?, ?, ?)", name, 0, 0, "N"
      end
    end
  end

  def self.delete(name)
    mutex.synchronize do
      DB.open "sqlite3://./rovers.db" do |db|
        db.exec "delete from rovers  where name=?", name
      end
    end
  end

  def self.get(name)
    mutex.synchronize do
      DB.open "sqlite3://./rovers.db" do |db|
        query_string = "select x, y, orientation from rovers where name=?"
        result = db.query_one query_string, name, as: {x: Int32, y: Int32, orientation: String}
        Rover.new(result["orientation"], result.["x"], result.["y"])
      end
    end
  end

  def self.update(name, rover)
    mutex.synchronize do
      x = rover.position.x
      y = rover.position.y

      case "#{rover.orientation.class}"
      when "North"
        orientation = "N"
      when "South"
        orientation = "S"
      when "West"
        orientation = "W"
      when "East"
        orientation = "E"
      else
        orientation = "N"
      end

      DB.open "sqlite3://./rovers.db" do |db|
        query_string = "update rovers set x=?, y=?, orientation=? where name=?"
        result = db.exec query_string, x, y, orientation, name
      end
    end
  end

  def self.move(name, move)
    mutex.synchronize do
      moves = move.split("").map { |m| translate_move(m) }
      rover = get(name)
      rover.move(moves)
      update(name, rover)
      rover.status
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
    get(name).status
  end
end
