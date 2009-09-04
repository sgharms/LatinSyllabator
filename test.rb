#!/usr/bin/ruby
require 'rubygems'
require 'shoulda'
require 'syllabation'

class LineTest < Test::Unit::TestCase
  include Syllabation

  context "A syllabated Latin Line" do
    setup do
      @notated_line = "Arma virumque cano, trojae qui primus ab oris"
      @syllab_line  = "Ar,,ma ,,vi,,rum,,que ,,ca,,no, ,,tro,,jae ,,qui pri,,mu,,s a,,b o,,ris"
    end

    should "handle the word 'Arma' correctly" do
      assert_equal "Ar,,ma", syllabate("Arma").to_s
    end
    
    should "handle the word 'a vi' correctly" do
      assert_equal "a ,,vi", syllabate("a vi").to_s
    end
    
    should "handle the phrase 'Arma virumque' correctly" do
      assert_equal "Ar,,ma ,,vi,,rum,,que", syllabate("Arma virumque").to_s
    end

    should "handle the phrase 'Arma virumque' correctly" do
      assert_equal "e ,,ca,,no, ,,Trojae", syllabate("e cano, Trojae").to_s
    end

    should "handle the phrase 'Arma virumque' correctly" do
      assert_equal "Ar,,ma ,,vi,,rum,,que ,,ca,,no, ,,Tro,,jae", syllabate("Arma virumque cano, Trojae").to_s
    end


    # should "handle the space-separated phrase 'Arma vi' correctly" do
    #   assert_equal "tro,,jae", syllabate("trojae").to_s
    # end
    
    # should "split 'primus' properly to 'pri,,mus'" do
    #   assert_equal "pri,,mus", syllabate("primus").to_s
    # end
    
    # should "split trojae to be tro,,jae"
    # should "Syllabation should be the same" do
    #   assert_equal @syllab_line, syllabate(@notated_line).to_s
    # end
  end
end

