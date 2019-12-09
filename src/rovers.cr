require "kemal"
require "./store.cr"

before_all "/rover" do |env|
  env.response.content_type = "application/json"
end

post "/rover/:name" do |env|
  name = env.params.url["name"]
  Store.create(name)

  {status: :success}.to_json
end

get "/rover/:name" do |env|
  name = env.params.url["name"]

  {
    status: :success,
    state:  Store.pretty(name),
  }.to_json
end

post "/rover/move/:name/:move" do |env|
  name = env.params.url["name"]
  moves = env.params.url["move"]

  state = Store.move(name, moves)

  {
    status: :success,
    state:  state,
  }.to_json
end

delete "/rover/:name" do |env|
  name = env.params.url["name"]
  Store.delete(name)
  {status: :success}.to_json
end

Kemal.run
