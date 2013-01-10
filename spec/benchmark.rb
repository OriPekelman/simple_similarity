require 'simple_similarity'
require "benchmark"
 
@a = []
CHARS = (?a..?z).to_a + ["e","e","e","e","e","a","a","a","a","a","a","a","a","a","a","a","a"]
100.times {@a.push(1000.times.inject("") {|s, i| s << CHARS[rand(CHARS.size)]})}

Benchmark.bmbm(2)  do |r|
  r.report("With Celluloid:")   {  SimpleSimilarity::Distance.new(0.5,false,false,true).matrix(@a)}
  r.report("Without Celluloid:"){  SimpleSimilarity::Distance.new(0.5,false,false,false).matrix(@a)}
end
