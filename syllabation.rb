class String
  def lvowel?
    return true if self.match(/^[aeiou]$/i)
    return true if self.match(/ae|au|euou|ui|oe|ui/)
  end  
  def lcons?
    return true if self.match(/[bpd][lr]/)
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
      pp @origRay
      abstractify(@origRay)
      pp @abstractRay
      @simplifiedRay    = simplify_abstracted_array(@abstractRay)
      @simplifiedLength = @simplifiedRay.length
      pp @simplifiedLength
      @simpSylRay = state_machine(@simplifiedRay)
      pp '@simplifiedRay', @simplifiedRay
      pp '@simpSylRay', @simpSylRay
      pp '@workRay', @workRay
      reconstitute
    end
    def reconstitute
      retString = ""
      @origRay.each_index do |i|
        puts "index is #{i} : #{@simplifiedRay[0]}: #{@simpSylRay[0]} : [#{@workRay[0]}]"
        # if @workRay[0] == ' '
        #   puts "IN HERE"
        #   retString += @workRay.shift
        #   redo
        # end
        if @simplifiedRay[0] == @simpSylRay[0]
          retString += @workRay.shift unless @workRay.nil?
          @simplifiedRay.shift
          @simpSylRay.shift
        elsif @simplifiedRay[0] != @simpSylRay[0]
          if @workRay[0] =~ /(\s+)/
            puts "\t\tNAZZLE"
            pp @workRay
            retString += @workRay.shift
            puts "\t\tNAZZLE2"            
            pp @workRay
            # puts retString
            puts "\t\tNAZZLE3"            
            next
         elsif @simpSylRay[0] == ',,'
            retString += @simpSylRay.shift
            puts "after comma-corrector retString is \"#{retString}\""
            redo
          end
        else
          puts "\t\t\t\tRAZZLE"
          puts 'hobo'
        end
        puts "retString at end of reconstitute block: [#{retString}]"
      end
      retString.sub!(/.(.*)$/, '\1') if @seen_first
      @string_representation =  retString  
    end
    def state_machine(a)
      token = a.to_s
      p "<#{token}>"
      retRay = []
      case token
      when "VCCV"
        retRay = %w{V C ,, C V}
      when "VCV"
        retRay = %w{V ,, C V}
      when "VCQV"
        retRay = %w{V C ,, Q V}
      when "VCDQV"
        retRay = %w{V C D ,, Q V}        
      when "VDV"
        retRay = %w{V  ,, D  V}        
      when "VC"
        return a
      else
        STDERR.puts "Not caught by state machine: #{token}"
      end
      puts retRay.to_s
      return retRay
    end
    def simplify_abstracted_array(a)
      a.delete_if {|x| x =~ /[WP]/ }
      pp a
      return a
    end
    def abstractify(a)
      return if a.nil?
      
      potential_double = a[0..1].to_s
      first_char       = a[0,1].to_s

      # Is it a dipthong or the 'qu' consonant?
      if potential_double.match(/^(ae|au|oe|eu|ou|ui)/)
        @abstractRay << 'D'
        self.abstractify(a[2..-1])
      elsif potential_double.match(/^qu/)
        @abstractRay << 'Q'
        self.abstractify(a[1..-1])
      elsif potential_double.match(/^[bpd][lr]/)
        @abstractRay << 'D'
        self.abstractify(a[2..-1])
      elsif first_char.match(/^[aeiou]/i)
        @abstractRay << 'V'
        self.abstractify(a[1..-1])        
      elsif first_char.match(/^[bcdfghijklmnpqrstvwxyz]/i)
        @abstractRay << 'C'
        self.abstractify(a[1..-1])
      elsif first_char.match(/^\s/)
        @abstractRay << 'W'
        self.abstractify(a[1..-1])
      elsif first_char.match(/^[\,\.\-\"\']/)
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
      process_string(@origString)
      # pp @snippetMatrix
      @syllabatedString = ""
      
      seen_first_block = false
      @snippetMatrix.each do |sb|
        @syllabatedString += SyllaBlock.new(sb, :seen_first => seen_first_block).to_s
        seen_first_block = true
      end
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
      if s.nil?
        @snippetMatrix << @sylLine
        return
      end
      # Look for double characters first
      potential_double = s[0..1]
      
      # Is it a dipthong or the 'qu' consonant?
      if potential_double.match(/(ae|au|oe|eu|ou|ui|qu)/)
        # puts "found a double: #{s[0..1]}"
        @sylLine << potential_double
        process_string(s[2..-1])
        
      # Is it a vowel?  
      elsif s[0,1].to_s.match(/[aeiou]/i)
        # puts "found a vowel: #{s[0,1]}"

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
        # puts "WS: [#{s[0,1]}]"
        @sylLine << s[0,1]
        process_string(s[1..-1])

      # Is it a consonant?
      elsif s[0,1].to_s.match(/[bcdfghijklmnpqrstvwxyz]/i)
        # puts "found a consonant #{s[0,1]}"
        @sylLine << s[0,1] 
        process_string(s[1..-1])

      # Is it a punctuation mark?
      elsif s[0,1].to_s.match(/[,'".-]/)
        # puts "found punc: #{s[0,1]}"
        @sylLine << s[0,1]
        process_string(s[1..-1])

      # Is it something else?
      else
        # puts "huh: #{s[0,1]}"
#        raise SystemException "wtf"
        process_string(s[1..-1])
      end
    end
  end
  def syllabate(g)
    s = SyllabatedLine.new(g)
  end
end

