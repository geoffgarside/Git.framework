require File.expand_path(File.dirname(__FILE__) +'/../TestHelper.rb')

# Test creation of a GITRef, these do not read from the file system
# under normal circumstances, the GITRefResolver reads the file system.
# The GITRef might be given the ability to write refs to the file system.
describe "GITRef +refWithName:inRepo:" do
  before do
    @ref = GITRef.refWithName("HEAD", inRepo:default_repository)
  end

  should "not be nil" do
    @ref.should.not.be.nil
  end
end
