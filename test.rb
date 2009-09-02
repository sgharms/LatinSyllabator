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
      @syllab_line  = "Ar,,ma ,,vi,,rum,,que ,,ca,,no ,,tro,,jae ,,qui pri,,mu,,s a,,b o,,ris"
    end

    should "Syllabation should be the same" do
      assert_equal @syllab_line, syllabate(@nocomma_line)
    end
  end
end

