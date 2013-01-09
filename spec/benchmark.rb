require 'simple_similarity'
require "benchmark"
 
a = []
CHARS = (?a..?z).to_a + ["e","e","e","e","e","a","a","a","a","a","a","a","a","a","a","a","a"]
100.times {a.push(5.times.inject("") {|s, i| s << CHARS[rand(CHARS.size)]})}
@ssd = SimpleSimilarity::Distance.new
time = Benchmark.measure do
  puts @ssd.matrix(a)
end
puts "Without matrix"
puts time

time = Benchmark.measure do
  puts @ssd.matrix(a)
end

puts "With matrix"
puts time