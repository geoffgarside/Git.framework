describe "GITPackIndexVersionOne" do
  before do
    simple_repository.repack
    @idx_info = simple_repository.v1_indexes.first
    @pth = @idx_info.file
    @err = Pointer.new(:object)
    @idx = GITPackIndex.packIndexWithPath(@pth, error:@err)
  end

  should "not be nil" do
    @idx.should.not.be.nil
  end
  should "not have an error" do
    @err[0].should.be.nil
  end
  should "be version 1" do
    @idx.version.should == 1
  end
  should "parse the fanout table" do
    @idx.fanoutTable(@err).should.not.be.nil
    @err[0].should.be.nil
  end
  should "find index of blob object bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea in index" do
    hash = GITObjectHash.objectHashWithString("bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea")
    index = @idx.indexOfSha1(hash)
    index.should.not == NSNotFound
  end
  should "find a pack offset value for bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea" do
    hash = GITObjectHash.objectHashWithString("bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea")
    offset = @idx.packOffsetForSha1(hash)
    offset.should == @idx_info["bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea"]
  end
end

describe "GITPackIndexVersionTwo" do
  before do
    simple_repository.repack
    @idx_info = simple_repository.indexes.first
    @pth = simple_repository.index_files.first
    @err = Pointer.new(:object)
    @idx = GITPackIndex.packIndexWithPath(@pth, error:@err)
  end

  should "not be nil" do
    @idx.should.not.be.nil
  end
  should "not have an error" do
    @err[0].should.be.nil
  end
  should "be version 2" do
    @idx.version.should == 2
  end
  should "parse the fanout table" do
    @idx.fanoutTable(@err).should.not.be.nil
    @err[0].should.be.nil
  end
  should "find index of blob object bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea in index" do
    hash = GITObjectHash.objectHashWithString("bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea")
    index = @idx.indexOfSha1(hash)
    index.should.not == NSNotFound
  end
  should "find a pack offset value for bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea" do
    hash = GITObjectHash.objectHashWithString("bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea")
    offset = @idx.packOffsetForSha1(hash)
    offset.should == @idx_info['bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea']
  end
end
