describe 'GITLooseObject' do
  before do
    @err = Pointer.new(:object)
    @sha = GITObjectHash.objectHashWithString(simple_repository.head.sha)
    @loose = GITLooseObject.looseObjectWithSha1(@sha, from:simple_repository.objects_path, error:@err)
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
      @repo = simple_repository.git_repo
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
