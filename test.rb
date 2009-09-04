#!/usr/bin/ruby
require 'rubygems'
require 'shoulda'
require 'syllabation'

class LineTest < Test::Unit::TestCase
  include Syllabation

  context "A syllabated version of the first line of the Æneid" do
    setup do
      @given_line = "Arma virumque cano, trojae qui primus ab oris"
      @syllab_line  = "Ar,,ma ,,vi,,rum,,que ,,ca,,no, ,,tro,,jae ,,qui ,,pri,,mu,,s a,,b o,,ris"
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
    
    should "handle the word 'o Trojae' correctly" do
      assert_equal "o ,,Tro,,jae", syllabate("o Trojae").to_s
    end
    
    should "be the same" do
      assert_equal"Ar,,ma ,,vi,,rum,,que ,,ca,,no, ,,tro,,jae ,,qui", syllabate("Arma virumque cano, trojae qui").to_s
    end

    should "split 'i primus' properly to 'i pri,,mus'" do
      assert_equal "i ,,pri,,mu,,s a", syllabate("i primus a").to_s
    end
        
    # Full line test!
    should "match the given result" do
      assert_equal @syllab_line, syllabate(@given_line).to_s
    end
  end
  
  context "A syllabated version of the second line of the Æneid" do
    setup do
      @given_line = "Italiam fato profugus Laviniaque venit"
      @syllab_line  = "I,,ta,,li,,am ,,fa,,to ,,pro,,fu,,gus ,,La,,vin,,ja,,que ,,ve,,nit"
    end    
    
    # Full line test!
    should "should match the given result" do
      assert_equal @syllab_line, syllabate(@given_line).to_s
    end

  end
end

