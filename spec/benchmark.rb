require 'simple_similarity'
require "benchmark"
 
a = []
CHARS = (?a..?z).to_a + ["e","e","e","e","e","a","a","a","a","a","a","a","a","a","a","a","a"]
1000.times {a.push(5.times.inject("") {|s, i| s << CHARS[rand(CHARS.size)]})}

time = Benchmark.measure do
  puts SimpleSimilarity::SimpleSimilarity.distance_matrix(a, 0.5, false, true)[:similar_terms]
end
puts "Without matrix"
puts time

time = Benchmark.measure do
  puts SimpleSimilarity::SimpleSimilarity.distance_matrix(a, 0.5, false, false)[:similar_terms]
end
puts "With matrix"
puts time