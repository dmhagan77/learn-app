require 'spec_helper'

describe WordsController , type: :controller do

  #stubs the call to the dictionary API, couldn't get fixtures to work, so I hard coded my own results in each test
  def stub_dictionary(word , xml)
    uri = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{word}?key=cab72891-f003-43ef-a983-253666d45082"
    stub_request(:get, uri).to_return(status: 200 , headers: {} , body: xml )
  end

  describe "searches for a word in local DB" do
    let!(:word) { FactoryGirl.create(:word)}
    before {
      @def1 = word.definitions.create(content: "This is a test definition")
      @def2 = word.definitions.create(content: "This is another definition")
    }

    it "finds a word, returns array of defs" do
      post :index , entry: word.entry
      expect(controller.get_defs).to_not be_empty
    end
  end

  describe("Word is not in local DB, request dictionary API") {
    let(:word) { "kiwi" }
    let(:xml) { '<?xml version="1.0" encoding="utf-8" ?><entry_list version="1.0">  <entry id="kiwi"><ew>kiwi</ew><subj>ZB-1#GZ-2#GZ-3</subj><hw>ki*wi</hw><sound><wav>kiwi0001.wav</wav><wpr>!kE-(+)wE</wpr></sound><pr>ˈkē-(ˌ)wē</pr><fl>noun</fl><et>Maori</et><def><date>1835</date> <sn>1</sn> <dt>:any of a small genus (<it>Apteryx</it>) of flightless New Zealand birds with rudimentary wings, stout legs, a long bill, and grayish brown hairlike plumage</dt> <sn>2</sn> <slb>capitalized</slb> <dt>:a native or resident of New Zealand <un>used as a nickname</un></dt> <sn>3</sn> <dt>:<sx>kiwifruit</sx></dt></def><art><bmp>kiwi.bmp</bmp><cap>kiwi 1</cap></art></entry></entry_list>' }
    before { stub_dictionary(word, xml) }

    it "Submits word to dictionary API, load defition to DB " do
      post :index, entry: word

      #return array of defs from db after entered in by dictionary API
      expect(controller.get_defs).to_not be_empty
    end
  }

  describe "No word exists" do
    let(:word) { "bogusWord" }
    let(:xml) { '<?xml version="1.0" encoding="utf-8" ?><entry_list version="1.0"><suggestion>backsword</suggestion><suggestion>boxwood</suggestion><suggestion>Abbotsford</suggestion><suggestion>boxboard</suggestion></entry_list>' }
    #before { stub_dictionary(word, xml)} # causes error, but not sure why?
    before {
      stub_request(:get, "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/bogusword?key=cab72891-f003-43ef-a983-253666d45082").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => xml , :headers => {})
    }
    it "Returns empty array" do
      post :index , entry: word
      expect(controller.get_defs).to be_empty
    end
  end


end