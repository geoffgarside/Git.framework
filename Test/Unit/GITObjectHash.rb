# encoding: utf-8

class GITObjectHash
  def inspect # for readability, esp for -compare: sort failures
    self.description
  end
end

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

  describe "-compare:" do
    before do
      @rhs = GITObjectHash.objectHashWithString(@sha2_str)
    end
    should 'be NSOrderedSame with bed400173 compare bed400173' do
      @hash.compare(@hash).should == NSOrderedSame
    end
    should 'be NSOrderedDescending with bed400173 compare 8c61f6675' do
      # left hand side larger than the right, ie b greater than 8
      @hash.compare(@rhs).should == NSOrderedDescending
    end
    should 'be NSOrderedAscending with 8c61f6675 compare bed400173' do
      # Left hand side is smaller than the right, ie 8 less than b
      @rhs.compare(@hash).should == NSOrderedAscending
    end
    describe 'sorting' do
      before do
        shaA = GITObjectHash.objectHashWithString("f80b1b9f3803ae6fb79ea6393088010769d615ef")
        shaB = GITObjectHash.objectHashWithString("f3bf2cd83a5ffa5332f8c2ac32c36f2da8db9b59")
        shaC = GITObjectHash.objectHashWithString("36effaad2874606ebcfad31dce48d8f6781928ec")
        shaD = GITObjectHash.objectHashWithString("227c6c88ba35e67a1341a068c07d1c1639d6582e")
        shaE = GITObjectHash.objectHashWithString("afc72b2679ebc4d72b08ffe66d1adfb556d96f79")
        shaF = GITObjectHash.objectHashWithString("bd94b5ea8ab503e4e7676ab4668f5f1ec1f523ea")
        shaG = GITObjectHash.objectHashWithString("adc4ee11245f2132df7eaf46851b3dd43870d954")
        shaH = GITObjectHash.objectHashWithString("a2d0bba4b0d4f9bf0168dd68d1588bde05aa3e5b")

        @unsorted = NSArray.arrayWithObjects(shaA, shaB, shaC, shaD, shaE, shaF, shaG, shaH, nil)
        @expected = NSArray.arrayWithObjects(shaD, shaC, shaH, shaG, shaE, shaF, shaB, shaA, nil)
        @sorted = @unsorted.sortedArrayUsingSelector(:'compare:')
      end
      should 'sort the array correctly' do
        @sorted.should == @expected
      end
    end
  end
end
