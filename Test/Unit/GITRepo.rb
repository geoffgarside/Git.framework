require File.expand_path(File.dirname(__FILE__) +'/../TestHelper.rb')

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
