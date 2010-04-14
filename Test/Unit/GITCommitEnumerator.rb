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
        @enum.nextObject.sha1.unpackedString.should == "d88c245f270c8d1be05e7dcaefd0a52b58ca4cf3"
      end
    end
    describe "-nextObject iteration" do
      before do
        @objs = @enum.allObjects  # creates a new array by iterating -nextObject until it gets nil
        @shas = @objs.map { |c| c.sha1.unpackedString }
      end
      should "return '42da854703bbcb8694d219f061609ebf286079e3' for first object" do
        @shas[0].should == '42da854703bbcb8694d219f061609ebf286079e3'
      end
      should "return 'd88c245f270c8d1be05e7dcaefd0a52b58ca4cf3' for second object" do
        @shas[1].should == 'd88c245f270c8d1be05e7dcaefd0a52b58ca4cf3'
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
          "42da854703bbcb8694d219f061609ebf286079e3",
          "d88c245f270c8d1be05e7dcaefd0a52b58ca4cf3",
          "f50b98109824b5fd1a9889cc282a6e66923669e4",
          "81aaf3ff89058f53e6afb9cd34c06bf113c1a9da",
          "d0c92769e2cc8e6965300319bf3e458bd65ba4e8",
          "bf745589fa5b3f5c48db9dbb18d643c68a15cbf2",
          "01c7e1968a8d05eea6b4057576f1379013c7f2ef",
          "d5c5357e9b5778efd41135b4e1a6056bdbd9caa8",
          "fa232d1446d5045b0cad3abbc083edc3063c8a6e",
          "f40dc0c50c3354a987e8bd285058f9549907d05e",
          "205015288f6c0bdfc863e498c29c38060ce4739c",
          "8dea56207d66f6dfe71ce8dd316ce1ce0d332803",
          "ca64739e44dafecdc6eba46ac2589305096c19d0",
          "0f7848f832a936edecf672d7c0b24141003f5acb",
          "bf00d913136ee9d86bbf5d18b8545873005123a3",
          "a32e235cb48e14343a803fe6c795a433938110ee",
          "2860e21f898bbe889dffdc88b5f795ed1f39ffc3"]
      end
    end
  end
end

# Idea on how the iteration would proceed with a depth first search
# Iteration | -nextObject | -queue      |
# ---------------------------------------
# 1         | A           | A
# 2         | B           | B,A
# 3         | C *         | C,B,A
# 4         | D           | D,C,B,A
# 5         | E *         | E,D,C,B,A
# 6         | F           | F,E,D,C,B,A
# 7         | G           | G,F,E,D,C,B,A
# 8         | H           | H,G,F,E,D,C,B,A
# 9         | I           | I,H,G,F,E,D,C,B,A
# 10        | J           | J,I,H,G,F,E,D,C,B,A
# 11        | K           | K,E,D,C,B,A
# 12        | L           | L,K,E,D,C,B,A
# 13        | M *         | M,C,B,A
# 14        | N           | N,M,C,B,A
# 15        | O           | O,N,M,C,B,A
# 16        | P           | P,M,C,B,A
# 17        | Q           | Q,P,M,C,B,A
# ---------------------------------------
