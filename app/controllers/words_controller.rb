class WordsController < ApplicationController
require 'nokogiri'
require 'open-uri'

  def index
    @word ||= params[:entry]

    if @word.blank?
      @error = "Please enter a word!"
    else
      @defs = get_defs

    if @defs.blank?
        @error = "No Definitions Found"
      end
    end

  end

  def get_defs
    search_word = Word.find_or_create_by(entry: @word.downcase)

    unless search_word.definitions.load.blank?
      #word is found in local DB, return array of defs
      return Definition.where(word_id: search_word.id).to_a
    end

    #word is not in local DB, search Dictionary API
    defs = call_dictionary(search_word.entry)

    #if no defs returned by dictionary, send the empty array
    if defs.empty?
      search_word.destroy
      return defs

    else
      #add new defs found, associated with search_word.id
      defs.each {|d| Definition.create(content: d , word_id: search_word.id )}

      #return defs from DB
      Definition.where(word_id: search_word.id).to_a
    end

  end

  private

  def call_dictionary(search_word)
    dictionary_key = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/"
    my_key = "?key=cab72891-f003-43ef-a983-253666d45082"
    dictionary_api = "#{dictionary_key}#{search_word}#{my_key}"
    def_xml = Nokogiri::XML(open(dictionary_api).read)
    defs = Array.new
    def_xml.xpath("//dt").each {|d| defs.push(d.text.sub!(':', ''))}
    defs
  end

  end