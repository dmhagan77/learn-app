require 'spec_helper'

#test Words model to Definitions for proper association
describe Word do

  it { should have_many :definitions }
  #validation is__proper_word,
end

describe Definition do
  it { should belong_to :word }
end
