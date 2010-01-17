describe 'GITTag' do
  before do
    @err = Pointer.new(:object)
    @repo = default_repository
    @tagData = NSData.dataWithContentsOfFile("#{TEST_REPO}/.git/objects/e5/0d1a7b4659ad79d146cb75177ba65b045381dd").zlibInflate
    @data = @tagData.subdataWithRange(NSMakeRange(8, 144))    # This is specific to this object
    @tag = GITTag.tagFromData(@data, sha1:GITObjectHash.objectHashWithString("e50d1a7b4659ad79d146cb75177ba65b045381dd"), repo:@repo, error:@err)
    @date = GITDateTime.dateTimeWithTimestamp(1254663297, timeZoneOffset:"+0100")
  end
  should 'not be nil' do
    @tag.should.not.be.nil
  end
  should 'not have an error' do
    @err[0].should.be.nil
  end
  should 'belong to repo' do
    @tag.repo.should == @repo
  end
  should 'reference object "6c20014aaa67fc2ac4958f899b6d5494cb30331f"' do
    @tag.targetSha1.unpackedString.should == "6c20014aaa67fc2ac4958f899b6d5494cb30331f"
  end
  should 'have name v0.0.0' do
    @tag.name.should == 'v0.0.0'
  end
  should 'have cachedData' do
    @tag.cachedData.should.not.be.nil
  end
  should 'have tagger "Geoff Garside"' do
    @tag.tagger.name.should == "Geoff Garside"
  end
  should 'have tagger email "geoff@geoffgarside.co.uk"' do
    @tag.tagger.email.should == 'geoff@geoffgarside.co.uk'
  end
  should 'have author date' do
    @tag.taggerDate.date.should === @date.date
    @tag.taggerDate.timeZone.should === @date.timeZone
  end
  should 'have message' do
    @tag.message.should == "v0.0.0"
  end
end
