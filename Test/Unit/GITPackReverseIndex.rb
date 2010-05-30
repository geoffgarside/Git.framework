describe 'GITPackReverseIndex' do
  before do
    simple_repository.repack
    @idx_info = simple_repository.indexes.first
    @pth = @idx_info.file
    @err = Pointer.new(:object)
    @idx = GITPackIndex.packIndexWithPath(@pth, error:@err)
    @rev = @idx.reverseIndex
    @idx_info = @idx_info.to_a
  end

  should 'not be nil' do
    @rev.should.not.be.nil
  end

  describe '-indexWithOffset:' do
    # This is brittle and subject to the PACK index file
    before do
      @off = @rev.indexWithOffset(@idx_info[1][:offset])
    end
    
    should 'not be nil' do
      @off.should.not.be.nil
    end
    should 'equal 1' do
      @off.should == 1
    end
  end
  describe '-nextOffsetAfterOffset:' do
    # This is brittle and subject to the PACK index file
    before do
      @off = @rev.nextOffsetAfterOffset(@idx_info[1][:offset])
    end
    should 'not be nil' do
      @off.should.not.be.nil
    end
    should 'equal 138' do
      @off.should == @idx_info[2][:offset]
    end
  end
  describe '-baseOffsetWithOffset:' do
    before do
      @off = @rev.baseOffsetWithOffset(@idx_info[1][:offset] + 1)
    end
    should 'not be nil' do
      @off.should.not.be.nil
    end
    should 'equal 12' do
      @off.should == @idx_info[1][:offset]
    end
  end
end
