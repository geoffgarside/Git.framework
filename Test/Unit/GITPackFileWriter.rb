describe 'GITPackFileWriter' do
  before do
    @err = Pointer.new(:object)
    @repo = simple_repository.git_repo
    @head = GITObjectHash.objectHashWithString(simple_repository.head.sha)
    @commit = @repo.objectWithSha1(@head, error:@err)

    @writer = GITPackFileWriter.packFileWriter
    @writer.addObjectsFromCommit(@commit) unless @writer.nil?
  end
  should 'not be nil' do
    @writer.should.not.be.nil
  end
  should 'have objects' do
    @writer.objects.count.should.be > 0
  end
  describe '-sortedObjectNames' do
    before do
      @objects = @writer.objects.map {|o| o.sha1.unpackedString }
      @sorted  = @writer.sortedObjectNames
    end
    should 'sort the object names' do
      @writer.sortedObjectNames.should === @objects.sort { |a,b| a <=> b }
    end
  end
  describe '-fileName' do
    before do
      simple_repository.repack
      @pack = simple_repository.pack_files.first
    end
    should 'derive a filename from the objects' do
      @writer.fileName.should == File.basename(@pack)
    end
  end
end
