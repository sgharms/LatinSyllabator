class String
  def lvowel?
    return true if self.match(/^[aeiou]$/i)
    return true if self.match(/ae|ou|ui|oe|ui/)
  end
  def lcons?
    return true if self.match(/[bpd][lr]/)
    return !(self.lvowel?)
  end
end

module  Syllabation
   require 'pp'
   def latin_characterize(given)
     return given.gsub(/(ae|qu|[a-z]|\s+)/, '|\1').split(/\|/)
   end
   def syllabate(given)
     demo_ray     = Array.new
     short_ray    = Array.new
     block_active = false
     latin_characterize(given).each do |lc|
       short_ray.push(lc)
       if not block_active
         if lc.lvowel?
           #puts "going true"
           block_active = true
         end
       else
         #puts "active"
         if lc.lvowel?
           #puts "shutoff"
           #black_active=false
           #puts "before push" + short_ray.to_s
           demo_ray.push(short_ray)
           short_ray=[]
           short_ray.push(lc)
         end
       end
     end
     return_string = ""
     demo_ray.each do |aRay|
       #puts "#{aRay.to_s}|#{partition(aRay)}"
       return_string += partition(aRay)
     end
     return return_string + short_ray.to_s
   end
   def partition(pRay)
     if pRay[0].lvowel? and pRay[-1].lvowel?
       numbernoise = false
       if pRay.length%2 == 0
         half = (pRay.length - 1)/2 unless pRay.nil?
         if numbernoise 
           syllabated_array = ['1'] + pRay[0..half] + [',,'] + pRay[half+1..-2]
         else
           #puts "half is:  -#{pRay[half]}-"
           syllabated_array =  pRay[0..half] + [',,'] + pRay[half+1..-2]
           if pRay[half].lcons? and ( pRay[half+1] == ' ' or pRay[half+1] == ',' )
             syllabated_array =  pRay[0..half-1] + [',,'] + pRay[half..-2]
           end
         end
       else
         half = (pRay.length - 1)/2 unless pRay.nil?
         if numbernoise 
           syllabated_array = ['2'] + pRay[0..half-1] + [',,'] + pRay[half..-2]
         else
           syllabated_array =  pRay[0..half-1] + [',,'] + pRay[half..-2]
         end
       end
       return syllabated_array.to_s.gsub(/,,([brp][lr])/, '\1')#.gsub(/(\w),,, (\w)/,'\1, ,,\2')
     end
   end
end
