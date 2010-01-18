describe 'GITLooseObject' do
  before do
    @err = Pointer.new(:object)
    @sha = GITObjectHash.objectHashWithString("fb473b1d24812eb1b212d444b7be8e651c6077ca")
    @loose = GITLooseObject.looseObjectWithSha1(@sha, from:"#{TEST_REPO}/.git/objects", error:@err)
  end
  should 'not be nil' do
    @loose.should.not.be.nil
  end
  should 'not have an error' do
    @err[0].should.be.nil
  end
  should 'have a type' do
    @loose.type.should == GITObjectTypeCommit
  end
  should 'have data' do
    @loose.data.should.not.be.nil
  end
  should 'have sha1' do
    @loose.sha1.unpackedString.should == @sha.unpackedString
  end

  describe '-objectInRepo:error:' do
    before do
      @repo = default_repository
      @commit = @loose.objectInRepo(@repo, error:@err)
    end
    should 'not be nil' do
      @commit.should.not.be.nil
    end
    should 'not have an error' do
      @err[0].should.be.nil
    end
  end
end
