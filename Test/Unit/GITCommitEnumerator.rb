describe "GITCommitEnumerator" do
  before do
    @err = Pointer.new(:object)
    @repo = default_repository
    @head = GITObjectHash.objectHashWithString("42da854703bbcb8694d219f061609ebf286079e3")
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
  describe "-nextObject" do
    before do
      @enum = GITCommitEnumerator.enumeratorFromCommit(@commit)
    end
    should "return the commit on the first pass" do
      @enum.nextObject.should == @commit
    end
    should "return the parent of @commit on second pass" do
      ignored = @enum.nextObject
      @enum.nextObject.sha1.unpackedString.should == "d88c245f270c8d1be05e7dcaefd0a52b58ca4cf3"
    end
  end
end
