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
  describe "-writeToStream:error:" do
    before do
      @streamErr = Pointer.new(:object)
      @stream = NSOutputStream.outputStreamToMemory
    end
    describe "version one" do
      before do
        @writer = GITPackIndexWriter.indexWriterVersion(1)
        @writer.addObjectWithName(@sha1, andData:@data, atOffset:12)
        @result = @writer.writeToStream(@stream, error:@streamErr)
        @output = @stream.propertyForKey(NSStreamDataWrittenToMemoryStreamKey)
        @index  = GITPackIndex.alloc.initWithData(@output, error:@err)
      end
      should "not have an error" do
        @streamErr[0].should.be.nil
      end
      should "have written to the stream" do
        @output.should.not.be.nil
      end
      should "return 0" do
        @result.should == 0
      end
      should "be a version one index" do
        @index.version.should == 1
      end
      should "have one object" do
        @index.numberOfObjects.should == 1
      end
      should "have pack offset for indexed object" do
        @index.packOffsetForSha1(@sha1).should == 12
      end
    end
    describe "version two" do
      before do
        @writer = GITPackIndexWriter.indexWriterVersion(2)
        @writer.addObjectWithName(@sha1, andData:@data, atOffset:12)
        @result = @writer.writeToStream(@stream, error:@streamErr)
        @output = @stream.propertyForKey(NSStreamDataWrittenToMemoryStreamKey)
        @index  = GITPackIndex.alloc.initWithData(@output, error:@err)
      end
      should "not have an error" do
        @streamErr[0].should.be.nil
      end
      should "have written to the stream" do
        @output.should.not.be.nil
      end
      should "return 0" do
        @result.should == 0
      end
      should "be a version one index" do
        @index.version.should == 2
      end
      should "have one object" do
        @index.numberOfObjects.should == 1
      end
      should "have pack offset for indexed object" do
        @index.packOffsetForSha1(@sha1).should == 12
      end
    end
  end
end
