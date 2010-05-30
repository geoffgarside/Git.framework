describe "GITPackFileVersionTwo" do
  before do
    simple_repository.repack
    @pth  = simple_repository.pack_files.first
    @err  = Pointer.new(:object)
    @pack = GITPackFile.packWithPath(@pth, error:@err)
  end

  should 'not be nil' do
    @pack.should.not.be.nil
  end

  should 'not have an error' do
    @err[0].should.be.nil
  end

  should 'be version 2' do
    @pack.version.should == 2
  end

  should 'have an index' do
    @pack.index.should.not.be.nil
    @pack.index.should.be.kind_of GITPackIndex
  end

  should 'have some objects' do
    @pack.numberOfObjects.should.be > 0
  end

  describe '-unpackObjectWithSha1:error:' do
    before do
      @sha = GITObjectHash.objectHashWithString(simple_repository.commit('Initial commit').sha)
      @obj = @pack.unpackObjectWithSha1(@sha, error:@err)
    end
    should 'not be nil' do
      @obj.should.not.be.nil
    end
    should 'not have an error' do
      @err[0].should.be.nil
    end
    should 'be kind of GITPackObject' do
      @obj.should.be.kind_of GITPackObject
    end
  end
end
