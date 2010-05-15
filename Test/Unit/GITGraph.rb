describe "GITGraph" do
  before do
    @err = Pointer.new(:object)
    @repo = default_repository
    @head = GITObjectHash.objectHashWithString("42da854703bbcb8694d219f061609ebf286079e3")
    @commit = @repo.objectWithSha1(@head, error:@err)
  end
  describe "-graph" do
    before do
      @graph = GITGraph.graph
    end
    should "not be nil" do
      @graph.should.not.be.nil
    end
    should "have no nodes" do
      @graph.nodeCount.should == 0
    end
  end
  describe "-graphWithStartingCommit:" do
    before do
      @graph = GITGraph.graphWithStartingCommit(@commit)
    end
    should "not be nil" do
      @graph.should.not.be.nil
    end
  end
  
end
