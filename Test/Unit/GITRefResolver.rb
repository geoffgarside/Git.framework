describe "GITRefResolver +resolverForRepo:" do
  before do
    @resolver = GITRefResolver.resolverForRepo(simple_repository.git_repo);
  end

  should "not be nil" do
    @resolver.should.not.be.nil
  end
end

describe "GITRefResolver -resolveRefWithName:" do
  before do
    @resolver = GITRefResolver.resolverForRepo(simple_repository.git_repo);
  end

  describe "HEAD" do
    before do
      @ref = @resolver.resolveRefWithName("HEAD")
    end

    should "not be nil" do
      @ref.should.not.be.nil
    end
    should "have name 'HEAD'" do
      @ref.name.should == 'HEAD'
    end
    should "have targetName 'ref: refs/heads/master'" do
      @ref.targetName.should == 'ref: refs/heads/master'
    end
  end

  describe "refs/heads/master" do
    before do
      @ref = @resolver.resolveRefWithName("refs/heads/master")
    end

    should "not be nil" do
      @ref.should.not.be.nil
    end
    should "have name 'refs/heads/master'" do
      @ref.name.should == 'refs/heads/master'
    end
  end

  describe "heads/master" do
    before do
      @ref = @resolver.resolveRefWithName("heads/master")
    end

    should "not be nil" do
      @ref.should.not.be.nil
    end
    should "have name 'refs/heads/master'" do
      @ref.name.should == 'refs/heads/master'
    end
  end

  describe "packed ref tags/v0.0.0" do
    before do
      @ref = @resolver.resolveRefWithName("tags/v0.0.0")
    end

    should "not be nil" do
      @ref.should.not.be.nil
    end
    should "have name 'refs/tags/v0.0.0'" do
      @ref.name.should == 'refs/tags/v0.0.0'
    end
  end
end

describe "GITRefResolver -allRefs" do
  before do
    @resolver = GITRefResolver.resolverForRepo(simple_repository.git_repo);
    @refs = @resolver.allRefs.map(&:name)
  end

  should "not be empty" do
    @refs.should.not.be.empty
  end
  should "contain 'refs/heads/master'" do
    @refs.should.include 'refs/heads/master'
  end
  should "contain 'refs/heads/another'" do
    @refs.should.include 'refs/heads/another'
  end
  should "contain 'refs/tags/v0.0.0'" do
    @refs.should.include 'refs/tags/v0.0.0'
  end
end

describe "GITRefResolver -headRefs" do
  before do
    @resolver = GITRefResolver.resolverForRepo(simple_repository.git_repo);
    @refs = @resolver.headRefs.map(&:name)
  end

  should "not be empty" do
    @refs.should.not.be.empty
  end
  should "contain 'refs/heads/master'" do
    @refs.should.include 'refs/heads/master'
  end
  should "contain 'refs/heads/another'" do
    @refs.should.include 'refs/heads/another'
  end
end

describe "GITRefResolver -tagRefs" do
  before do
    @resolver = GITRefResolver.resolverForRepo(simple_repository.git_repo);
    @refs = @resolver.tagRefs.map(&:name)
  end

  should "not be empty" do
    @refs.should.not.be.empty
  end
  should "contain 'refs/tags/v0.0.0'" do
    @refs.should.include 'refs/tags/v0.0.0'
  end
end
