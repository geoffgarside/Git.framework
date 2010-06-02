describe "GITGraph" do
  before do
    @err = Pointer.new(:object)
    @repo = graph_repository.git_repo
    @head = GITObjectHash.objectHashWithString(graph_repository.head.sha)
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
    describe "nodes" do
      before do
        @nodes = @graph.nodes
      end
      should "all be instances of GITGraphNode" do
        @nodes.all? {|n| n.kind_of? GITGraphNode }.should.be.true
      end
    end
  end
  describe "-arrayOfNodesSortedByDate" do
    before do
      @graph = GITGraph.graphWithStartingCommit(@commit)
      @objects = @graph.arrayOfNodesSortedByDate
      @expected = graph_repository.git("rev-list master").split("\n").map { |l| l.strip }
    end
    should "not be nil" do
      @objects.should.not.be.nil
    end
    should "not be empty" do
      @objects.should.not.be.empty
    end
    should "have 17 nodes" do
      @objects.count.should == 17
    end
    should "return objects in date order" do
      dates = @objects.map { |node| node.object.committerDate.to_time }
      dates.should == dates.sort { |a,b| b <=> a } # so its reversed ;)
    end
    should "return objects in correct order" do
      # git rev-list graph
      @objects.map { |node| node.key.unpackedString }.should == @expected
    end
  end
  describe "-arrayOfNodesSortedByTopology" do
    before do
      @graph = GITGraph.graphWithStartingCommit(@commit)
      @objects = @graph.arrayOfNodesSortedByTopology
      @expected = graph_repository.git("rev-list --topo-order master").split("\n").map { |l| l.strip }
    end
    should "not be nil" do
      @objects.should.not.be.nil
    end
    should "not be empty" do
      @objects.should.not.be.empty
    end
    should "return objects in the correct order" do
      # git rev-list --topo-order graph
      @objects.map { |node| node.key.unpackedString }.should == @expected
    end
  end
  describe "-arrayOfNodesSortedByTopologyAndDate" do
    before do
      @graph = GITGraph.graphWithStartingCommit(@commit)
      @objects = @graph.arrayOfNodesSortedByTopologyAndDate
      @expected = graph_repository.git("rev-list --date-order master").split("\n").map { |l| l.strip }
    end
    should "not be nil" do
      @objects.should.not.be.nil
    end
    should "not be empty" do
      @objects.should.not.be.empty
    end
    should "return objects in correct order" do
      # git rev-list --date-order graph
      @objects.map { |node| node.key.unpackedString }.should == @expected
    end
  end
end
