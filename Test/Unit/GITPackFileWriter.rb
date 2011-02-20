describe "GITPackFileWriter" do
  before do
    @err = Pointer.new(:object)
    @sha1 = GITObjectHash.objectHashWithString(simple_repository.head.sha)
    @repo = simple_repository.git_repo
    @commit = @repo.objectWithSha1(@sha1, error:@err)

    @writer = GITPackFileWriter.packWriterVersion(2)
  end
  should 'not be nil' do
    @writer.should.not.be.nil
  end
  describe "-addObjectsFromCommit:" do
    before do
      @writer.addObjectsFromCommit(@commit)
    end
    should "have added objects" do
      @writer.objects.count.should.be > 0
    end
  end
  describe "-fileName" do
    before do
      simple_repository.repack
      @pack = simple_repository.pack_files.first
      @writer.addObjectsFromCommit(@commit)
    end
    should "be derived from the contained objects" do
      @writer.fileName.should == File.basename(@pack)
    end
  end
  describe "-writeToStream:error:" do
    before do
      @streamErr = Pointer.new(:object)
      @stream = NSOutputStream.outputStreamToMemory
      @writer.addObjectsFromCommit(@commit)
    end
    describe "without an indexWriter" do
      before do
        @result = @writer.writeToStream(@stream, error:@streamErr)
        @output = @stream.propertyForKey(NSStreamDataWrittenToMemoryStreamKey)
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
      should 'write the signature' do
        @output.subdataWithRange(NSMakeRange(0,4)).to_str.should == 'PACK'
      end
      should 'write the version number' do
        @output.subdataWithRange(NSMakeRange(4,4)).to_str.unpack('N')[0].should == 2
      end
    end
    describe "with an indexWriter" do
      before do
        @idxErr = Pointer.new(:object)
        @idxStrm = NSOutputStream.outputStreamToMemory
        @idxWriter = GITPackIndexWriter.indexWriter

        # TODO: Fix this API, its a bit rubbish really
        @writer.indexWriter = @idxWriter
        @result = @writer.writeToStream(@stream, error:@streamErr)
        @idxRes = @idxWriter.writeToStream(@idxStrm, error:@idxErr)

        @output = @stream.propertyForKey(NSStreamDataWrittenToMemoryStreamKey)
        @idxOut = @idxStrm.propertyForKey(NSStreamDataWrittenToMemoryStreamKey)

        @indxFile = GITPackIndex.alloc.initWithData(@idxOut, error:@err)
        @packFile = GITPackFile.alloc.initWithData(@output, indexPath:nil, error:@err)
        @packFile.index = @indxFile
      end
      should "not have stream errors" do
        @streamErr[0].should.be.nil
        @idxErr[0].should.be.nil
      end
      should "have written to the stream" do
        @output.should.not.be.nil
        @idxOut.should.not.be.nil
      end
      should "return 0" do
        @result.should == 0
        @idxRes.should == 0
      end
      should "have matching numbers of objects" do
        @packFile.numberOfObjects.should == @indxFile.numberOfObjects
      end
    end
  end
end
