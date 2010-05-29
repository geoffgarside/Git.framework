describe 'GITPackCollection' do
  before do
    simple_repository.repack
    @err = Pointer.new(:object)
    @collection = GITPackCollection.collectionWithContentsOfDirectory(simple_repository.pack_path, error:@err)
  end
  should 'not be nil' do
    @collection.should.not.be.nil
  end
  should 'not have an error' do
    @err[0].should.be.nil
  end

  describe '-unpackObjectWithSha1:error:' do
    before do
      @sha = GITObjectHash.objectHashWithString(simple_repository.commit("Initial commit").sha)
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
