require File.expand_path(File.dirname(__FILE__) +'/../TestHelper.rb')

describe "GITRefResolver +resolverForRepo:" do
  before do
    @resolver = GITRefResolver.resolverForRepo(default_repository);
  end

  should "not be nil" do
    @resolver.should.not.be.nil
  end
end

describe "GITRefResolver -resolveRefWithName:" do
  before do
    @resolver = GITRefResolver.resolverForRepo(default_repository);
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
