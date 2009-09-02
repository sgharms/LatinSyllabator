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
  class SyllabatedLine
    attr_accessor :origString, :workString, :sylLine, :vowelStatus, :snippetMatrix
#    %w{ae au oe eu ou ui}
    # Takes one String item, a line of Latin Verse
    def initialize(s)
      @origString = @workString = s
      @snippetMatrix = []
      @sylLine=[]
      @vowelStatus = false
      process_string(@workString)
      pp @snippetMatrix
    end
    def to_s
      return @origString
    end
    def process_string(s)
      if s.nil?
        @snippetMatrix << @sylLine
        return
      end
      # Look for double characters first
      potential_double = s[0..1]
      if potential_double.match(/(ae|au|oe|eu|ou|ui|qu)/)
        puts "puts found a double: #{s[0..1]}"
        @sylLine << potential_double
        process_string(s[2..-1])
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
      elsif s[0,1].match(/\s/)
        puts "WS: [#{s[0,1]}]"
        @sylLine << s[0,1]
        process_string(s[1..-1])
      elsif s[0,1].to_s.match(/[bcdfghijklmnpqrstvwxyz]/i)
        puts "found a consonant #{s[0,1]}"
        @sylLine << s[0,1] 
        process_string(s[1..-1])
      elsif s[0,1].to_s.match(/[,'".-q]/)
        puts "found punc: #{s[0,1]}"
        @sylLine << s[0,1]
        process_string(s[1..-1])
      else
        puts "huh: #{s[0,1]}"
        process_string(s[1..-1])
      end
    end
  end
  def syllabate(g)
    s = SyllabatedLine.new(g)
  end
end

