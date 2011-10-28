describe "GITRepo +repo" do
  before do
    Dir.chdir(simple_repository.root) do
      @repo = GITRepo.repo
    end
  end

  should "open the repo in the current directory" do
    @repo.root.should.equal "#{simple_repository.root}/.git"
  end
end

describe "GITRepo +repoWithRoot:" do
  describe "with valid repository" do
    before do
      @repo = GITRepo.repoWithRoot(simple_repository.root)
    end

    should "open repo in correct directory" do
      @repo.root.should.equal "#{simple_repository.root}/.git"
    end
  end
  describe "with nonexistent repository" do
    before do
      @repo = GITRepo.repoWithRoot("/nonexistent")
    end

    should "be nil" do
      @repo.should.be.nil
    end
  end
end

describe "GITRepo +repoWithRoot:error:" do
  before do
    @error = Pointer.new(:object)
  end
  describe "with valid repository" do
    before do
      @repo = GITRepo.repoWithRoot(simple_repository.root, error:@error)
    end

    should "open repo at " do
      @repo.root.should.equal "#{simple_repository.root}/.git"
    end
    should "not raise an error" do
      @error[0].should.be.nil
    end
  end
  describe "with nonexistent path" do
    before do
      @repo = GITRepo.repoWithRoot('/nonexistent', error:@error)
    end

    should "return nil" do
      @repo.should.be.nil
    end
    should "raise an error" do
      @error[0].should.not.be.nil
    end
    should "raise a path error" do
      @error[0].code.should.equal GITRepoErrorRootDoesNotExist
    end
  end
  describe "with no permission to path" do
    before do
      `chmod a-w #{simple_repository.root}/.git`
      @repo = GITRepo.repoWithRoot(simple_repository.root, error:@error)
    end

    after do
      # So that we can remove the repository
      `chmod a+w #{simple_repository.root}/.git`
    end

    should "return nil" do
      @repo.should.be.nil
    end
    should "raise an error" do
      @error[0].should.not.be.nil
    end
    should "raise a path error" do
      @error[0].code.should.equal GITRepoErrorRootNotAccessible
    end
  end
  describe "with insane looking repository" do
    before do
      FileUtils.rm_rf("#{simple_repository.root}/.git/refs")
      @repo = GITRepo.repoWithRoot(simple_repository.root, error:@error)
    end

    should "return nil" do
      @repo.should.be.nil
    end
    should "raise an error" do
      @error[0].should.not.be.nil
    end
    should "raise a sanity error" do
      @error[0].code.should.equal GITRepoErrorRootInsane
    end
  end
  describe "with missing .git/branches directory" do
    before do
      FileUtils.rm_rf("#{simple_repository.root}/.git/branches")
      @repo = GITRepo.repoWithRoot(simple_repository.root, error:@error)
    end

    should "open repo" do
      @repo.root.should.equal "#{simple_repository.root}/.git"
    end
    should "not raise an error" do
      @error[0].should.be.nil
    end
  end
end

describe "GITRepo -branches" do
  before do
    @repo = simple_repository.git_repo
    @branches = @repo.branches.map(&:name)
  end

  should "include 'master'" do
    @branches.should.include('master')
  end
  should "include 'another'" do
    @branches.should.include('another')
  end
end

describe "GITRepo -objectWithSha1:error:" do
  before do
    @err = Pointer.new(:object)
    @repo = simple_repository.git_repo
    @sha1 = GITObjectHash.objectHashWithString(simple_repository.commit('Update testfile.txt').sha)
    @commit = @repo.objectWithSha1(@sha1, error:@err)
  end

  should "not be nil" do
    @commit.should.not.be.nil
  end
  should "not have an error" do
    @err[0].should.be.nil
  end
  should "have sha1" do
    @commit.sha1.unpackedString.should == @sha1.unpackedString
  end
end

describe "GITRepo Enumerators" do
  before do
    @repo = simple_repository.git_repo
  end
  describe "-enumerator" do
    before do
      @enum = @repo.enumerator
    end
    should "not be nil" do
      @enum.should.not.be.nil
    end
  end
  describe "-enumeratorWithMode:" do
    before do
      @enum = @repo.enumeratorWithMode(GITCommitEnumeratorBreadthFirstMode)
    end
    should "not be nil" do
      @enum.should.not.be.nil
    end
  end
end

describe "GITRepo -head" do
  before do
    @repo = simple_repository.git_repo
  end
  should "not be nil" do
    @repo.head.should.not.be.nil
  end
end

describe "GITRepo -tags" do
  before do
    @repo = simple_repository.git_repo
    @tags = @repo.tags
  end
  should 'not be empty' do
    @tags.count.should.be > 0
  end
  should 'contain GITTag objects' do
    @tags.each do |tag|
      tag.should.be.kind_of(GITTag)
    end
  end
end

describe "GITRepo -revList" do
  before do
    @repo = graph_repository.git_repo
    @revList = @repo.revList
  end
  should "not be nil" do
    @revList.should.not.be.nil
  end
  should "be a GITRevList object" do
    @revList.should.be.kind_of GITRevList
  end
end

describe "GITRepo -revListFromCommit:" do
  before do
    @repo = graph_repository.git_repo
    @revList = @repo.revListFromCommit(@repo.head)
  end
  should "not be nil" do
    @revList.should.not.be.nil
  end
  should "be a GITRevList object" do
    @revList.should.be.kind_of GITRevList
  end
end

describe "GITRepo Rev-List Methods" do
  before do
    @repo = graph_repository.git_repo
  end
  describe "-revListSortedByDate" do
    before do
      @list = @repo.revListSortedByDate
      @expected = graph_repository.git("rev-list master").split("\n").map { |l| l.strip }
    end
    should "return expected ordering of commits" do
      @list.map { |c| c.sha1.unpackedString }.should == @expected
    end
  end
  describe "-revListSortedByTopology" do
    before do
      @list = @repo.revListSortedByTopology
      @expected = graph_repository.git("rev-list --topo-order master").split("\n").map { |l| l.strip }
    end
    should "return expected ordering of commits" do
      @list.map { |c| c.sha1.unpackedString }.should == @expected
    end
  end
  describe "-revListSortedByTopologyAndDate" do
    before do
      @list = @repo.revListSortedByTopologyAndDate
      @expected = graph_repository.git("rev-list --date-order master").split("\n").map { |l| l.strip }
    end
    should "return expected ordering of commits" do
      @list.map { |c| c.sha1.unpackedString }.should == @expected
    end
  end
end

describe "GITRepo +createRepoAtPath:error:" do
  before do
    @err  = Pointer.new(:object)
    @path = File.expand_path("Created", tmp_dir)
    @root = File.expand_path(".git", @path)
    @repo = GITRepo.createRepoAtPath(@path, error:@err)
  end
  after do
    FileUtils.rm_r(@path)
  end
  should "not raise an error" do
    unless @err[0].nil?
      puts @err[0].localizedDescription
    end
    @err[0].should.be.nil
  end
  should "not return nil" do
    @repo.should.not.be.nil
  end
  should "create .git directory" do
    File.exists?(@root).should.be.true
  end
  should "create skeleton directories and files" do
    %w(branches config description HEAD hooks info info/exclude objects objects/info objects/pack refs refs/heads refs/tags).each do |f|
      File.exists?(File.join(@root, f)).should.be.true
    end
  end
end
