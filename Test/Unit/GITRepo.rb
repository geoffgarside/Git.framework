describe "GITRepo +repo" do
  before do
    Dir.chdir(TEST_REPO) do
      @repo = GITRepo.repo
    end
  end

  should 'open the repo in the current directory' do
    @repo.root.should.equal TEST_REPO_ROOT
  end
end

describe "GITRepo +repoWithRoot:" do
  describe "with valid repository" do
    before do
      @repo = GITRepo.repoWithRoot(TEST_REPO)
    end

    should "open repo in #{TEST_REPO}" do
      @repo.root.should.equal TEST_REPO_ROOT
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
      @repo = GITRepo.repoWithRoot(TEST_REPO, error:@error)
    end

    should "open repo at " do
      @repo.root.should.equal TEST_REPO_ROOT
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
      @repo = GITRepo.repoWithRoot(File.join(TEST_VOLUME, 'NoPermission'), error:@error)
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
      @repo = GITRepo.repoWithRoot(File.join(TEST_VOLUME, 'Insane'), error:@error)
    end

    should "return nil" do
      @repo.should.be.nil
    end
    should "raise an error" do
      @error[0].should.not.be.nil
    end
    should "raise a path error" do
      @error[0].code.should.equal GITRepoErrorRootInsane
    end
  end
end

describe "GITRepo -branches" do
  before do
    @repo = default_repository
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
    @repo = default_repository
    @sha1 = GITObjectHash.objectHashWithString("fb473b1d24812eb1b212d444b7be8e651c6077ca")
    @commit = @repo.objectWithSha1(@sha1, error:@err)
  end

  should 'not be nil' do
    @commit.should.not.be.nil
  end
  should 'not have an error' do
    @err[0].should.be.nil
  end
  should 'have sha1' do
    @commit.sha1.unpackedString.should == @sha1.unpackedString
  end
end
