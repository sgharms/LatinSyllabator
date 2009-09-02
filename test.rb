#!/usr/bin/ruby
require 'rubygems'
require 'shoulda'
require 'syllabation'

class LineTest < Test::Unit::TestCase
  include Syllabation

  context "Handle LaTeX quotations" do
    should "syllabate 'filius huic Veneris ``figat tuus omnia, Phoebe,'" do
      assert_equal("fi,,li,,u,,s huic ,,Ve,,ne,,ris ``,,fi,,gat ,,tu,,u,,s om,,ni,,a, ,,Phoe,,be,", 
      syllabate("filius huic Veneris ``figat tuus omnia, Phoebe,"))
    end
    should "syllabate '``quid'' que ``tibi, lascive puer, cum fortibus armis?'''" do
      assert_equal("``quid'' ,,que ``,,ti,,bi, ,,las,,ci,,ve ,,pu,,er, ,,cum ,,for,,ti,,bu,,s ar,,mis?''", 
      syllabate("``quid'' que ``tibi, lascive puer, cum fortibus armis?''"))
    end    
  end
  
  
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

  context "Handle the undocumented VCCCV case" do
    return
    # Truly Exceptional:  prompsit generates a VCCCV case.  
    
    should "syllabate 'eque sagittifera prompsit duo tela pharetra'" do
      assert_equal("e,,que ,,sa,,git,,ti,,fe,,ra ,,prom,,psit ,,du,,o ,,te,,la ,,pha,,ret,,ra", 
      syllabate("eque sagittifera prompsit duo tela pharetra"))
    end

    # umbrosa ==> [vcccv]cv
    should "syllabate 'impiger umbrosa Parnasi constitit arce'" do
      assert_equal("im,,pi,,ge,,r umbro,,sa ,,Par,,na,,si ,,con,,sti,,ti,,t a,,rce", 
      syllabate("impiger umbrosa Parnasi constitit arce"))
    end

    #  'cuncta' = > c[vcccv]
    should "syllabate 'cuncta deo, tanto minor est tua gloria nostra.'" do
      assert_equal("cuncta deo, tanto minor est tua gloria nostra.", 
      syllabate("cuncta deo, tanto minor est tua gloria nostra."))
    end
  end
  
  context "Handle elisions for LaTeX" do
    should "syllabate 'quod fugat, obtusum est et habet sub harundine plumbum.' with aphairesis" do
      assert_equal("quod ,,fu,,ga,,t, ob,,tu,,su,,m\\sout{ e}s,,t e,,t ha,,bet ,,su,,b ha,,run,,di,,ne ,,plum,,bum.",
        syllabate("quod fugat, obtusum est et habet sub harundine plumbum.")
      )
    end
    
    should "syllabate 'quod facit, auratum est et cuspide fulget acuta,' with aphairesis" do
      assert_equal("quod ,,fa,,ci,,t, au,,ra,,tu,,m\\sout{ e}s,,t et ,,cus,,pi,,de ,,ful,,ge,,t a,,cu,,ta,", 
      syllabate("quod facit, auratum est et cuspide fulget acuta,"))
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
                       
      should "syllabate 'stravimus innumeris tumidum Pythona sagittis.'" do
        assert_equal("stra,,vi,,mu,,s in,,nu,,me,,ris ,,tu,,mi,,dum ,,Py,,tho,,na ,,sa,,git,,tis.", 
        syllabate("stravimus innumeris tumidum Pythona sagittis."))
      end

     should "syllabate 'qui modo pestifero tot iugera ventre prementem'" do
       assert_equal("qui ,,mo,,do ,,pes,,ti,,fe,,ro ,,tot ,,ju,,ge,,ra ,,ven,,tre ,,pre,,men,,tem", 
       syllabate("qui modo pestifero tot jugera ventre prementem"))
     end
     
     should "syllabate 'qui dare certa ferae, dare vulnera possumus hosti,'" do
       assert_equal("qui ,,da,,re ,,cer,,ta ,,fe,,rae, ,,da,,re ,,vul,,ne,,ra ,,pos,,su,,mu,,s hos,,ti,", 
       syllabate("qui dare certa ferae, dare vulnera possumus hosti,"))
     end
     
   end
end