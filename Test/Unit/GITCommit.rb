class Bacon::Context
  def commitForSha(sha)
    c = NSData.dataWithContentsOfFile("#{@repo.root}/objects/%s/%s" % [sha[0,2], sha[2..-1]]).zlibInflate
    r = c.rangeOfNullTerminatedBytesFrom(0)
    p = c.subdataWithRange(NSMakeRange(7, r.length - 7))
    l = NSString.alloc.initWithData(p, encoding:NSASCIIStringEncoding).to_i
    d = c.subdataWithRange(NSMakeRange(r.length + 1, l))
    GITCommit.commitFromData(d, sha1:GITObjectHash.objectHashWithString("sha"), repo:@repo, error:@err)
  end
end

describe 'GITCommit' do
  before do
    @err = Pointer.new(:object)
    @repo = simple_repository.git_repo
  end
  describe "Non-initial commit" do
    before do
      @commit = commitForSha(simple_repository.commits[1].sha)
      @date   = simple_repository.commits[1].author_date.to_git
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
    should 'reference parent commit' do
      @commit.parentSha1.unpackedString.should == simple_repository.commits[0].sha
    end
    should 'have cachedData' do
      @commit.cachedData.should.not.be.nil
    end
    should 'have author name' do
      @commit.author.name.should == simple_repository.commits[1].author_name
    end
    should 'have author email' do
      @commit.author.email.should == simple_repository.commits[1].author_email
    end
    should 'have author date' do
      @commit.authorDate.date.should === @date.date
      @commit.authorDate.timeZone.should === @date.timeZone
    end
    should 'have committer name' do
      @commit.committer.name.should == simple_repository.commits[1].committer_name
    end
    should 'have committer email' do
      @commit.committer.email.should == simple_repository.commits[1].committer_email
    end
    should 'have committer date ' do
      @commit.committerDate.date.should === @date.date
      @commit.committerDate.timeZone.should === @date.timeZone
    end
    should 'have message' do
      @commit.message.should == "Update testfile.txt\n"
    end
  end
  describe "initial commit" do
    before do
      @commit = commitForSha(simple_repository.commits[0].sha)
    end
    should 'not be nil' do
      @commit.should.not.be.nil
    end
    should 'not have an error' do
      puts @err[0].localizedDescription unless @err[0].nil?
      @err[0].should.be.nil
    end
  end
end
