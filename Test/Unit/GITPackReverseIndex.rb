describe 'GITPackReverseIndex' do
  before do
    @pth = TEST_REPO + '/.git/objects/pack/pack-c06ba93614b53c588dd60781e163889bc7400d42-v2.idx'
    @err = Pointer.new(:object)
    @idx = GITPackIndex.packIndexWithPath(@pth, error:@err)
    @rev = @idx.reverseIndex
  end

  should 'not be nil' do
    @rev.should.not.be.nil
  end

  describe '-indexWithOffset:' do
    # This is brittle and subject to the PACK index file
    before do
      @off = @rev.indexWithOffset(12)
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
      @off = @rev.nextOffsetAfterOffset(12)
    end
    should 'not be nil' do
      @off.should.not.be.nil
    end
    should 'equal 138' do
      @off.should == 138
    end
  end
  describe '-baseOffsetWithOffset:' do
    before do
      @off = @rev.baseOffsetWithOffset(14)
    end
    should 'not be nil' do
      @off.should.not.be.nil
    end
    should 'equal 12' do
      @off.should == 12
    end
  end
end
