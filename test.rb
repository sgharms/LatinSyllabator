#!/usr/bin/ruby
require 'rubygems'
require 'shoulda'
require 'syllabation'

class LineTest < Test::Unit::TestCase
  include Syllabation
  
  context "Handle a toughie" do
  end

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
    
    should "syllabate 'eque sagittifera prompsit duo tela pharetra'" do
      assert_equal("e,,que ,,sa,,git,,ti,,fe,,ra ,,prom,,psit ,,du,,o ,,te,,la ,,pha,,re,,tra", 
      syllabate("eque sagittifera prompsit duo tela pharetra"))
    end
    
    # umbrosa ==> [vcccv]cv
    should "syllabate 'impiger umbrosa Parnasi constitit arce'" do
      assert_equal("im,,pi,,ge,,r um,,bro,,sa ,,Par,,na,,si ,,con,,sti,,ti,,t ar,,ce", 
      syllabate("impiger umbrosa Parnasi constitit arce"))
    end

    #  'cuncta' = > c[vcccv]
    should "syllabate 'cuncta deo, tanto minor est tua gloria nostra.'" do
      assert_equal("cun,,cta ,,de,,o, ,,tan,,to ,,mi,,no,,r es,,t tu,,a ,,glo,,ri,,a ,,nos,,tra.", 
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

   context "Line" do
     # exclamation point!

     should "syllabate [``virginitate frui! dedit hoc pater ante Dianae.''] properly" do
       assert_equal("``vir,,gi,,ni,,ta,,te ,,frui! ,,de,,di,,t hoc ,,pa,,te,,r an,,te ,,Di,,a,,nae.''", 
       syllabate("``virginitate frui! dedit hoc pater ante Dianae.''"))
     end

     should "syllabate [te meus arcus'' ait; ``quantoque animalia cedunt] 'te meus arcus'' ait; ``quantoque animalia cedunt' properly" do
       assert_equal("te ,,meu,,s ar,,cu,,s'' a,,it; ``quan,,to,,qu\\sout{e }a,,ni,,ma,,li,,a ,,ce,,dunt", 
       syllabate("te meus arcus'' ait; ``quantoque animalia cedunt"))
     end

     should "syllabate [hoc deus in nympha Peneide fixit, at illo] [hoc deus in nympha Peneide fixit, at illo] properly" do 
       assert_equal("hoc ,,deu,,s in ,,nym,,pha ,,Pe,,nei,,de ,,fi,,xi,,t, a,,t il,,lo", 
       syllabate("hoc deus in nympha Peneide fixit, at illo"))
     end

     should "syllabate [stravimus innumeris tumidum Pythona sagittis.] ['stravimus innumeris tumidum Pythona sagittis.'] properly" do
       assert_equal("stra,,vi,,mu,,s in,,nu,,me,,ris ,,tu,,mi,,dum ,,Py,,tho,,na ,,sa,,git,,tis.", 
       syllabate("stravimus innumeris tumidum Pythona sagittis."))
     end


     should "syllabate [pulchra verecundo suffunditur ora rubore] [pulchra verecundo suffunditur ora rubore] properly" do
       assert_equal("pul,,chra ,,ve,,re,,cun,,do ,,suf,,fun,,di,,tu,,r o,,ra ,,ru,,bo,,re", 
       syllabate("pulchra verecundo suffunditur ora rubore"))
     end

     should "syllabate [inque patris blandis haerens cervice lacertis] properly" do
       assert_equal("in,,que ,,pa,,tris ,,blan,,di,,s hae,,ren,,s cer,,vi,,ce ,,la,,cer,,tis", 
       syllabate("inque patris blandis haerens cervice lacertis"))
     end

     should "syllabate [``da mihi perpetua, genitor carissime,'' dixit] properly" do
       assert_equal("``da ,,mi,,hi ,,per,,pe,,tu,,a, ,,ge,,ni,,tor ,,ca,,ris,,si,,me,'' ,,di,,xit", 
       syllabate("``da mihi perpetua, genitor carissime,'' dixit"))
     end

     should "syllabate [laesit Apollineas traiecta per ossa medullas;] properly" do
       assert_equal("lae,,si,,t A,,pol,,li,,ne,,as ,,tra,,i,,ec,,ta ,,pe,,r os,,sa ,,me,,dul,,las;", 
       syllabate("laesit Apollineas traiecta per ossa medullas;"))
     end

     should "syllabate [exuviis gaudens innuptaeque aemula Phoebes:] properly" do
       assert_equal("e,,xu,,vi,,is ,,gau,,den,,s in,,nup,,tae,,qu\\sout{e }ae,,mu,,la ,,Phoe,,bes:", 
       syllabate("exuviis gaudens innuptaeque aemula Phoebes:"))
     end

     should "syllabate [impatiens expersque viri nemora avia lustrat] properly" do
       assert_equal("im,,pa,,ti,,en,,s ex,,per,,sque ,,vi,,ri ,,ne,,mo,,r\\sout{a }a,,vi,,a ,,lus,,trat", 
       syllabate("impatiens expersque viri nemora avia lustrat"))
     end

     should "syllabate [nec, quid Hymen, quid Amor, quid sint conubia curat.] properly" do
       assert_equal("nec, ,,qui,,d Hy,,men, ,,qui,,d A,,mor, ,,quid ,,sin,,t co,,nu,,bi,,a ,,cu,,rat.", 
       syllabate("nec, quid Hymen, quid Amor, quid sint conubia curat."))
     end

     should "syllabate [saepe pater dixit: ``generum mihi, filia, debes,''] properly" do
       assert_equal("sae,,pe ,,pa,,ter ,,di,,xit: ``ge,,ne,,rum ,,mi,,hi, ,,fi,,li,,a, ,,de,,bes,''", 
       syllabate("saepe pater dixit: ``generum mihi, filia, debes,''"))
     end

     should "syllabate [saepe pater dixit: ``debes mihi, nata, nepotes'';] properly" do
       assert_equal("sae,,pe ,,pa,,ter ,,di,,xit: ``de,,bes ,,mi,,hi, ,,na,,ta, ,,ne,,po,,tes'';", 
       syllabate("saepe pater dixit: ``debes mihi, nata, nepotes'';"))
     end

     should "syllabate [illa velut crimen taedas exosa jugales] properly" do
       assert_equal("il,,la ,,ve,,lut ,,cri,,men ,,tae,,da,,s e,,xo,,sa ,,ju,,ga,,les", 
       syllabate("illa velut crimen taedas exosa jugales"))
     end

     should "syllabate [pulchra verecundo suffunditur ora rubore] properly" do
       assert_equal("pul,,chra ,,ve,,re,,cun,,do ,,suf,,fun,,di,,tu,,r o,,ra ,,ru,,bo,,re", 
       syllabate("pulchra verecundo suffunditur ora rubore"))
     end

     should "syllabate [Phoebus amat visaeque cupit conubia Daphnes,] properly" do
       assert_equal("Phoe,,bu,,s a,,mat ,,vi,,sae,,que ,,cu,,pit ,,co,,nu,,bi,,a ,,Daph,,nes,", 
       syllabate("Phoebus amat visaeque cupit conubia Daphnes,"))
     end

     should "syllabate [sic deus in flammas abiit, sic pectore toto] properly" do
       assert_equal("sic ,,deu,,s in ,,flam,,ma,,s a,,bi,,it, ,,sic ,,pec,,to,,re ,,to,,to", 
       syllabate("sic deus in flammas abiit, sic pectore toto"))
     end

     should "syllabate [si qua latent, meliora putat. fugit ocior aura] properly" do
       assert_equal("si ,,qua ,,la,,ten,,t, me,,li,,o,,ra ,,pu,,tat. ,,fu,,gi,,t o,,ci,,o,,r au,,ra", 
       syllabate("si qua latent, meliora putat. fugit ocior aura"))
     end

     should "syllabate [bracchiaque et nudos media plus parte lacertos;] properly" do
       assert_equal("brac,,chi,,a,,qu\\sout{e }et ,,nu,,dos ,,me,,di,,a ,,plus ,,par,,te ,,la,,cer,,tos;", 
       syllabate("bracchiaque et nudos media plus parte lacertos;"))
     end

     should "syllabate [me miserum! ne prona cadas indignave laedi] properly" do
       assert_equal("me ,,mi,,se,,rum! ,,ne ,,pro,,na ,,ca,,da,,s in,,dig,,na,,ve ,,lae,,di", 
       syllabate("me miserum! ne prona cadas indignave laedi"))
     end

     should "syllabate [hostes quaeque suos: amor est mihi causa sequendi!] properly" do
       assert_equal("hos,,tes ,,quae,,que ,,su,,os: a,,mo,,r es,,t mi,,hi ,,cau,,sa ,,se,,quen,,di!", 
       syllabate("hostes quaeque suos: amor est mihi causa sequendi!"))
     end

     should "syllabate [nympha, mane! sic agna lupum, sic cerva leonem,] properly" do
       assert_equal("nym,,pha, ,,ma,,ne! ,,si,,c ag,,na ,,lu,,pum, ,,sic ,,cer,,va ,,le,,o,,nem,", 
       syllabate("nympha, mane! sic agna lupum, sic cerva leonem,"))
     end
     should "syllabate ['nympha, precor, Penei, mane! non insequor hostis;] properly" do
       assert_equal("'nym,,pha, ,,pre,,cor, ,,Pe,,nei, ,,ma,,ne! ,,no,,n in,,se,,quo,,r hos,,tis;", 
       syllabate("'nympha, precor, Penei, mane! non insequor hostis;"))
     end


     should "syllabate [quodque cupit, sperat, suaque illum oracula fallunt,  ] properly" do
       assert_equal("quod,,que ,,cu,,pit, ,,spe,,rat, ,,su,,a,,qu\\sout{e }il,,l\\sout{um }o,,ra,,cu,,la ,,fal,,lunt,  ", 
       syllabate("quodque cupit, sperat, suaque illum oracula fallunt,  "))
     end

     should "syllabate [ut facibus saepes ardent, quas forte viator] properly" do
       assert_equal("ut ,,fa,,ci,,bus ,,sae,,pe,,s ar,,den,,t, quas ,,for,,te ,,vi,,a,,tor", 
       syllabate("ut facibus saepes ardent, quas forte viator"))
     end

     should "syllabate [spectat inornatos collo pendere capillos] properly" do
       assert_equal("spec,,ta,,t i,,nor,,na,,tos ,,col,,lo ,,pen,,de,,re ,,ca,,pil,,los", 
       syllabate("spectat inornatos collo pendere capillos"))
     end

     should "syllabate [quem fugias, ideoque fugis: mihi Delphica tellus] properly" do
       assert_equal("quem ,,fu,,gi,,a,,s, i,,de,,o,,que ,,fu,,gis: mi,,hi ,,Del,,phi,,ca ,,tel,,lus", 
       syllabate("quem fugias, ideoque fugis: mihi Delphica tellus"))
     end

     should "syllabate [horridus observo. nescis, temeraria, nescis,] properly" do
       assert_equal("hor,,ri,,du,,s ob,,ser,,vo. ,,nes,,cis, ,,te,,me,,ra,,ri,,a, ,,nes,,cis,", 
       syllabate("horridus observo. nescis, temeraria, nescis,"))
     end

     should "syllabate [cui placeas, inquire tamen: non incola montis,] properly" do
       assert_equal("c,,ui pla,,ce,,a,,s, in,,qui,,re ,,ta,,men: no,,n in,,co,,la ,,mon,,tis,", 
       syllabate("cui placeas, inquire tamen: non incola montis,"))
     end

     should "syllabate [aspera, qua properas, loca sunt: moderatius, oro,] properly" do
       assert_equal("as,,pe,,ra, ,,qua ,,pro,,pe,,ras, ,,lo,,ca ,,sunt: mo,,de,,ra,,ti,,u,,s, o,,ro,", 
       syllabate("aspera, qua properas, loca sunt: moderatius, oro,"))
     end

     should "syllabate [sic aquilam penna fugiunt trepidante columbae,] properly" do
       assert_equal("si,,c a,,qui,,lam ,,pen,,na ,,fu,,gi,,un,,t tre,,pi,,dan,,te ,,co,,lum,,bae,", 
       syllabate("sic aquilam penna fugiunt trepidante columbae,"))
     end
     
     should "syllabate hard thing [nec prosunt domino, quae prosunt omnibus, artes!']" do
       assert_equal("nec ,,pro,,sun,,t do,,mi,,no, ,,quae ,,pro,,sun,,t om,,ni,,bu,,s, ar,,tes!'", 
       syllabate("nec prosunt domino, quae prosunt omnibus, artes!'"))
     end

     should "handle 'Iuppiter est genitor; per me, quod eritque fuitque'" do
       assert_equal("I,,up,,pi,,te,,r es,,t ge,,ni,,tor; per ,,me, ,,quo,,d e,,rit,,que ,,fuit,,que", 
       syllabate("Iuppiter est genitor; per me, quod eritque fuitque"))
     end
     
   end   
end


