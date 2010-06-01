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
      @objects.map { |node| node.key.unpackedString }.should == %w(
        42da854703bbcb8694d219f061609ebf286079e3
        d88c245f270c8d1be05e7dcaefd0a52b58ca4cf3
        f50b98109824b5fd1a9889cc282a6e66923669e4
        d0c92769e2cc8e6965300319bf3e458bd65ba4e8
        81aaf3ff89058f53e6afb9cd34c06bf113c1a9da
        01c7e1968a8d05eea6b4057576f1379013c7f2ef
        bf745589fa5b3f5c48db9dbb18d643c68a15cbf2
        d5c5357e9b5778efd41135b4e1a6056bdbd9caa8
        8dea56207d66f6dfe71ce8dd316ce1ce0d332803
        205015288f6c0bdfc863e498c29c38060ce4739c
        f40dc0c50c3354a987e8bd285058f9549907d05e
        0f7848f832a936edecf672d7c0b24141003f5acb
        fa232d1446d5045b0cad3abbc083edc3063c8a6e
        ca64739e44dafecdc6eba46ac2589305096c19d0
        a32e235cb48e14343a803fe6c795a433938110ee
        bf00d913136ee9d86bbf5d18b8545873005123a3
        2860e21f898bbe889dffdc88b5f795ed1f39ffc3
      )
    end
  end
  describe "-arrayOfNodesSortedByTopology" do
    before do
      @graph = GITGraph.graphWithStartingCommit(@commit)
      @objects = @graph.arrayOfNodesSortedByTopology
    end
    should "not be nil" do
      @objects.should.not.be.nil
    end
    should "not be empty" do
      @objects.should.not.be.empty
    end
    should "return objects in the correct order" do
      # git rev-list --topo-order graph
      @objects.map { |node| node.key.unpackedString }.should == %w(
        42da854703bbcb8694d219f061609ebf286079e3
        d88c245f270c8d1be05e7dcaefd0a52b58ca4cf3
        f50b98109824b5fd1a9889cc282a6e66923669e4
        d0c92769e2cc8e6965300319bf3e458bd65ba4e8
        d5c5357e9b5778efd41135b4e1a6056bdbd9caa8
        8dea56207d66f6dfe71ce8dd316ce1ce0d332803
        01c7e1968a8d05eea6b4057576f1379013c7f2ef
        205015288f6c0bdfc863e498c29c38060ce4739c
        81aaf3ff89058f53e6afb9cd34c06bf113c1a9da
        bf745589fa5b3f5c48db9dbb18d643c68a15cbf2
        f40dc0c50c3354a987e8bd285058f9549907d05e
        0f7848f832a936edecf672d7c0b24141003f5acb
        a32e235cb48e14343a803fe6c795a433938110ee
        fa232d1446d5045b0cad3abbc083edc3063c8a6e
        ca64739e44dafecdc6eba46ac2589305096c19d0
        bf00d913136ee9d86bbf5d18b8545873005123a3
        2860e21f898bbe889dffdc88b5f795ed1f39ffc3
      )
    end
  end
  describe "-arrayOfNodesSortedByTopologyAndDate" do
    before do
      @graph = GITGraph.graphWithStartingCommit(@commit)
      @objects = @graph.arrayOfNodesSortedByTopologyAndDate
    end
    should "not be nil" do
      @objects.should.not.be.nil
    end
    should "not be empty" do
      @objects.should.not.be.empty
    end
    should "return objects in correct order" do
      # git rev-list --date-order graph
      @objects.map { |node| node.key.unpackedString }.should == %w(
        42da854703bbcb8694d219f061609ebf286079e3
        d88c245f270c8d1be05e7dcaefd0a52b58ca4cf3
        f50b98109824b5fd1a9889cc282a6e66923669e4
        d0c92769e2cc8e6965300319bf3e458bd65ba4e8
        81aaf3ff89058f53e6afb9cd34c06bf113c1a9da
        01c7e1968a8d05eea6b4057576f1379013c7f2ef
        bf745589fa5b3f5c48db9dbb18d643c68a15cbf2
        d5c5357e9b5778efd41135b4e1a6056bdbd9caa8
        8dea56207d66f6dfe71ce8dd316ce1ce0d332803
        205015288f6c0bdfc863e498c29c38060ce4739c
        f40dc0c50c3354a987e8bd285058f9549907d05e
        0f7848f832a936edecf672d7c0b24141003f5acb
        fa232d1446d5045b0cad3abbc083edc3063c8a6e
        ca64739e44dafecdc6eba46ac2589305096c19d0
        a32e235cb48e14343a803fe6c795a433938110ee
        bf00d913136ee9d86bbf5d18b8545873005123a3
        2860e21f898bbe889dffdc88b5f795ed1f39ffc3
      )
    end
  end
end
