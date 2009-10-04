require File.expand_path(File.dirname(__FILE__) +'/../TestHelper.rb')

# Test creation of a GITRef, these do not read from the file system
# under normal circumstances, the GITRefResolver reads the file system.
# The GITRef might be given the ability to write refs to the file system.
describe "GITRef +refWithName:andTarget:inRepo:" do
  describe "ref HEAD" do
    before do
      @ref = GITRef.refWithName("HEAD", andTarget:"ref: refs/heads/master", inRepo:DefaultRepository)
    end

    should "not be nil" do
      @ref.should.not.be.nil
    end
    should "be a link" do
      @ref.should.be.link
    end
  end
  describe "ref refs/heads/master" do
    before do
      @ref = GITRef.refWithName("refs/heads/master", andTarget:"6c20014aaa67fc2ac4958f899b6d5494cb30331f", inRepo:DefaultRepository)
    end

    should "not be nil" do
      @ref.should.not.be.nil
    end
    should "not be a link" do
      @ref.should.not.be.link
    end
  end
end
