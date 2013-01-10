require "simple_similarity/version"
require "zlib"
require "celluloid"
require 'pry'

module SimpleSimilarity
  
  class SimpleSimilarity
    include Celluloid

    #calculate similarity by comparing the length of compressed(a) + length of
    #compressed (b) to the lengt of compressed (a and b concatenated)
    def distance(a, b, case_insensitive = false)      
      a = a.to_s
      b = b.to_s
      
      if case_insensitive
        a = normalize(a)
        b = normalize(b)
      end
      # optimization: well if they are equal lets not do expensive stuff
      return 1.0 if a==b 
      
      # optimization: if one is empty and the other not they are totally different
      return (0.to_f) if ((a.empty? && !b.empty?) || (b.empty? && !a.empty?))
        
      # This is hacky, but useful. When strings are too short the compression
      # is not sufficient.
      if (a.length < 40 || b.length < 40)
        a = a * 10
        b = b * 10
      end
  
    # 8 characters is the minimal zlib compressed stream, this is basically a constant length we remove
     minimal_zip_length = 7 
     @zlib=Zlib::Deflate.new() # need to do new each time because of BUGGY zlib in JRUBY
     @zlib << a
     azip = @zlib.finish.length - minimal_zip_length 
     @zlib=Zlib::Deflate.new()
     @zlib << b
     bzip = @zlib.finish.length - minimal_zip_length
     @zlib=Zlib::Deflate.new()
     @zlib << a + b  
     aplusbzip    =    (@zlib.finish.length) - minimal_zip_length
     ((azip + bzip).to_f/aplusbzip.to_f) - 1 # -1 is because something that is totally different will get 1.00 totally the same 2.00. 
    end
    private
    def normalize(term)
      term.downcase.gsub(/[^[:alnum:]]/, ' ')
    end
  end
  
  class Distance     
    def initialize(cutoff = 0.5, case_insensitive = false, only_hits = false, celluloid = true)
      @cutoff = cutoff
      @case_insensitive = case_insensitive
      @only_hits = only_hits
      @ss = SimpleSimilarity.new
      @sims = []
      @celluloid = celluloid
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
    def matrix(arr)
      len = arr.length
      if @only_hits 
        @mat = []
      else 
        @mat = Array.new(len){Array.new(len)}
      end
        
      dist = 0.to_f
      for i in 0..len
        for j in i+1..len -1
        
          if @celluloid
            dist = @ss.future.distance(arr[i], arr[j], @case_insensitive)
          else
            dist = @ss.distance(arr[i], arr[j], @case_insensitive)
          end          
          update_matrix(i, j, dist) unless @only_hits 
          
       end
      end 
      
      for i in 0..len
        for j in i+1..len -1
          dist = @mat[i][j]
          update_matrix(i, j, val(dist)) unless @only_hits          
          push_to_similar(i, j, arr, val(dist))      
       end
      end      
       
      {:matrix=>@mat,:similar_terms=>@sims}
    end
    
    def push_to_similar(i,j,arr,dist)      
      @sims.push({:first_term=>[i,arr[i]],:second_term=>[j,arr[j]],:score=>dist}) unless dist <= @cutoff
    end
    
    def update_matrix(i,j,dist)
      @mat[i][j] = dist
    end
    private
    def val(val)
     @celluloid ? val.value : val
    end
    
  end
end