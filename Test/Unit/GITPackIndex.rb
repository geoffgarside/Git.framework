describe "GITPackIndexVersionOne" do
  before do
    @pth = TEST_REPO + '/.git/objects/pack/pack-c06ba93614b53c588dd60781e163889bc7400d42-v1.idx'
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
  should "find a pack offset value of 374 for bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea" do
    hash = GITObjectHash.objectHashWithString("bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea")
    offset = @idx.packOffsetForSha1(hash)
    offset.should == 374
  end
end

describe "GITPackIndexVersionTwo" do
  before do
    @pth = TEST_REPO + '/.git/objects/pack/pack-c06ba93614b53c588dd60781e163889bc7400d42-v2.idx'
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
end
