require 'simple_similarity'

describe SimpleSimilarity::SimpleSimilarity do
  it "Hello is identical to Hello" do
    SimpleSimilarity::SimpleSimilarity.distance("Hello","Hello").should eql(1.0)
  end

  it "Hello is not similar to world" do
    SimpleSimilarity::SimpleSimilarity.distance("Hello","World").should eql(0.125)
  end
  
  it "Hello is somewhat similar hello" do
    SimpleSimilarity::SimpleSimilarity.distance("Hello","hello").should eql(0.5)
  end
  
  it "Hello is identical to hello when case insensitive" do
    SimpleSimilarity::SimpleSimilarity.case_insensitive_distance("Hello","hello").should eql(1.0)
  end
  
  it "from : hello, Hello, hell, world, cruel, crude with a cutoff of 0.5 we should have two couples" do
    SimpleSimilarity::SimpleSimilarity.distance_matrix(%w( hello, Hello, hell, world, cruel, crud), 0.5)[:similar_terms].length.should eql(2)
  end

  it "from : hello, Hello, hell, world, cruel, crude with a cutoff of 0.5 we should have three couples case insensitive" do
    SimpleSimilarity::SimpleSimilarity.distance_matrix(%w( hello, Hello, hell, world, cruel, crud), 0.5, true)[:similar_terms].length.should eql(3)
  end
  
  it "from : hello world, Hello world, hell world, world, cruel, crude with a cutoff of 1.0 we should have seven couples case insensitive" do
    SimpleSimilarity::SimpleSimilarity.distance_matrix(%w( hello world, Hello world, hell world, world, cruel, crude), 1.0, true)[:similar_terms].length.should eql(7)
  end
  
  it "setting only_hits to false gives back a matrix" do
    SimpleSimilarity::SimpleSimilarity.distance_matrix(%w( hello, world), 1.0, true, false)[:matrix].length.should eql(2)
  end

  it "by default does not gives an empty matrix" do
    SimpleSimilarity::SimpleSimilarity.distance_matrix(%w( hello, world))[:matrix].length.should eql(0)
  end
  
  
end