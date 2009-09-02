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

SyllabatedLine is a class that holds all the state information about a given
line of verse.

It takes one argument, the line of verse (@origString).

It then constructs a matrix of vowel-bookended syllabic chunks (@sylLine),
loads them into an array, and then buils that collection of arrays
(@sylLines) into another array (@snippetMatrix). The bookending via vowels
requires the @vowelStatus variable.

=end

  class SyllabatedLine
    attr_accessor :origString, :sylLine, :vowelStatus, :snippetMatrix
    # Takes one String item, a line of Latin Verse
    def initialize(s)
      @origString = s
      @snippetMatrix = []
      @sylLine=[]
      @vowelStatus = false
      process_string(@origString)
      pp @snippetMatrix
    end
    def to_s
      return @origString
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
        puts "puts found a double: #{s[0..1]}"
        @sylLine << potential_double
        process_string(s[2..-1])
        
      # Is it a vowel?  
      elsif s[0,1].to_s.match(/[aeiou]/i)
        puts "found a vowel: #{s[0,1]}"

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
        puts "WS: [#{s[0,1]}]"
        @sylLine << s[0,1]
        process_string(s[1..-1])

      # Is it a consonant?
      elsif s[0,1].to_s.match(/[bcdfghijklmnpqrstvwxyz]/i)
        puts "found a consonant #{s[0,1]}"
        @sylLine << s[0,1] 
        process_string(s[1..-1])

      # Is it a punctuation mark?
      elsif s[0,1].to_s.match(/[,'".-]/)
        puts "found punc: #{s[0,1]}"
        @sylLine << s[0,1]
        process_string(s[1..-1])

      # Is it something else?
      else
        puts "huh: #{s[0,1]}"
#        raise SystemException "wtf"
        process_string(s[1..-1])
      end
    end
  end
  def syllabate(g)
    s = SyllabatedLine.new(g)
  end
end

