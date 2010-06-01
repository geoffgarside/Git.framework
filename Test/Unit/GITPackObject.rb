describe 'GITPackObject' do
  before do
    simple_repository.repack
    @sha = GITObjectHash.objectHashWithString(simple_repository.commit('Initial commit').sha)
    @pth = simple_repository.pack_files.first
    @err = Pointer.new(:object)
    @pack = GITPackFile.packWithPath(@pth, error:@err)
  end

  describe '+packObjectWithData:type:' do
    before do
      @obj = @pack.unpackObjectWithSha1(@sha, error:@err)
    end
    should 'not be nil' do
      @obj.should.not.be.nil
    end
    should 'have type: GITObjectTypeCommit' do
      @obj.type.should == GITObjectTypeCommit
    end
  end
end
