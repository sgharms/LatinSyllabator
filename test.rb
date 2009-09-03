#!/usr/bin/ruby
require 'rubygems'
require 'shoulda'
require 'syllabation'

class LineTest < Test::Unit::TestCase
  include Syllabation

  context "A syllabated Latin Line" do
    setup do
      @notated_line = "Arma virumque cano trojae qui primus ab oris"
      @nocomma_line = "Arma virumque cano, trojae qui primus ab oris"
      @shorter      = "Arma vir"
      @syllab_line  = "Ar,,ma ,,vi,,rum,,que ,,ca,,no ,,tro,,jae ,,qui pri,,mu,,s a,,b o,,ris"
    end

    should "Simple test of word 'arma'" do
      assert_equal "Ar,,ma", syllabate("Arma").to_s
    end
    

    # should "Syllabation should be the same" do
    #   assert_equal @syllab_line, syllabate(@shorter).to_s
    # end
  end
end

