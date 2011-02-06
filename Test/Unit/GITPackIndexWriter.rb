describe "GITPackIndexWriter" do
  before do
    @writer = GITPackIndexWriter.indexWriterVersion(2)
  end
  should 'not be nil' do
    @writer.should.not.be.nil
  end
end
