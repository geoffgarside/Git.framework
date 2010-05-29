describe "NSData(DeltaPatching)" do
  before do
    delta_string = [0x02, 0x06].pack('C*')  # Header (source size: 2, target size: 6)
    delta_string << [0x01].pack('C*')       # Take one byte from the delta
    delta_string << "F"
    delta_string << [0x90, 0x02].pack('C*') # Take 2 bytes from the source (offset: 0, length: 2)
    delta_string << [0x03].pack('C*')       # Take three bytes from the delta
    delta_string << "bar"

    @data = "oo".to_data
    @delta_data = delta_string.to_data
  end

  should "delta patch data with patch" do
    patched_data = @data.dataByDeltaPatchingWithData(@delta_data)
    patched_data.should.not.be.nil
    NSString.alloc.initWithData(patched_data, encoding:NSASCIIStringEncoding).should == "Foobar"
  end

  should "raise an exception if source size does not match" do
    should.raise(Exception) do
      "o".to_data.dataByDeltaPatchingWithData(@delta_data)
    end
  end
end
