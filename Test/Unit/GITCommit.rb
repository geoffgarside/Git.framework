describe 'GITCommit' do
  before do
    @err = Pointer.new(:object)
    @repo = default_repository
    @commitData = NSData.dataWithContentsOfFile("#{TEST_REPO}/.git/objects/fb/473b1d24812eb1b212d444b7be8e651c6077ca").zlibInflate
    @data = @commitData.subdataWithRange(NSMakeRange(11, 248))    # This is specific to this object
    @commit = GITCommit.commitFromData(@data, repo:@repo, error:@err)
    @date = GITDateTime.dateTimeWithTimestamp(1263165097, timeZoneOffset:"+0000")
  end
  should 'not be nil' do
    @commit.should.not.be.nil
  end
  should 'not have an error' do
    @err[0].should.be.nil
  end
  should 'belong to repo' do
    @commit.repo.should == @repo
  end
  should 'reference tree "adc4ee11245f2132df7eaf46851b3dd43870d954"' do
    @commit.treeSha1.unpackedString.should == "adc4ee11245f2132df7eaf46851b3dd43870d954"
  end
  should 'reference parent "6c20014aaa67fc2ac4958f899b6d5494cb30331f"' do
    @commit.parentSha1.unpackedString.should == "6c20014aaa67fc2ac4958f899b6d5494cb30331f"
  end
  should 'have cachedData' do
    @commit.cachedData.should.not.be.nil
  end
  should 'have author "Geoff Garside"' do
    @commit.author.name.should == "Geoff Garside"
  end
  should 'have author email "geoff@geoffgarside.co.uk"' do
    @commit.author.email.should == 'geoff@geoffgarside.co.uk'
  end
  should 'have author date' do
    @commit.authorDate.date.should === @date.date
    @commit.authorDate.timeZone.should === @date.timeZone
  end
  should 'have committer "Geoff Garside"' do
    @commit.committer.name.should == "Geoff Garside"
  end
  should 'have committer email "geoff@geoffgarside.co.uk"' do
    @commit.committer.email.should == 'geoff@geoffgarside.co.uk'
  end
  should 'have committer date ' do
    @commit.committerDate.date.should === @date.date
    @commit.committerDate.timeZone.should === @date.timeZone
  end
  should 'have message' do
    @commit.message.should == "Update testfile.txt"
  end
end
