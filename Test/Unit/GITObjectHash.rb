describe "GITObjectHash +unpackedStringFromString:" do
  before do
    @hash = "bed4001738fa8dad666d669867afaf9f2c2b8c6a"
    @pack = "\276\324\000\0278\372\215\255fmf\230g\257\257\237,+\214j"
    @test = GITObjectHash.unpackedStringFromString(@pack)
  end

  should 'unpack packed string into string' do
    @test.should === @hash
  end
end

describe "GITObjectHash +packedStringFromString:" do
  before do
    @hash = "bed4001738fa8dad666d669867afaf9f2c2b8c6a"
    @pack = "\276\324\000\0278\372\215\255fmf\230g\257\257\237,+\214j"
    @test = GITObjectHash.packedStringFromString(@hash)
  end

  should 'pack unpacked string into string' do
    @test.should === @pack
  end
end

describe "GITObjectHash +unpackedDataFromData:" do
  # By implementation this tests +unpackedDataFromBytes:length:
  before do
    @hash = "bed4001738fa8dad666d669867afaf9f2c2b8c6a".dataUsingEncoding(NSUTF8StringEncoding)
    @data = "\276\324\000\0278\372\215\255fmf\230g\257\257\237,+\214j".dataUsingEncoding(NSUTF8StringEncoding)
    @test = GITObjectHash.unpackedDataFromData(@data)
  end

  should 'unpack packed data into data' do
    @test.should === @hash   # maybe use -isEqualToData:
  end
end

describe "GITObjectHash +packedDataFromData:" do
  # By implementation this tests +packedDataFromBytes:length:
  before do
    @hash = "bed4001738fa8dad666d669867afaf9f2c2b8c6a"
    @pack = "\276\324\000\0278\372\215\255fmf\230g\257\257\237,+\214j".dataUsingEncoding(NSUTF8StringEncoding)
    @test = GITObjectHash.packedDataFromData(@hash)
  end

  should 'pack unpacked string into string' do
    @test.should === @pack
  end
end
