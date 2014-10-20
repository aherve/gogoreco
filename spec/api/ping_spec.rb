require 'spec_helper'
describe Gogoreco::V1::Ping do 
  it "pings" do
    get '/ping'
    h = JSON.parse(@response.body)
    expect(h).to eq({"ping" => "pong", "version" => "v1"})
  end
end
