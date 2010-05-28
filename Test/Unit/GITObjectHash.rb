# encoding: utf-8

describe 'GITObjectHash' do
  before do
    @sha1_str  = 'bed4001738fa8dad666d669867afaf9f2c2b8c6a'
    @sha1_data = @sha1_str.dataUsingEncoding(NSUTF8StringEncoding)
    @sha2_str  = '8c61f6675e9eb20c63cd6757008f4b8a812ecc1a'
    @sha2_data = @sha2_str.dataUsingEncoding(NSUTF8StringEncoding)

    @pack1_data = [@sha1_str].pack('H*').to_data
    @pack2_data = [@sha2_str].pack('H*').to_data
    @hash       = GITObjectHash.objectHashWithString(@sha1_str)
  end

  describe '+unpackedDataFromData:' do
    before do
      @subj = GITObjectHash.unpackedDataFromData(@pack1_data)
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
      @subj.should === @pack1_data
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
      @subj.should === @pack1_data
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

  describe "-isEqual:" do
    before do
      @other = GITObjectHash.objectHashWithData(@pack1_data)
    end

    should "be true with @hash" do
      @other.isEqual(@hash).should.be.true
    end

    should "be true with @sha1_str" do
      @hash.isEqual(@sha1_str).should.be.true
    end

    should "be true with @sha1_data" do
      @hash.isEqual(@sha1_data).should.be.true
    end

    should "be true with @pack1_data" do
      @hash.isEqual(@pack1_data).should.be.true
    end

    should "be false with 1" do
      @hash.isEqual(1).should.be.false
    end

    should "be false with 'hello'" do
      @hash.isEqual('hello').should.be.false
    end

    should "be false with an incorrect sha1 string" do
      @hash.isEqual(@sha2_str).should.be.false
    end

    should "be false with incorrect sha1 data" do
      @hash.isEqual(@sha2_data).should.be.false
    end

    should "be false with incorrect pack data" do
      @hash.isEqual(@pack2_data).should.be.false
    end
  end

  describe "-isEqualToData:" do
    should "be true with @pack1_data" do
      @hash.isEqualToData(@pack1_data).should.be.true
    end

    should "be true with @sha1_data" do
      @hash.isEqualToData(@sha1_data).should.be.true
    end
  end

  describe "-isEqualToString:" do
    should "be true with @sha1_str" do
      @hash.isEqualToString(@sha1_str).should.be.true
    end
  end
end
