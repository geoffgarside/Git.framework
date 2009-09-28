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
end
