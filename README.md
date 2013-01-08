# SimpleSimilarity

This is an implemenation of a very trivial, and very costly algorithm to find
Similarity in a collection of items. It calculates a  distance between the
length of the items compressed each on its own, and compressed when concatenated
The theory is sound.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_similarity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_similarity

## Usage

Get the distance between "Hello" and "World", always takes to arguments.

    SimpleSimilarity::SimpleSimilarity.distance("Hello","World")

    $ 0.125

    SimpleSimilarity::SimpleSimilarity.case_insensitive_distance("Hello","hello")

    $ 1.0

Get a distance matrix, the first argument is an array of elements, the second
is a cutoff ratio for the detected similarities (0.5 is quite similar, above
0.8 we are  basically identical, depending on the length of the original strings..)

     SimpleSimilarity::SimpleSimilarity.distance_matrix(%w( hello, hell, world), 0.5, true, false)

     $  => {
     :matrix=>[
     [nil, 0.5833333333333333, 0.11764705882352944], 
     [nil, nil, 0.125], 
     [nil, nil, nil]
     ], 
     :similar_terms=>[{
     :first_term=>[0, "hello,"], 
     :second_term=>[1, "hell,"], 
     :score=>0.5833333333333333}]} 

### Caveat : 
1. The algorithm for calculating the distance matrix  costs (n^2/2) - n in time and n^2 in memory
> So if n = 100,000 
> there will be 4,999,900,000 calculations (and each is very expensive.. we are zipping)
2. setting only_hits to true does not return the matrix only the hits but optimizes memory usage.
### Note:
the matrix can be used later for clustering....     

#Testing
spec:
    
    bundle exec rspec spec         


Benchmark:

On my machine comparing 100 items takes around 8 seconds, comaring 1000 items around 20 minutes...: 
    
    bundle exec ruby spec/benchmark.rb

If what you want to compare are longer documents, swap the 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
