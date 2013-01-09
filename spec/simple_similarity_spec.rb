require 'simple_similarity'

describe SimpleSimilarity::SimpleSimilarity do

  before(:each) do
    @ss = SimpleSimilarity::SimpleSimilarity.new
  end
  
  it "Hello is identical to Hello" do
   @ss.distance("Hello","Hello").should eql(1.0)
  end

  it "Hello is not similar to world" do
    @ss.distance("Hello","World").should eql(0.125)
  end
  
  it "Hello is somewhat similar hello" do
    @ss.distance("Hello","hello").should eql(0.5)
  end
  
  it "Hello is identical to hello when case insensitive" do
    @ss.case_insensitive_distance("Hello","hello").should eql(1.0)
  end
end
describe SimpleSimilarity::Distance do
    
  it "from : hello, Hello, hell, world, cruel, crude with a cutoff of 0.5 we should have two couples" do
    @sd = SimpleSimilarity::Distance.new(0.5)
    @sd.matrix(%w( hello, Hello, hell, world, cruel, crud))[:similar_terms].length.should eql(2)
  end

  it "from : hello, Hello, hell, world, cruel, crude with a cutoff of 0.5 we should have three couples case insensitive" do
    @sd = SimpleSimilarity::Distance.new(0.5, true)
    @sd.matrix(%w( hello, Hello, hell, world, cruel, crud))[:similar_terms].length.should eql(3)
  end
  
  it "from : hello world, Hello world, hell world, world, cruel, crude with a cutoff of 0.5 we should have seven couples case insensitive" do
    @sd = SimpleSimilarity::Distance.new(0.5, true)    
    @sd.matrix(%w( hello world, Hello world, hell world, world, cruel, crude))[:similar_terms].length.should eql(7)
  end
  
  it "setting only_hits to false gives back a matrix" do
    @sd = SimpleSimilarity::Distance.new(1.0, true, false)    
    @sd.matrix(%w( hello, world))[:matrix].length.should eql(2)
  end

  it "by default gives a  matrix" do
    @sd = SimpleSimilarity::Distance.new(1.0, true)  
    @sd.matrix(%w( hello, world))[:matrix].length.should eql(2)
  end
  
  
end