# Test creation of a GITRef, these do not read from the file system
# under normal circumstances, the GITRefResolver reads the file system.
# The GITRef might be given the ability to write refs to the file system.
describe "GITRef +refWithName:andTarget:inRepo:" do
  describe "ref HEAD" do
    before do
      @ref = GITRef.refWithName("HEAD", andTarget:"ref: refs/heads/master", inRepo:default_repository)
    end

    should "not be nil" do
      @ref.should.not.be.nil
    end
    should "be a link" do
      @ref.should.be.link
    end
    should "have name 'HEAD'" do
      @ref.name.should == 'HEAD'
    end
    should "target 'ref: refs/heads/master'" do
      @ref.targetName.should == 'ref: refs/heads/master'
    end
  end
  describe "ref refs/heads/master" do
    before do
      @ref = GITRef.refWithName("refs/heads/master", andTarget:"6c20014aaa67fc2ac4958f899b6d5494cb30331f", inRepo:default_repository)
    end

    should "not be nil" do
      @ref.should.not.be.nil
    end
    should "not be a link" do
      @ref.should.not.be.link
    end
    should "have name 'refs/heads/master'" do
      @ref.name.should == 'refs/heads/master'
    end
    should "target '6c20014aaa67fc2ac4958f899b6d5494cb30331f'" do
      @ref.targetName.should == '6c20014aaa67fc2ac4958f899b6d5494cb30331f'
    end
  end
end

describe "GITRef -resolve" do
  describe "with link ref" do
    before do
      @ref = GITRef.refWithName("HEAD", andTarget:"ref: refs/heads/master", inRepo:default_repository)
      @res = @ref.resolve
    end

    should "not be nil" do
      @res.should.not.be.nil
    end
    should "return GITRef" do
      @res.class.should == GITRef
    end
    should "return ref with name 'refs/heads/master'" do
      @res.name.should == 'refs/heads/master'
    end
  end
  describe "with fixed ref" do
    before do
      @ref = GITRef.refWithName("refs/heads/master", andTarget:"6c20014aaa67fc2ac4958f899b6d5494cb30331f", inRepo:default_repository)
      @res = @ref.resolve
    end

    should "not be nil" do
      @res.should.not.be.nil
    end
    should "be equal to subject" do
      @res.should == @ref
    end
  end
end
