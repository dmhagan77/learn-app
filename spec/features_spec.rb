require 'spec_helper'

describe "Root Page" do

  before { visit root_path }

  #test that basic elements on the page should be there
  it "Page has textbox and search button" do
    page.should have_selector( "input" )
    page.should have_button( "Get Defs!" )
  end

  #test that clicking button alerts user to fill in a word
  it "Returns the unaltered page when user enters nothing" do
      fill_in("entry", :with => "")
      click_button ("Get Defs!")
      page.should have_content "Please enter a word!"
  end

  #valid word = defintion(s) returned
  it "User enters a valid word, expect (a) definition(s)" do
    fill_in("entry", :with => "hockey")
    click_button ("Get Defs!")
    page.should have_selector("li.definition")
  end

  #non existent but valid "word" should return no definition
  it "User enters a non-existant word" do
    fill_in("entry", :with => "bogusWorsd")
    click_button ("Get Defs!")
    page.should have_content("No Definitions Found")
  end

  #user enters word that contains non-alpha chars
  describe "User enters invalid word" do
    pending "response of \"that isn't a word\" is shown to the user"
  end


end