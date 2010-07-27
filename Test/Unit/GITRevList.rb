describe "GITRevList" do
  before do
    @err = Pointer.new(:object)
    @repo = graph_repository.git_repo
    @head = GITObjectHash.objectHashWithString(graph_repository.head.sha)
    @commit = @repo.objectWithSha1(@head, error:@err)

    @revList = GITRevList.revListWithCommit(@commit)
  end
  describe "+revListWithCommit:" do
    should "not be nil" do
      @revList.should.not.be.nil
    end
  end
  describe "-subtractDescendentsFromCommit:" do
    before do
      sha_str = graph_repository.commit("Graph Fourth Commit").sha
      sha1 = GITObjectHash.objectHashWithString(sha_str)
      @tail = @repo.objectWithSha1(sha1, error:@err)
      @revList.subtractDescendentsFromCommit(@tail)

      @list = @revList.arrayOfCommitsSortedByDate
      @expected = graph_repository.git("rev-list master ^#{sha_str}").split("\n").map { |l| l.strip }
    end
    should "not include the removed commit" do
      @list.map { |c| c.sha1.unpackedString }.should.not.include(@tail.sha1.unpackedString)
    end
    should "return same list of objects as revlist with ^negation" do
      @list.map { |c| c.sha1.unpackedString }.should == @expected
    end
  end
  describe "-arrayOfCommitsSortedByDate" do
    before do
      @list = @revList.arrayOfCommitsSortedByDate
      @expected = graph_repository.git("rev-list master").split("\n").map { |l| l.strip }
    end
    should "return expected ordering of commits" do
      @list.map { |c| c.sha1.unpackedString }.should == @expected
    end
  end
  describe "-arrayOfCommitsSortedByTopology" do
    before do
      @list = @revList.arrayOfCommitsSortedByTopology
      @expected = graph_repository.git("rev-list --topo-order master").split("\n").map { |l| l.strip }
    end
    should "return expected ordering of commits" do
      @list.map { |c| c.sha1.unpackedString }.should == @expected
    end
  end
  describe "-arrayOfCommitsSortedByTopologyAndDate" do
    before do
      @list = @revList.arrayOfCommitsSortedByTopologyAndDate
      @expected = graph_repository.git("rev-list --date-order master").split("\n").map { |l| l.strip }
    end
    should "return expected ordering of commits" do
      @list.map { |c| c.sha1.unpackedString }.should == @expected
    end
  end
  describe "-arrayOfReachableObjects" do
    before do
      @list = @revList.arrayOfReachableObjects
      @expected = graph_repository.git("rev-list --objects master").split("\n").map { |l| l.strip.split(" ")[0] }
    end
    should "return expected list of objects" do
      @list.map { |o| o.sha1.unpackedString }.should == @expected
    end
    describe "with subtracted commits" do
      before do
        sha_str = graph_repository.commit("Graph Fourth Commit").sha
        sha1 = GITObjectHash.objectHashWithString(sha_str)
        @tail = @repo.objectWithSha1(sha1, error:@err)
        @revList.subtractDescendentsFromCommit(@tail)

        @list = @revList.arrayOfReachableObjects
        @expected = graph_repository.git("rev-list --objects master ^#{sha_str}").split("\n").map { |l| l.strip.split(" ")[0] }
      end
      should "return expected list of objects" do
        @list.map { |o| o.sha1.unpackedString }.should == @expected
      end
    end
  end
end
