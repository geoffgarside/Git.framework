describe "GITPackFileWriter" do
  before do
    @err  = Pointer.new(:object)
    @writer = GITPackFileWriter.packWriterVersion(2, error:@err)
  end
  should 'not be nil' do
    @writer.should.not.be.nil
  end
  should 'not give an error' do
    @err[0].should.be.nil
  end
end
