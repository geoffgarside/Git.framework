describe "GITPackFileWriter" do
  before do
    @writer = GITPackFileWriter.packWriterVersion(2)
  end
  should 'not be nil' do
    @writer.should.not.be.nil
  end
end
