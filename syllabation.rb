class String
  def lvowel?
    return true if self.match(/^[aeiouy]$/i)
    return true if self.match(/ae|au|euou|ui|oe|ui/)
  end  
  def lcons?
    return true if self.match(/^[\w,]+[bpdgtc][lr]/)
    return !(self.lvowel?)
  end
end

module  Syllabation
  require 'pp'
=begin rdoc

After a SyllabatedLine is broken apart into vowel-bookended pieces, these
pieces are called SyllaBlocks

This abstraction is created because of this problem

  [arma]

should be syllabated the same as

  [a rma]
  
or even

  [a, rm a]
  
To process each of these entities in some sort of decision structure is far
too painful. Ergo, the SyllaBlock class. A SyllaBlock takes the block,
abstracts the vowels, consonants, and whitespaces to get the *true* length
of the block so that the syllabation marker can be properly applied. After
the marker is applied, the correct tokens are re-inserted.

=end

  class SyllaBlock
    require 'pp'
    attr_accessor :origRay, :abstractRay, :block_length, :workRay,
                  :simplifiedRay, :simplifiedLength,
                  :simpSylRay, :string_representation,
                  :seen_first
    def initialize(charRay, *params)
      @seen_first   = params[0][:seen_first]
      @origRay      = charRay
      @workRay      = charRay.clone
      @abstractRay  = @simplifiedRay = []
      @block_length = charRay.length
      abstractify(@origRay)

      @simplifiedRay    = simplify_abstracted_array(@abstractRay)
      @simplifiedLength = @simplifiedRay.length

      @simpSylRay = state_machine(@simplifiedRay)

      reconstitute
    end
    def reconstitute
      retString = ""
      @origRay.each_index do |i|
        if @workRay[0].match(/^[\,\.\-\"\'\`\!]/)
          retString += @workRay.shift
          next
        end
        if @simplifiedRay[0] == @simpSylRay[0]
          retString += @workRay.shift unless @workRay.nil?
          @simplifiedRay.shift
          @simpSylRay.shift
        elsif @workRay[0] =~ /(\s+)/
            retString += @workRay.shift
            next
        elsif @simpSylRay[0] == ',,'
           retString += @simpSylRay.shift
           redo
        elsif @simplifiedRay[0] != @simpSylRay[0]
        end
      end
      
      if @seen_first
        if retString.match(/^(ae|au|oe|eu|ou|ui|ei)/)
          retString.sub!(/[aeiouy][aeiouy](.*)$/, '\1') 
        else
          retString.sub!(/.(.*)$/, '\1') 
        end
      end
      @string_representation =  retString  
    end

    def state_machine(a)
      token = a.to_s
      retRay = []
      case token
      when "VCCV"
        retRay = %w{V C ,, C V}
      when "CVCV"
        retRay = %w{C V ,, C V}
      when "VCV"
        retRay = %w{V ,, C V}
      when "VQD"
        retRay = %w{V ,, Q D}
      when "VCQV"
        retRay = %w{V C ,, Q V}
      when "VCDQV"
        retRay = %w{V C D ,, Q V}        
      when "VDV"
        retRay = %w{V  ,, D  V}        
      when "VQV"
        retRay = %w{V  ,, Q  V}   
      when "VCQD"       
        retRay = %w{V C ,, Q D}
      when "VQCV"
        retRay = %w{V Q ,, C V}
      when "DCCV"
        retRay = %w{D C ,, C V}
      when "CCVCV"
        retRay = %w{C C V ,, C V}
      when "CVCCV"
        retRay = %w{C V C ,, C V}
      when "QVCQV"        
        retRay = %w{Q V C ,, Q V}
      when "HVCCD"
        retRay = %w{C V C ,, C D}
        @abstractRay.collect!{|x| x=~/h/i ? 'C' : x }
      when "VCCCCQV"
        retRay = %w{VC C C C,, Q V}
      when "QVCV"
        retRay =%w{Q V ,, C V}
      when "QVCCV"
        retRay = %w{Q V C ,, C V}
      when "CVCCCV"
        retRay = %w{C V C ,, C C V}
      when "VCCCV"
        retRay = %w{V C ,, C C V}
      when "CVCCHCV"
        retRay = %w{C V C ,, C C C V}
        @abstractRay.collect!{|x| x=~/h/i ? 'C' : x }
      when "CVCCHV"
        retRay = %w{C V C ,, C C V}
        @abstractRay.collect!{|x| x=~/h/i ? 'C' : x }        
      when "QDCV"
        retRay = %w{Q D ,, C V}
      when "VCDV"
        retRay = %w{V C ,, D V}
      when "CVCCD"
        retRay = %w{C V C ,, C D}
      when "CVQV"
        retRay = %w{C V ,, Q V}
      when "DVCV"
        retRay = %w{D V ,, C V}
      when "CDCV"
        retRay  = %w{C D ,, C V}
      when "VD"
        retRay = %w{V ,, D}
      when "VCCQV"
        retRay = %w{V C ,, C Q V}
      when "CVCQV"
        retRay = %w{C V C ,, Q V}
      when "CDDV"
        retRay = %w{C ,, D  D V}
      when "VCCDV"
        retRay = %w{V C ,, C D V}
      when "CVCDV"
        retRay = %w{C V C ,, D V}
      when "CCVCCV"
        retRay = %w{C C V C ,, C V}
      when "HVCCV"
        retRay = %w{C V C ,, C V}
        @abstractRay.collect!{|x| x=~/h/i ? 'C' : x }
      when "VHV"
        retRay = %w{V ,, C V}
        @abstractRay.collect!{|x| x=~/h/i ? 'C' : x }
      when "QDV"
        retRay = %w{Q D ,, V}
      when "DDV"
        retRay = %w{D ,, D V}
      when "VCHV"
        retRay = %w{V ,, C C V}
        @abstractRay.collect!{|x| x=~/h/i ? 'C' : x }
      when "VCHD"
        retRay = %w{V ,, C C D}
        @abstractRay.collect!{|x| x=~/h/i ? 'C' : x }
      when "VCD"
        retRay = %w{V ,, C D}
      when "DQV"
        retRay = %w{D ,, Q V}
      when "VCCD"
        retRay = %w{V C ,, C D}
      when "DCV"
        retRay = %w{D ,, C V}
      when "DV"
        retRay = %w{D ,, V}
      when "CVCD" 
        retRay = %w{C V ,, C D}
      when "VCC"  
        retRay = %w{V C C}
      when "VC"
        return a
      when "VV"
        retRay = %w{V ,, V}
      when "V"
        retRay = %w{V}
      when "D"
        retRay = %w{D}
      else
        STDERR.puts "Not caught by state machine: #{token} : #{@origRay.to_s} [#{@origRay.length}]"
      end
      return retRay
    end
    def simplify_abstracted_array(a)
      a.delete_if {|x| x =~ /[WP]/ }
      return a
    end
    def abstractify(a)
      return if a.length == 0
      
      potential_double = a[0..1].to_s
      first_char       = a[0,1].to_s

      # Is it a dipthong or the 'qu' consonant?
      if potential_double.match(/^(ae|au|oe|eu|ou|ui|ei)/)
        @abstractRay << 'D'
        self.abstractify(a[1..-1])
      elsif potential_double.match(/^qu/i)
        @abstractRay << 'Q'
        self.abstractify(a[1..-1])
      elsif potential_double.match(/^ph/i)
        @abstractRay << 'Q'
        self.abstractify(a[1..-1])
      elsif potential_double.match(/^[\s,]+[bpdgtc][lr]/)
        @abstractRay << 'D'
        self.abstractify(a[2..-1])
      elsif first_char.match(/^[aeiouy]/i)
        @abstractRay << 'V'
        self.abstractify(a[1..-1])        
      elsif first_char.match(/^h/i) # 'h' is funny
        @abstractRay << 'H'
        self.abstractify(a[1..-1])
      elsif first_char.match(/^[bcdfgijklmnpqrstvwxyz]/i)
        @abstractRay << 'C'
        self.abstractify(a[1..-1])
      elsif first_char.match(/^\s/)
        @abstractRay << 'W'
        self.abstractify(a[1..-1])
      elsif first_char.match(/^[\,\.\-\"\'\`\!]/)
        @abstractRay << 'P'
        self.abstractify(a[1..-1])
      end
    end
    def to_s
      return @string_representation
    end
  end


=begin rdoc

SyllabatedLine is a class that holds all the state information about a given
line of verse.

It takes one argument, the line of verse (@origString).

It then constructs a matrix of vowel-bookended syllabic chunks (@sylLine),
loads them into an array, and then buils that collection of arrays
(@sylLines) into another array (@snippetMatrix). The bookending via vowels
requires the @vowelStatus variable.

=end

  class SyllabatedLine
    attr_accessor :origString, :sylLine, :vowelStatus, :snippetMatrix, :syllabatedString
    # Takes one String item, a line of Latin Verse
    def initialize(s)
      @origString = s
      @snippetMatrix = []
      @sylLine=[]
      @vowelStatus = false
      process_string(preprocess(@origString))
      @syllabatedString = ""
      
      seen_first_block = false
      @snippetMatrix.each do |sb|
        @syllabatedString += SyllaBlock.new(sb, :seen_first => seen_first_block).to_s
        seen_first_block = true
      end
      postprocess
    end
    def preprocess(s)
      temp = s
      return temp
    end
    def postprocess
      # Some aspect of elision and spelling correction are best handled on a per-line level.  That's what's done here.

      # Elision for 'vowel+m' at end of word with aphairesis
      unless  @syllabatedString.gsub!(/([aeiouy],,m)([\s\,]+)(e)s(t*)/i,'\1\\sout{\2\3\4\5}s\6') 

        # Elision for 'vowel+m' at end of word, but only if the former was not the case
        @syllabatedString.gsub!(/([aeiouy]),,m(\s.*?)([aeiouy])/i,'\\sout{\1m\2}\3')
      end

      
      # Elision for 'vowel .* vowel' at end of word
      @syllabatedString.gsub!(/([aeiouy])(\s+[\,]+)([aeiouy])/i,'\\sout{\1 }\3')

    end
    def to_s
      @syllabatedString
    end

=begin rdoc

process_string is originally passed the @origString from the initializer.

The first 'character' (NB: 'character' in the world of latin may also be
duoglyph items such as the 'ae' dipthong or the 'qu' consonant). is taken off
and classified as whitespace, vowel, or character, according to the extensions
to String provided in syllabation.rb.

Once the 'chararcter' is evaluated, the remainder of the string is recursively
sent to the method again until nil.

=end

    def process_string(s)
      if s.length == 0 
        @snippetMatrix << @sylLine
        return
      end
      # Look for double characters first
      potential_double = s[0..1]  
      
      # Is it a dipthong or the 'qu' consonant?
      if potential_double.match(/(ae|au|oe|eu|ou|ui|qu|ph|ei)/i)
        @sylLine << potential_double 
 
        if potential_double.match(/^[aeiouy]/)
          if @vowel_status
            @vowel_status = false
            @snippetMatrix << (@sylLine)
            @sylLine=[s[0,2]]
            @vowel_status = true
          else
            @vowel_status = true
          end
        end
        
        process_string(s[2..-1])

      # Handle the liquids
      elsif potential_double.match(/[bpdgtc][lr]/)
        @sylLine << potential_double
        process_string(s[2..-1])
        
      # Is it a vowel?  
      elsif s[0,1].to_s.match(/[aeiouy]/i)
        @sylLine << s[0,1] 
        
        # use to break this up into chunks
        if @vowel_status
          @vowel_status = false
          @snippetMatrix << (@sylLine)
          @sylLine=[s[0,1]]
          @vowel_status = true
        else
          @vowel_status = true
        end
        
        process_string(s[1..-1])
      
      # Is it whitespace?
      elsif s[0,1].match(/\s/)
        @sylLine << s[0,1]
        process_string(s[1..-1])

      # Is it a consonant?
      elsif s[0,1].to_s.match(/[bcdfghijklmnpqrstvwxyz]/i)
        @sylLine << s[0,1] 
        process_string(s[1..-1])

      # Is it a punctuation mark?
      elsif s[0,1].to_s.match(/[!,'".-`]/)
        @sylLine << s[0,1]
        process_string(s[1..-1])
        
      # Is it something else?
      else
        if s[0,1].to_s.match(/\w/)
          raise "barfbag: #{s[0,1].to_s}"
          process_string(s[1..-1])
        end
      end
    end
  end
  def syllabate(g)
    s = SyllabatedLine.new(g)
    return s.to_s
  end
end

