require 'zlib'

class Bacon::Context
  def tagForSha(sha)
    file = "#{simple_repository.root}/.git/objects/%s/%s" % [sha[0,2], sha[2..-1]]
    meta, data = Zlib::Inflate.inflate(File.read(file)).split("\x00")
    GITTag.tagFromData(data.to_data, sha1:GITObjectHash.objectHashWithString("sha"), repo:@repo, error:@err)
  end
end

describe 'GITTag' do
  before do
    @err  = Pointer.new(:object)
    @repo = simple_repository.git_repo
    @info = simple_repository.tags['v0.0.0']
    @tag  = tagForSha(@info.sha)
    @date = @info.date.to_git
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
  should 'reference object' do
    @tag.targetSha1.unpackedString.should == @info.ref
  end
  should 'have name v0.0.0' do
    @tag.name.should == 'v0.0.0'
  end
  should 'have cachedData' do
    @tag.cachedData.should.not.be.nil
  end
  should 'have tagger "Geoff Garside"' do
    @tag.tagger.name.should == @info.tagger_name
  end
  should 'have tagger email "geoff@geoffgarside.co.uk"' do
    @tag.tagger.email.should == @info.tagger_email
  end
  should 'have author date' do
    @tag.taggerDate.date.should === @date.date
    @tag.taggerDate.timeZone.should === @date.timeZone
  end
  should 'have message' do
    @tag.message.should == "v0.0.0"
  end
end
