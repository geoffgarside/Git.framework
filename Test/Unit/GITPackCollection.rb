describe 'GITPackCollection' do
  before do
    @err = Pointer.new(:object)
    @collection = GITPackCollection.collectionWithContentsOfDirectory("#{TEST_REPO}/.git/objects/pack", error:@err)
  end
  should 'not be nil' do
    @collection.should.not.be.nil
  end
  should 'not have an error' do
    @err[0].should.be.nil
  end

  describe '-unpackObjectWithSha1:error:' do
    before do
      @sha = GITObjectHash.objectHashWithString("6c20014aaa67fc2ac4958f899b6d5494cb30331f")
      @obj = @collection.unpackObjectWithSha1(@sha, error:@err)
    end
    should 'not be nil' do
      @obj.should.not.be.nil
    end
    should 'not have an error' do
      @err[0].should.be.nil
    end
    should 'have found the correct object' do
      @obj.sha1.unpackedString.should == @sha.unpackedString
    end
  end
end
