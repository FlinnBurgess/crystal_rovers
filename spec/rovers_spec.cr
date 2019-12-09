require "spec-kemal"

describe "Rovers" do
  it "successfully creates a rover" do
    post "/rover/test"
    response.body.should eq({status: :success}.to_json)
  end

  it "successfully gets a rover" do
    get "/rover/test"
    response.body.should eq({status: :success, state: Store.pretty("test")}.to_json)
  end

  it "successfully moves a rover" do
    post "/rover/move/test/fff"
    response.body.should eq({status: :success, state: "North (0, 3)"}.to_json)
  end

  it "successfully deletes a rover" do
    delete "/rover/test"
    response.body.should eq({status: :success}.to_json)
  end
end
