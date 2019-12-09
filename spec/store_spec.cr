require "./spec_helper"
require "rover"

describe Store do
  it "Stores a rover" do
    Store.create("number-five")
    Store.get("number-five").status.should eq("North (0, 0)")
  end

  it "deletes a rover" do
    Store.create("test rover")
    Store.rovers.keys.includes?("test rover").should eq(true)

    Store.delete("test rover")
    Store.rovers.keys.includes?("test rover").should eq(false)
  end

  it "translates a move" do
    Store.translate_move("R").should eq(Right)
    Store.translate_move("r").should eq(Right)

    Store.translate_move("L").should eq(Left)
    Store.translate_move("l").should eq(Left)

    Store.translate_move("LR").should eq(Forward)
    Store.translate_move("anything else").should eq(Forward)
  end

  it "should move a rover" do
    Store.create("a rover")
    Store.move("a rover", "fff")
    Store.get("a rover").status.should eq("North (0, 3)")

    Store.move("a rover", "rf")
    Store.get("a rover").status.should eq("East (1, 3)")

    Store.move("a rover", "rflf")
    Store.get("a rover").status.should eq("East (2, 2)")
  end
end
