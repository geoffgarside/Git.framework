describe "GITPackIndexWriter" do
  before do
    @err = Pointer.new(:object)
    @sha1 = GITObjectHash.objectHashWithString('bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea')
    @repo = simple_repository.git_repo
    @data = @repo.objectWithSha1(@sha1, error:@err).rawContent.zlibDeflate

    @writer = GITPackIndexWriter.indexWriterVersion(2)
  end
  should 'not be nil' do
    @writer.should.not.be.nil
  end
  describe "-addObjectWithName:andData:atOffset:" do
    before do
      @writer.addObjectWithName(@sha1, andData:@data, atOffset:12)
    end
    should "increase the number of known objects" do
      @writer.objects.count.should.be > 0
    end
    should "increase the fanout table counter" do
      @writer.fanoutTable[@sha1.firstPackedByte].should.be > 0
    end
  end
end
