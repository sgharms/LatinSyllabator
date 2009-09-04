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

    should "handle the word 'Arma vi' correctly" do
      assert_equal "Ar,,ma ,,vi", syllabate("Arma vi").to_s
    end
    
    should "Syllabation should be the same" do
      assert_equal @syllab_line, syllabate(@notated_line).to_s
    end
  end
end

