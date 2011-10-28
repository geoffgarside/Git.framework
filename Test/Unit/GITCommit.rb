require 'zlib'

class Bacon::Context
  def commitDataForSha(sha)
    file = "#{simple_repository.root}/.git/objects/%s/%s" % [sha[0,2], sha[2..-1]]
    Zlib::Inflate.inflate(File.read(file)).split("\x00", 2)[1].to_data
  end
  def commitForSha(sha)
    d = commitDataForSha(sha)
    GITCommit.commitFromData(d, sha1:GITObjectHash.objectHashWithString(sha), repo:@repo, error:@err)
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
    describe '-rawContent' do
      before do
        @data = commitDataForSha(@commit.sha1.unpackedString)
      end
      should 'return formatted commit' do
        @commit.rawContent.should === @data
      end
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
