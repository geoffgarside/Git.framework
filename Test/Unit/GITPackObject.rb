describe 'GITPackObject' do
  before do
    @sha = GITObjectHash.objectHashWithString('6c20014aaa67fc2ac4958f899b6d5494cb30331f')
    @pth = TEST_REPO + "/.git/objects/pack/pack-c06ba93614b53c588dd60781e163889bc7400d42.pack"
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
