require "simple_similarity/version"
require "zlib"

module SimpleSimilarity
  class SimpleSimilarity
    #calculate similarity by comparing the length of compressed(a) + length of
    #compressed (b) to the lengt of compressed (a and b concatenated)
    def self.distance(a, b)
      a = a.to_s
      b = b.to_s

      # optimization: well if they are equal lets not do expensive stuff
      if a==b then return 1.0 end
      
      # optimization: if one is empty and the other not they are totally different
      if ((a.empty? && !b.empty?) || (b.empty? && !a.empty?)) then return (0.to_f)  end
        
      # This is hacky, but useful. When strings are too short the compression
      # is not sufficient.
      if (a.length < 40 || b.length < 40)
        a = a * 10
        b = b * 10
      end
  
    # 8 characters is the minimal zlib compressed stream, this is basically a constant length we remove
     minimal_zip_length = 7 
     azip = Zlib.deflate(a).length - minimal_zip_length 
     bzip = Zlib.deflate(b).length - minimal_zip_length
   
     aplusbzip    =    (Zlib.deflate(a + b).length) - minimal_zip_length
     ((azip + bzip).to_f/aplusbzip.to_f) - 1 # -1 is because something that is totally different will get 1.00 totally the same 2.00. 
    end
  
    #Normalize the string, downcase remove non alphanumeric characters
    def self.case_insensitive_distance(a, b)
       self.distance(a.downcase.gsub(/[^[:alnum:]]/, ' '), b.downcase.gsub(/[^[:alnum:]]/, ' '))
    end
  
    # This method will return a distance matrix as well as matches beyond a supplies threshold
    # Caveat : this algorithm costs (n^2/2) - n in time and n^2 in memory
    # So if n= 100,000 
    # there will be 4,999,900,000 calculations
    # setting only_hits to true does not return the matrix only the hits
    # the matrix can be used later for clustering....
  
    #        "hello",	"hello",	"world", 	"hello world", 	"hello cruel world"
    # "hello"	[nil, 	1.0, 	0.125, 	0.41176470588235303, 	0.28],
    # "hello"	[nil, 	nil, 	0.125, 	0.41176470588235303, 	0.28],
    # "world"	[nil, 	nil, 	nil, 	0.41176470588235303, 	0.28],
    # "hello world"	[nil, 	nil, 	nil, 	nil, 	0.52],
    # "hello cruel world"	[nil, 	nil, 	nil, 	nil, 	nil]
    def self.distance_matrix(arr, cutoff = 0.5, case_insensitive = false, only_hits = true )
      sims =[]
      len = arr.length
      if only_hits 
        mat = []
      else 
        mat = Array.new(len){Array.new(len)}
      end
      
      dist = 0.to_f
      for i in 0..len
        for j in i+1..len -1
        if case_insensitive then
          dist = self.case_insensitive_distance(arr[i], arr[j])
        else
          dist = self.distance(arr[i], arr[j])
        end
        if dist >= cutoff
          sims.push({:first_term=>[i,arr[i]],:second_term=>[j,arr[j]],:score=>dist})
        end
        mat[i][j] = dist unless only_hits
       end
      end  
      {:matrix=>mat,:similar_terms=>sims}
    end
  end
end