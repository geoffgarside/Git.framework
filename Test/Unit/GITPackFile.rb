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

describe "GITPackFileVersionTwo with delta base offsets" do
  before do
    @packed_repo = repository "Packed" do
      commit "Initial Commit" do
        write "a.txt", "a" * 4096
      end
      commit "Subsequent Commit" do
        write "a.txt", "a" * 4096 + "foo"
      end
    end

    @packed_repo.repack

    @pth  = @packed_repo.pack_files.first
    @err  = Pointer.new(:object)
    @pack = GITPackFile.packWithPath(@pth, error:@err)
  end

  describe 'unpacking diff packed object' do
    before do
      @sha = GITObjectHash.objectHashWithString('9d235ed07cd19811a6ceb342de82f190e49c9f68')
      @obj = @pack.unpackObjectWithSha1(@sha, error:@err)
    end

    should 'not be nil' do
      @obj.should.not.be.nil
    end

    should 'have correct data' do
      @obj.data.to_str.should == 'a' * 4096
    end
  end

  describe 'unpacking first object' do
    before do
      @sha = GITObjectHash.objectHashWithString('3de87ec8610b04fb16f9cdd605ceb685b9bcbb8b')
      @obj = @pack.unpackObjectWithSha1(@sha, error:@err)
    end

    should 'not be nil' do
      @obj.should.not.be.nil
    end

    should 'have correct data' do
      @obj.data.to_str.should == "a" * 4096 + "foo"
    end
  end
end