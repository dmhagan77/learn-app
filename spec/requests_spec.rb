require 'spec_helper'

describe "Doogle Requests" do
  #requests through the page; test the whole stack

  it "Page loads index" do
    visit root_path
    expect(response.status).to eq(200)
  end
end