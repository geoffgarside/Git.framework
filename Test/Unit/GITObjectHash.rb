# encoding: utf-8

describe 'GITObjectHash' do
  before do
    @sha1_str = 'bed4001738fa8dad666d669867afaf9f2c2b8c6a'
    @sha1_data = @sha1_str.dataUsingEncoding(NSUTF8StringEncoding)
    @pack_str = [@sha1_str].pack('H*')                                  # "¾Ô\x00\x178ú\x8D­fmf\x98g¯¯\x9F,+\x8Cj"
    @pack_data = @pack_str.dataUsingEncoding(NSISOLatin1StringEncoding) # Apparently we need this encoding to work
    @hash = GITObjectHash.objectHashWithString(@sha1_str)               #    with the format created by Array#pack
  end

  describe '+unpackedStringFromString:' do
    before do
      @subj = GITObjectHash.unpackedStringFromString(@pack_str)
    end

    should 'return a NSString' do
      @subj.should.be.kind_of NSString
    end

    should 'return a string 40 characters long' do
      @subj.length.should == GITObjectHashLength
    end

    should 'return a string matching sha1_str' do
      @subj.should === @sha1_str
    end
  end

  describe '+packedStringFromString:' do
    before do
      @subj = GITObjectHash.packedStringFromString(@sha1_str)
    end

    should 'return a NSString' do
      @subj.should.be.kind_of NSString
    end

    should 'return a string 20 characters long' do
      @subj.length.should == GITObjectHashPackedLength
    end

    should 'return a string matching pack_str' do
      @subj.should === @pack_str
    end
  end

  describe '+unpackedDataFromData:' do
    before do
      @subj = GITObjectHash.unpackedDataFromData(@pack_data)
    end

    should 'return NSData' do
      @subj.should.be.kind_of NSData
    end

    should 'return a string 40 bytes long' do
      @subj.length.should == GITObjectHashLength
    end

    should 'return data matching sha1_data' do
      @subj.should === @sha1_data
    end
  end

  describe '+packedDataFromData:' do
    before do
      @subj = GITObjectHash.packedDataFromData(@sha1_data)
    end

    should 'return NSData' do
      @subj.should.be.kind_of NSData
    end

    should 'return a string 20 bytes long' do
      @subj.length.should == GITObjectHashPackedLength
    end

    should 'return data matching pack_data' do
      @subj.should === @pack_data
    end
  end

  describe '-unpackedString' do
    before do
      @subj = @hash.unpackedString
    end

    should 'return a NSString' do
      @subj.should.be.kind_of NSString
    end

    should 'return a string 40 characters long' do
      @subj.length.should == GITObjectHashLength
    end

    should 'return a string matching sha1_str' do
      @subj.should === @sha1_str
    end
  end

  describe '-packedString' do
    before do
      @subj = @hash.packedString
    end

    should 'return a NSString' do
      @subj.should.be.kind_of NSString
    end

    should 'return a string 20 characters long' do
      @subj.length.should == GITObjectHashPackedLength
    end

    should 'return a string matching pack_str' do
      @subj.should === @pack_str
    end
  end

  describe '-unpackedData' do
    before do
      @subj = @hash.unpackedData
    end

    should 'return NSData' do
      @subj.should.be.kind_of NSData
    end

    should 'return a string 40 bytes long' do
      @subj.length.should == GITObjectHashLength
    end

    should 'return data matching sha1_data' do
      @subj.should === @sha1_data
    end
  end

  describe '-packedData' do
    before do
      @subj = @hash.packedData
    end

    should 'return NSData' do
      @subj.should.be.kind_of NSData
    end

    should 'return a string 20 bytes long' do
      @subj.length.should == GITObjectHashPackedLength
    end

    should 'return data matching pack_data' do
      @subj.should === @pack_data
    end
  end
  describe '-hash' do
    before do
      @hashValue = @hash.hash
      @nullValue = 210587549733
    end
    should 'be integer' do
      @hashValue.should.be.kind_of Integer
    end
    should 'not be null valued' do
      @hashValue.should.not == @nullValue
    end
  end
end
