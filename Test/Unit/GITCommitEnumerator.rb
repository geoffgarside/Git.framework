describe "GITCommitEnumerator" do
  before do
    @err = Pointer.new(:object)
    @repo = graph_repository.git_repo
    @head = GITObjectHash.objectHashWithString(graph_repository.head.sha)
    @commit = @repo.objectWithSha1(@head, error:@err)
  end
  should "setup @repo" do
    @repo.should.not.be.nil
  end
  should "setup @head" do
    @head.should.not.be.nil
  end
  should "setup @commit" do
    @commit.should.not.be.nil
  end
  describe "+enumeratorFromCommit:" do
    before do
      @enum = GITCommitEnumerator.enumeratorFromCommit(@commit)
    end
    should "not be nil" do
      @enum.should.not.be.nil
    end
  end
  describe "+enumeratorFromCommit:mode:" do
    before do
      @enum = GITCommitEnumerator.enumeratorFromCommit(@commit, mode:GITCommitEnumeratorBreadthFirstMode)
    end
    should "not be nil" do
      @enum.should.not.be.nil
    end
  end
  describe "Breadth First Mode" do
    before do
      @enum = GITCommitEnumerator.enumeratorFromCommit(@commit)
    end
    describe "-nextObject" do
      should "return the commit on the first pass" do
        @enum.nextObject.should == @commit
      end
      should "return the parent of @commit on second pass" do
        ignored = @enum.nextObject
        @enum.nextObject.sha1.unpackedString.should == graph_repository.head.parents[0].sha
      end
    end
    describe "-nextObject iteration" do
      before do
        @objs = @enum.allObjects  # creates a new array by iterating -nextObject until it gets nil
        @shas = @objs.map { |c| c.sha1.unpackedString }
      end
      should "return sha for first object" do
        @shas[0].should == graph_repository.head.sha
      end
      should "return sha for second object" do
        @shas[1].should == graph_repository.head.parents[0].sha
      end
    end
    describe "-allObjects" do
      before do
        @objects = @enum.allObjects
      end
      should "not be nil" do
        @objects.should.not.be.nil
      end
      should "not be empty" do
        @objects.should.not.be.empty
      end
      should "return objects in a predictable order" do
        # This is unlikely to be as predicted, the ordering of "parent"
        # lines in the commits will directly affect this
        @objects.map { |c| c.sha1.unpackedString }.should == [
          "Graph Nineth Commit",
          "Graph Eighth Commit",
          "Merge branch 'graph-branch2'",
          "Graph Sixth Commit",
          "Merge branch 'graph-branch3' into graph-branch2",
          "Merge branch 'graph-branch1'",
          "Graph Branch 2 Second Commit",
          "Graph Branch 3 Second Commit",
          "Graph Fourth Commit",
          "Graph Branch 1 Third Commit",
          "Graph Branch 2 First Commit",
          "Graph Branch 3 First Commit",
          "Graph Third Commit",
          "Graph Branch 1 Second Commit",
          "Graph Second Commit",
          "Graph Branch 1 First Commit",
          "Graph First Commit"
        ].map { |m| graph_repository.commit(m).sha }
      end
    end
  end
  describe "Depth First Mode" do
    before do
      @enum = GITCommitEnumerator.enumeratorFromCommit(@commit, mode:GITCommitEnumeratorDepthFirstMode)
    end
    describe "-nextObject iteration" do
      before do
        @objs = @enum.allObjects  # creates a new array by iterating -nextObject until it gets nil
        @shas = @objs.map { |c| c.sha1.unpackedString }
      end
      should "return self for first object" do
        @shas[0].should == graph_repository.head.sha
      end
      should "return 'd88c245f270c8d1be05e7dcaefd0a52b58ca4cf3' for second object" do
        @shas[1].should == graph_repository.head.parents[0].sha
      end
    end
    describe "-allObjects" do
      before do
        @objects = @enum.allObjects
      end
      should "not be nil" do
        @objects.should.not.be.nil
      end
      should "not be empty" do
        @objects.should.not.be.empty
      end
      should "return objects in a predictable order" do
        # This is unlikely to be as predicted, the ordering of "parent"
        # lines in the commits will directly affect this
        @objects.map { |c| c.sha1.unpackedString }.should == [
          "Graph Nineth Commit",
          "Graph Eighth Commit",
          "Merge branch 'graph-branch2'",
          "Graph Sixth Commit",
          "Merge branch 'graph-branch1'",
          "Graph Fourth Commit",
          "Graph Third Commit",
          "Graph Second Commit",
          "Graph First Commit",
          "Graph Branch 1 Third Commit",
          "Graph Branch 1 Second Commit",
          "Graph Branch 1 First Commit",
          "Merge branch 'graph-branch3' into graph-branch2",
          "Graph Branch 2 Second Commit",
          "Graph Branch 2 First Commit",
          "Graph Branch 3 Second Commit",
          "Graph Branch 3 First Commit"
        ].map { |m| graph_repository.commit(m).sha }
      end
    end
  end
end
