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
      assert_equal "Ar,,ma", syllabate("Arma")
    end
    
    should "handle the word 'a vi' correctly" do
      assert_equal "a ,,vi", syllabate("a vi")
    end
    
    should "handle the phrase 'Arma virumque' correctly" do
      assert_equal "Ar,,ma ,,vi,,rum,,que", syllabate("Arma virumque")
    end
    
    should "handle the phrase 'cano Trojae' correctly" do
      assert_equal "e ,,ca,,no, ,,Tro,,jae", syllabate("e cano, Trojae")
    end
    
    should "handle the phrase 'Arma virumque cano Trojae' correctly" do
      assert_equal "Ar,,ma ,,vi,,rum,,que ,,ca,,no, ,,Tro,,jae", syllabate("Arma virumque cano, Trojae")
    end
    
    should "handle the word 'o Trojae' correctly" do
      assert_equal "o ,,Tro,,jae", syllabate("o Trojae")
    end
    
    should "be the same" do
      assert_equal"Ar,,ma ,,vi,,rum,,que ,,ca,,no, ,,tro,,jae ,,qui", syllabate("Arma virumque cano, trojae qui")
    end

    should "split 'i primus' properly to 'i pri,,mus'" do
      assert_equal "i ,,pri,,mu,,s a", syllabate("i primus a")
    end
        
    # Full line test!
    should "match the given result" do
      assert_equal @syllab_line, syllabate(@given_line)
    end
  end
  
  context "A syllabated version of the second line of the Æneid" do
    
    setup do
      @given_line = "Italiam fato profugus Lavinjaque venit"
      @syllab_line  = "I,,ta,,li,,am ,,fa,,to ,,pro,,fu,,gus ,,La,,vin,,ja,,que ,,ve,,nit"
    end    
    
    # Full line test!
    should "should match the given result" do
      assert_equal @syllab_line, syllabate(@given_line)
    end
  end

  context "A syllabated version of the third line of the Æneid" do
    setup do
      @given_line = "Litora multum ille et terris jactatus et alto"
      @syllab_line  = "Li,,to,,ra ,,mul,,t\\sout{um }il,,l\\sout{e }et ,,ter,,ris ,,jac,,ta,,tu,,s e,,t al,,to"
    end    
    
    should "Syllabate 'Litora' properly" do
      assert_equal "Li,,to,,ra", syllabate('Litora')
    end
    
    # Full line test!
    should "should match the given result" do
      assert_equal @syllab_line, syllabate(@given_line)
    end
  end

  context "Handle oddities" do
    should "syllabate 'primus'" do
      assert_equal("Pri,,mus", syllabate("Primus"))
    end
    
    should "syllabate 'Phoebi'" do
      assert_equal("Pri,,mu,,s a,,mor ,,Phoe,,bi", syllabate("Primus amor Phoebi"))
    end    

    should "Syllabate 'Primus amor Phoebi Daphne Peneia, quem non'" do
        assert_equal( 
        "Pri,,mu,,s a,,mor ,,Phoe,,bi ,,Daph,,ne ,,Pe,,nei,,a, ,,quem ,,non",
        syllabate("Primus amor Phoebi Daphne Peneia, quem non"))
      end

    should "syllabate 'quod fugat, obtusum est et habet sub harundine plumbum.'" do
      assert_equal("syllabate quod fugat, obtusum est et habet sub harundine plumbum.",
        syllabate("syllabate quod fugat, obtusum est et habet sub harundine plumbum.")
      )
    end
    return
    should "syllabate 'quod facit, auratum est et cuspide fulget acuta,'" do
       assert_equal("quod facit, auratum est et cuspide fulget acuta,", 
       "quod facit, auratum est et cuspide fulget acuta,")
     end
 
     should "syllabate 'eque sagittifera prompsit duo tela pharetra'" do
       assert_equal("eque sagittifera prompsit duo tela pharetra", 
       syllabate("eque sagittifera prompsit duo tela pharetra"))
     end
     
     should "syllabate 'impiger umbrosa Parnasi constitit arce'" do
       assert_equal("impiger umbrosa Parnasi constitit arce", 
       syllabate("impiger umbrosa Parnasi constitit arce"))
     end
     
     should "syllabate 'cuncta deo, tanto minor est tua gloria nostra.'" do
       assert_equal("cuncta deo, tanto minor est tua gloria nostra.", 
       syllabate("cuncta deo, tanto minor est tua gloria nostra."))
     end
     
     should "syllabate 'filius huic Veneris ``figat tuus omnia, Phoebe,'" do
       assert_equal("filius huic Veneris ``figat tuus omnia, Phoebe,", 
       syllabate("filius huic Veneris ``figat tuus omnia, Phoebe,"))
     end
     
     should "syllabate 'stravimus innumeris tumidum Pythona sagittis.'" do
       assert_equal("stravimus innumeris tumidum Pythona sagittis.", 
       syllabate("stravimus innumeris tumidum Pythona sagittis."))
     end
     
     should "syllabate 'qui modo pestifero tot iugera ventre prementem'" do
       assert_equal("qui modo pestifero tot iugera ventre prementem", 
       syllabate("qui modo pestifero tot iugera ventre prementem"))
     end
     
     should "syllabate 'qui dare certa ferae, dare vulnera possumus hosti,'" do
       assert_equal("qui dare certa ferae, dare vulnera possumus hosti,", 
       syllabate("qui dare certa ferae, dare vulnera possumus hosti,"))
     end
     
     should "syllabate '``quid'' que ``tibi, lascive puer, cum fortibus armis?'''" do
       assert_equal("``quid'' que ``tibi, lascive puer, cum fortibus armis?''", 
       syllabate("``quid'' que ``tibi, lascive puer, cum fortibus armis?''"))
     end
   end
end

